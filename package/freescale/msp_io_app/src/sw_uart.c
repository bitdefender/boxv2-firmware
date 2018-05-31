/******************************************************************************
 *                                                                            *
 *  Mindspeed Technologies                                                    *
 *  MultiService Access division                                              *
 *                                                                            *
 *  Freescale                                                    *
 *  Copyright (C) 2014, All rights reserved                                   *
 *                                                                             *
 *  Module  : sw_uart.c                                                    *
 *                                                                            *
 *  Content : MSP/DSP <> ACP SW UART tool                                                           *
 *                                                                            *
 *  S/E   Date               Revision history                              *
 *  ----  ---------          ----------------------------------------------*
 *        2014-Sep             Created.                                      *
 ******************************************************************************/


#include "sw_uart.h"

struct sys_rt_irq_thread    sw_uart_rt_irq;
int                         sw_uart_thread_running = 1;

unsigned char               *sdram_buffer;

PSW_UART_CTX                pSwUartCtx;

static int                  sw_uart_mem_fd;
static int                  sw_uart_mem_page_size;
u_int32_t                   *sw_uart_mem = NULL;
u_int32_t                   sw_uart_mem_offset;
static unsigned int         sw_uart_mem_p2v_offset;
static unsigned int         SwUartMsgSN = 0;


int sw_uart_check_msp_msg(void);
void sw_uart_send_acp_to_msp(char *buffer, unsigned int length, unsigned short src_id);
#ifdef SW_UART_DSP
int sw_uart_check_dsp_msg(void);
void sw_uart_send_acp_to_dsp(char *buffer, unsigned int length, unsigned short src_id);
#endif

static u_int32_t phys2page_offset(u_int32_t phys_addr, u_int32_t *page_addr)
{
    u_int32_t *mem;
    u_int32_t i;

    phys_addr &= ~(sizeof(mem[0]) - 1);
    *page_addr = phys_addr & ~(sw_uart_mem_page_size - 1);
    i = (phys_addr - *page_addr) / sizeof(mem[0]);

    return i;
}

u_int32_t * mmio_mmap(u_int32_t phys_addr, int prot, u_int32_t *offset)
{
    u_int32_t page_addr;
    u_int32_t *mem;

    *offset = phys2page_offset(phys_addr, &page_addr);

    mem = mmap(NULL, COMCERTO_MSP_DDR_SIZE_SW_UART, prot, MAP_SHARED, sw_uart_mem_fd, page_addr);    
    if (mem == MAP_FAILED) {
        perror("mmap()");
        return NULL;
    }

    return mem;
}

int mmio_init(void)
{
    sw_uart_mem_page_size = getpagesize();
    sw_uart_mem_fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (sw_uart_mem_fd < 0)
        return sw_uart_mem_fd;

    return 0;
}

void mmio_fini(void)
{
    close (sw_uart_mem_fd);
}

//*********************************************************
//  @fn:                sys_pthread_create
//  @brief:
//  @param:         
//  @return:
//  @description:    
//*********************************************************
int sys_pthread_create(struct sys_rt_irq_thread *rt, void *thread_fn,
            void *thread_fn_param, int policy, int priority)
{
    int rc = 0;

    if (rt == 0)
        return -1;

    pthread_attr_init(&rt->attr);
    rt->policy = policy;
    rt->priority = priority;
    rt->started = 0;

    rc = pthread_create(&rt->thread, &rt->attr, thread_fn, thread_fn_param);
    if (rc) {
        fprintf(stderr, "failed creating thread: (%d)", rc);
        return -1;
    }

    return 0;
}

void *sw_uart_rx_task(void *pParam)
{
    unsigned int device = (unsigned int)pParam;

    while(sw_uart_thread_running) {
        if (device == M86XXX_SW_UART_DEVICE_MSP){
            sw_uart_check_msp_msg();
        }
#ifdef SW_UART_DSP
        else {
            sw_uart_check_dsp_msg();
        }    
#endif        
        usleep(50);
    }
    printf("sw_uart_rx_task stoping...\n");
    pthread_exit("done");

    return NULL;
}

