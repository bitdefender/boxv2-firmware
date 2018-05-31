/******************************************************************************
 *                                                                            *
 *  Mindspeed Technologies                                                    *
 *  MultiService Access division                                              *
 *                                                                            *
 *  Freescale                                                    *
 *  Copyright (C) 2014, All rights reserved                                   *
 *                                                                             *
 *  Header file  : sw_uart.h                                                    *
 *                                                                            *
 *  Content : MSP/DSP <> ACP SW UART tool                                                           *
 *                                                                            *
 *  S/E   Date               Revision history                              *
 *  ----  ---------          ----------------------------------------------*
 *        2014-Sep             Created.                                      *
 ******************************************************************************/

#ifndef __SW_UART__
#define __SW_UART__

#include <stdio.h>
#include <fcntl.h>
#include <argp.h>
#include <string.h>
#include <sys/ioctl.h>
#include <zlib.h>
#include <sys/mman.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>

/*****************************************************************************
 *   Version definitions
 *****************************************************************************/
//#define SW_UART_DSP

#define M86XXX_SW_UART_VERSION_X    0
#define M86XXX_SW_UART_VERSION_Y    2
#define M86XXX_SW_UART_VERSION_Z    1
#define M86XXX_SW_UART_VERSION_RC   1

#define M86XXX_SW_UART_VERSION    ((M86XXX_SW_UART_VERSION_X<<24) | (M86XXX_SW_UART_VERSION_Y<<16) | (M86XXX_SW_UART_VERSION_Z<<8) | M86XXX_SW_UART_VERSION_RC)


/*****************************************************************************
 *   Memory definitions
 *****************************************************************************/
#define COMCERTO_MSP_DDR_BASE            	(0x2C00000) //Kernel definition to COMCERTO_DDR_SHARED_BASE
#define COMCERTO_MSP_DDR_SIZE            	(1024 * 1024 * 8)

#define COMCERTO_MSP_DDR_SIZE_SW_UART     	(1024 * 64)
#define COMCERTO_MSP_DDR_BASE_SW_UART     	(COMCERTO_MSP_DDR_BASE + COMCERTO_MSP_DDR_SIZE - COMCERTO_MSP_DDR_SIZE_SW_UART)


/*****************************************************************************
 *   Pool definitions
 *****************************************************************************/
#define M86XXX_SW_UART_MSG_SIZE                 (128)    //bytes
#define M86XXX_SW_UART_MSG_DATA_SIZE            (M86XXX_SW_UART_MSG_SIZE-8)    //bytes, 8 bytes is header: 4 bytes timestamp, 2 bytes source, 2 bytes size

#define M86XXX_SW_UART_HEADER_SIZE              (M86XXX_SW_UART_MSG_SIZE)

#ifdef SW_UART_DSP
#define M86XXX_SW_UART_POOL_DEEP_M2A            (128)    //items in queue
#define M86XXX_SW_UART_POOL_DEEP_A2M            (128)    //items in queue

#define M86XXX_SW_UART_POOL_DEEP_D2A            (128)    //items in queue
#define M86XXX_SW_UART_POOL_DEEP_A2D            (127)    //items in queue
#else
#define M86XXX_SW_UART_POOL_DEEP_M2A            (256)    //items in queue
#define M86XXX_SW_UART_POOL_DEEP_A2M            (255)    //items in queue
#endif

#define M86XXX_SW_UART_POOL_OFFSET_M2A          (M86XXX_SW_UART_HEADER_SIZE)
#define M86XXX_SW_UART_POOL_OFFSET_A2M          (M86XXX_SW_UART_POOL_OFFSET_M2A + M86XXX_SW_UART_POOL_DEEP_M2A*M86XXX_SW_UART_MSG_SIZE)

#ifdef SW_UART_DSP
#define M86XXX_SW_UART_POOL_OFFSET_D2A          (M86XXX_SW_UART_POOL_OFFSET_A2M + M86XXX_SW_UART_POOL_DEEP_A2M*M86XXX_SW_UART_MSG_SIZE)
#define M86XXX_SW_UART_POOL_OFFSET_A2D          (M86XXX_SW_UART_POOL_OFFSET_D2A + M86XXX_SW_UART_POOL_DEEP_D2A*M86XXX_SW_UART_MSG_SIZE)
#endif


/*****************************************************************************
 *   Header definitions
 *****************************************************************************/
#define M86XXX_SW_UART_CTX_MARKER_START         (0xF00DAAA1)
#define M86XXX_SW_UART_CTX_MARKER_END           (0xF00DAAAF)

#define M86XXX_SW_UART_CTX_CONTROL_NONE         (0)

#define M86XXX_SW_UART_MSG_RELEASE_PRINT        (0xFE)
#define M86XXX_SW_UART_MSG_DEBUG_PRINT          (1)
#define M86XXX_SW_UART_MSG_MARKED_PRINT         (2)

#define M86XXX_SW_UART_DEVICE_MSP               (0)
#define M86XXX_SW_UART_DEVICE_DSP               (1)


struct sys_rt_irq_thread {
    pthread_t      thread;
    pthread_attr_t attr;
    int            priority;
    int            policy;
    volatile int   started;
    int            dev;
};

typedef struct _SW_UART_CTX_ {
//============================================================= SW UART HEADER
// Try to avoid changing of the header
// unless you are sure in sync with ACP & DSP sources
// 0 bytes:
    unsigned int marker_start;
    unsigned int version;
    unsigned int control;
    unsigned int msp_ctx_base;
    unsigned int dsp_ctx_base;
    unsigned int acp_ctx_base;
    unsigned int ctx_heade_size;
    unsigned int res1;
    
// 32 bytes:    
    unsigned int pool_m2a_base;
    unsigned int pool_a2m_base;
    unsigned int pool_d2a_base;
    unsigned int pool_a2d_base;

    unsigned int res2;
    unsigned int res3;
    unsigned int res4;
    unsigned int res5;

// 64 bytes:    
    unsigned int pool_m2a_put; //points to the index of empty packet place, that can be used 
    unsigned int pool_m2a_get;    
    unsigned int pool_a2m_put; //points to the index of empty packet place, that can be used 
    unsigned int pool_a2m_get;    
    unsigned int pool_d2a_put; //points to the index of empty packet place, that can be used 
    unsigned int pool_d2a_get;    
    unsigned int pool_a2d_put; //points to the index of empty packet place, that can be used 
    unsigned int pool_a2d_get;    

// 96 bytes:    
    unsigned int res6;
    unsigned int res7;
    unsigned int res8;
    unsigned int res9;
    unsigned int res10;
    unsigned int res11;
    unsigned int res12;
    unsigned int marker_end;

// 128 bytes:    
//== SW_UART_HEADER_SIZE

} SW_UART_CTX, *PSW_UART_CTX;

typedef struct _SW_UART_PKT_HEADER_ {
    unsigned int     ts;
    unsigned char    size;
    unsigned char    sn;    
    unsigned short    src_id;    
    unsigned char    *msg_ptr;
} SW_UART_PKT_HEADER, *PSW_UART_PKT_HEADER;

int sw_uart_processing(unsigned int device);

#endif /*__SW_UART__*/