/*
 * sw_uart_processing - Adjusting of communiocatin with MSP or DSP
 * @device: device name: dsp or msp
 *
 * Returns: 0 on success, -1 on error.
 */
int sw_uart_processing(unsigned int device)
{
    int rc = 0;

    char *logo;

    printf("Opening SW UART protocol with: ");
    if (device == M86XXX_SW_UART_DEVICE_MSP){
        printf("MSP\n");
        logo = "msp> ";
    }
#ifdef SW_UART_DSP
    else {
        printf("DSP\n");
        logo = "dsp> ";    
    }
#endif

    printf("Memory access establishment:   ");
    if (mmio_init()) {
        printf("Fail\n");
        rc = -1;
    } else {
        sw_uart_mem = mmio_mmap(COMCERTO_MSP_DDR_BASE_SW_UART, PROT_READ|PROT_WRITE, &sw_uart_mem_offset);
        if (sw_uart_mem) {
            printf("Pass\n");
        } else {
            printf("Fail\n");
            rc = -1;
        }
    }

    pSwUartCtx = (PSW_UART_CTX)&sw_uart_mem[sw_uart_mem_offset];
    sw_uart_mem_p2v_offset = (unsigned int)pSwUartCtx - COMCERTO_MSP_DDR_BASE_SW_UART;

    printf("SW UART CTX base:              v_0x%x p_0x%x p2v_0x%x\n", (unsigned int)pSwUartCtx, COMCERTO_MSP_DDR_BASE_SW_UART, sw_uart_mem_p2v_offset);

    if (pSwUartCtx->version == M86XXX_SW_UART_VERSION) {
        printf("            version:           %d.%d.%d-rc%d\n", 
            (pSwUartCtx->version>>24)&0xFF, (pSwUartCtx->version>>16) & 0xFF, (pSwUartCtx->version>>8) & 0xFF, pSwUartCtx->version & 0xFF);    
    } else {
        printf("            version:           WARNING: incompatible version: device_%d.%d.%d-rc%d vs msp_io_app_%d.%d.%d-rc%d\n", 
            (pSwUartCtx->version>>24)&0xFF, (pSwUartCtx->version>>16) & 0xFF, (pSwUartCtx->version>>8) & 0xFF, pSwUartCtx->version & 0xFF,
            M86XXX_SW_UART_VERSION_X, M86XXX_SW_UART_VERSION_Y, M86XXX_SW_UART_VERSION_Z, M86XXX_SW_UART_VERSION_RC);    
    }
        
    printf("Verification CTX integrity:    ");
    if ((pSwUartCtx->marker_start == M86XXX_SW_UART_CTX_MARKER_START) &&
        (pSwUartCtx->marker_end == M86XXX_SW_UART_CTX_MARKER_END)) {
        printf("Pass\n");
    } else {
        printf("Fail\n");
        rc = -1;
    }

    printf("Verification pools init:       ");
    if ((pSwUartCtx->pool_m2a_base) && (pSwUartCtx->pool_a2m_base)  
#ifdef SW_UART_DSP
    && (pSwUartCtx->pool_d2a_base)  && (pSwUartCtx->pool_a2d_base)) {
#else
    ) {
#endif
        printf("Pass\n");
    } else {
        printf("Fail\n");
        rc = -1;
    }

    if (rc == 0) {
        unsigned int exit = 0;
        char ch;
        char str[120];    
        unsigned int str_len = 0;

        //all is ok => entry into the pools processing

        //step 1: print all stored information into the ACP console
        if (device == M86XXX_SW_UART_DEVICE_MSP){
            sw_uart_check_msp_msg();
        }
#ifdef SW_UART_DSP
        else {
            sw_uart_check_dsp_msg();
        }        
#endif        
        if (sys_pthread_create(&sw_uart_rt_irq, sw_uart_rx_task, (void *)device, SCHED_FIFO, 70)) {
            fprintf(stderr, "\nfailed create thread\n");
        }
            
        //step 2: entry into the loop and check incomming ACP console commands for redirection and incomming messages to ACP
        while(!exit) {
            if (scanf("%c", &ch) == EOF) {
                fprintf(stderr, "Error: scanf returned unexpected EOF");
                exit = 1;
            }

            if (ch == 0xa) {
                str[str_len++] = '\r';
                str[str_len] = 0;                
                if (device == M86XXX_SW_UART_DEVICE_MSP){
                    sw_uart_send_acp_to_msp((char *)&str, str_len, 0xacb1);
                }
#ifdef SW_UART_DSP
                else {
                    sw_uart_send_acp_to_dsp((char *)&str, str_len, 0xacb1);
                }    
#endif
                str_len = 0;
            } else if (ch >= 0x20) {
                str[str_len++] = ch;
            } else {
                if (device == M86XXX_SW_UART_DEVICE_MSP){
                    sw_uart_send_acp_to_msp((char *)&ch, 1, 0xacb2);
                }
#ifdef SW_UART_DSP
                else {
                    sw_uart_send_acp_to_dsp((char *)&ch, 1, 0xacb2);
                } 
#endif                
            }
        }
    }

    sw_uart_thread_running = 0;
    if (sw_uart_mem)
        munmap(sw_uart_mem, sw_uart_mem_page_size);
    mmio_fini();
            
    return rc;
}


/*
 * sw_uart_check_msg - Verifiaction of incomming msg queue from device
 * @pSwUartCtx:     CTX of SW UART
 *
 * Returns: 0 on success, -1 on error.
 */
int sw_uart_check_msp_msg(void)
{
    int rc = 0;
    unsigned int put, get, msg_size, i;
    unsigned char    *msg_ptr;
    PSW_UART_PKT_HEADER pSwUartPktHdr;

    put = pSwUartCtx->pool_m2a_put;
    get = pSwUartCtx->pool_m2a_get;        

    while (put != get) {
        pSwUartPktHdr = (PSW_UART_PKT_HEADER)((unsigned int)pSwUartCtx + M86XXX_SW_UART_POOL_OFFSET_M2A + get*M86XXX_SW_UART_MSG_SIZE);
        msg_size = pSwUartPktHdr->size;
        msg_ptr = (unsigned char *)&pSwUartPktHdr->msg_ptr;
        if (pSwUartPktHdr->src_id != M86XXX_SW_UART_MSG_RELEASE_PRINT)
            printf("[%08x] %01d:%02d:%02d: ", pSwUartPktHdr->ts, pSwUartPktHdr->src_id, pSwUartPktHdr->sn, msg_size);
        for (i=0; i<msg_size; i++) {
            putchar(msg_ptr[i]);
        }
        if (++get == M86XXX_SW_UART_POOL_DEEP_M2A)
            get = 0;
    }
    pSwUartCtx->pool_m2a_get = get;

    return rc;
}

#ifdef SW_UART_DSP
int sw_uart_check_dsp_msg(void)
{
    int rc = 0;
    unsigned int put, get, msg_size, i;
    unsigned char    *msg_ptr;
    PSW_UART_PKT_HEADER pSwUartPktHdr;

    put = pSwUartCtx->pool_d2a_put;
    get = pSwUartCtx->pool_d2a_get;        

    while (put != get) {
        pSwUartPktHdr = (PSW_UART_PKT_HEADER)((unsigned int)pSwUartCtx + M86XXX_SW_UART_POOL_OFFSET_D2A + get*M86XXX_SW_UART_MSG_SIZE);
        msg_size = pSwUartPktHdr->size;
        msg_ptr = (unsigned char *)&pSwUartPktHdr->msg_ptr;

        if (pSwUartPktHdr->src_id != M86XXX_SW_UART_MSG_RELEASE_PRINT)
            printf("[%08x] %01d:%02d:%02d: ", pSwUartPktHdr->ts, pSwUartPktHdr->src_id, pSwUartPktHdr->sn, msg_size);
        for (i=0; i<msg_size; i++) {
            putchar(msg_ptr[i]);
        }
        if (++get == M86XXX_SW_UART_POOL_DEEP_D2A)
            get = 0;
    }
    pSwUartCtx->pool_d2a_get = get;

    return rc;
}
#endif

/*
 * sw_uart_check_pkt - Verifiaction of incomming data queue from device
 * @pSwUartCtx:     CTX of SW UART
 * @buffer: 
 * @length: 
 * @src_id:  
 *
 * Returns: 0 on success, -1 on error.
 */

void sw_uart_send_acp_to_msp(char *buffer, unsigned int length, unsigned short src_id)
{
    PSW_UART_PKT_HEADER pPktHdr;
    unsigned int put, prev_put, get;

    //verification of incommin data
    if (length > M86XXX_SW_UART_MSG_DATA_SIZE) {
        //cut to max allowing size and try to continue
        length = M86XXX_SW_UART_MSG_DATA_SIZE;
    }

    if ((void *)buffer == NULL) {
        //impossible to continue
        return;
    }

    //getting the ptr at tx ACP to MSP buffer
    prev_put = put = pSwUartCtx->pool_a2m_put;
    get = pSwUartCtx->pool_a2m_get;

    //update index
    if (++put >= M86XXX_SW_UART_POOL_DEEP_A2M)
        put = 0;

    if (put == get) {
        //queue is full
        return;
    }

    pPktHdr = (PSW_UART_PKT_HEADER)((unsigned int)pSwUartCtx + M86XXX_SW_UART_POOL_OFFSET_A2M + prev_put*M86XXX_SW_UART_MSG_SIZE);

    pPktHdr->ts = 0;
    pPktHdr->size = length;
    pPktHdr->src_id = src_id;    
    pPktHdr->sn = 0xFF & SwUartMsgSN++;

    //copy
    memcpy((void *)&pPktHdr->msg_ptr, (void *)buffer, length);

    pSwUartCtx->pool_a2m_put = put;
    
    return;
}

#ifdef SW_UART_DSP
void sw_uart_send_acp_to_dsp(char *buffer, unsigned int length, unsigned short src_id)
{
    PSW_UART_PKT_HEADER pPktHdr;
    unsigned int put, prev_put, get;

    //verification of incommin data
    if (length > M86XXX_SW_UART_MSG_DATA_SIZE) {
        //cut to max allowing size and try to continue
        length = M86XXX_SW_UART_MSG_DATA_SIZE;
    }

    if ((void *)buffer == NULL) {
        //impossible to continue
        return;
    }

    //getting the ptr at tx ACP to DSP buffer
    prev_put = put = pSwUartCtx->pool_a2d_put;
    get = pSwUartCtx->pool_a2d_get;

    //update index
    if (++put >= M86XXX_SW_UART_POOL_DEEP_A2D)
        put = 0;

    if (put == get) {
        //queue is full
        return;
    }

    pPktHdr = (PSW_UART_PKT_HEADER)((unsigned int)pSwUartCtx + M86XXX_SW_UART_POOL_OFFSET_A2D + prev_put*M86XXX_SW_UART_MSG_SIZE);

    pPktHdr->ts = 0;
    pPktHdr->size = length;
    pPktHdr->src_id = src_id;    
    pPktHdr->sn = 0xFF & SwUartMsgSN++;

    //copy
    memcpy((void *)&pPktHdr->msg_ptr, (void *)buffer, length);

    pSwUartCtx->pool_a2d_put = put;
    
    return;
}
#endif

