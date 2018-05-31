/******************************************************************************
 *                                                                            *
 *  Mindspeed Technologies                                                    *
 *  MultiService Access division                                              *
 *                                                                            *
 *  Copyright (C) 2012, All rights reserved                                   *
 *  Proprietary and confidential                                              *
 *                                                                            *
 *  Freescale                                                    *
 *  Copyright (C) 2014, All rights reserved                                   *
 *                                                                             *
 *  Module  : msp_io_app.c  sw_uart.c                                                 *
 *                                                                            *
 *  Content : (1) Utility which uses the "comcerto_coredump" driver to get the    *
 *                      coredump of MSP (SDRAM) for M826xxx.  *
 *                 (2) MSP/DSP <> ACP SW UART tool                                                           *
 *                                                                            *
 *  S/E   Date               Revision history                              *
 *  ----  ---------          ----------------------------------------------*
 *        2012-Dec-12        Created.                                      *
 *        2014-Sep             Added SW UART feature.                                      *
 ******************************************************************************/


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
#include "sw_uart.h"

extern int sw_uart_processing(unsigned int device);

#ifdef __KERNEL__
int msp_ioctl_from_csp(unsigned int cmd, unsigned long arg);
#endif

/* The VERSION usually comes from the configure.in */
#ifndef VERSION
#define VERSION                             "2.1.1"
#endif

#define MSP_IOC_TYPE                        'm'
#define MSP_IOCTL_RESET_MSP_DUMP_TO_BUF     _IOR(MSP_IOC_TYPE, 4, struct MSP_IOCTL_MEM_DUMP)

#define MSP_DEVICE_NAME                     "/dev/msp"
#define MSP_DEVICE_MAJOR_NUM                237 /* this could be whatever you want, as long as it does not conflict with other modules */
#define DEVICE_NAME                         "M86xxx"
#define M86XXX_SDRAM_START                  COMCERTO_MSP_DDR_BASE
#define M86XXX_SDRAM_SIZE                   COMCERTO_MSP_DDR_SIZE


/* Global variables */
struct MSP_IOCTL_IMAGE
{
    void *buf;
    unsigned long len;
};

struct MSP_IOCTL_MEM_DUMP
{
    void *buf;
    unsigned long addr;
    unsigned long len;
};

struct _CODE
{
    unsigned char *buffer;
    unsigned int size;
};

struct _MEM_DUMP
{
    unsigned char *buffer;
    unsigned long start;
    unsigned long size;
};

int compression_level = 9;
char coredump_filename[100];
unsigned char *sdram_buffer;
char sw_uart_module_name[10];


/*
 * open_msp_device - Open the MSP device file (MSP_DEVICE_NAME)
 * @device: device file name
 * @fd        : file descriptor
 *
 * Returns: 0 on success, fd on error.
 */
int open_msp_device(const char *device, int *fd)
{
    int rc = 0;

    if ((*fd = open(device, O_RDWR, 0)) < 0)
    {
        fprintf(stderr, "%s: %s: error opening device\n", device, strerror(errno));
        fprintf(stderr, "Please make sure %s has been created using mknod %s c 237 0 \n", device, device);
        rc = *fd;
    }

    return rc;
}


/*
 * save_buffer_to_file - Save the dumped buffer to a file
 * @filename: file name of the target filename
 * @buffer: pointer to the buffer to save
 * @size: size of the buffer to save
 *
 * Returns: 0 on success, -1 on error.
 */
int save_buffer_to_file(const char *filename, unsigned char *buffer, unsigned long buffer_size)
{
    int rc = 0;
    gzFile mygzfile;
    int compressed_size;
    unsigned char gzopen_mode[4];

    snprintf(gzopen_mode, 4, "wb%d", compression_level);

    mygzfile = gzopen(filename, gzopen_mode);

    if (mygzfile == NULL)
    {
        fprintf(stderr, "gzopen error\n");
        rc = -1;
        goto out;
    }

    compressed_size = gzwrite(mygzfile, buffer, buffer_size);

    printf("Buffer saved to %s (original size %d) \n", filename, compressed_size);

    gzclose(mygzfile);

    /* make sure the files are written */
    sync();

    out:

    return rc ;
}


/*
 * csm_dump_mem - Sets the memory addresses and sizes, invokes the driver's ioctl.
 * @device: device file name
 * @filename: file name of the coredump file
 * @start: start address for coredump
 * @size: size of the memory for coredump
 *
 * Returns: 0 on success, -1 on error.
 */
int csm_dump_mem(const char *device, const char *filename, u_int32_t start, u_int32_t size)
{
    struct MSP_IOCTL_MEM_DUMP msp_mem_dump;
    int fd;
    int rc = 0;
    const char *substring_filename;
    char filename_tmp[100];

    /* open the device file */
    if (open_msp_device(device, &fd))
    {
        goto out;
    }

    /* check if we are dumping sdram */
    substring_filename = strstr(filename, "sdram");

    if (substring_filename != NULL)
    {
        /* sdram_buffer is a global variable */
        sdram_buffer = (unsigned char *)malloc(size);

        if (sdram_buffer == NULL)
        {
            fprintf (stderr, "%s: couldn't allocate %s memory dump buffer\n", device, substring_filename);
            rc = -1;
            goto out1;
        }

        msp_mem_dump.buf = (void *) ((unsigned long) sdram_buffer);
        msp_mem_dump.addr = start;
        msp_mem_dump.len = size;

        rc = ioctl(fd, MSP_IOCTL_RESET_MSP_DUMP_TO_BUF, &msp_mem_dump);

        if (rc < 0)
        {
            perror ("MSP_IOCTL_RESET_MSP_DUMP_TO_BUF");
            free((void *)sdram_buffer);
            goto out1;
        }
    }

    printf("Start saving sdram coredump\n");
    snprintf(filename_tmp, 100, "%s_sdram.gz", coredump_filename);
    rc = save_buffer_to_file(filename_tmp, sdram_buffer, M86XXX_SDRAM_SIZE);
    free((void *)sdram_buffer);

out1:
    close (fd);

out:
    return rc;
}


/*
 * mem_dump - Sets the memory addresses and sizes
 * @device: device file name
 * @filename: file name of the coredump file
 *
 * Returns: 0 on success, -1 on error.
 */
int mem_dump(const char *device, const char *filename)
{
    char filename_tmp[100];
    u_int32_t start, size;
    int rc = 0;

    /* SDRAM */
    snprintf(filename_tmp, 100, "%s.sdram", filename);
    start = M86XXX_SDRAM_START;
    size = M86XXX_SDRAM_SIZE;
    printf("Dumping sdram (%#x:%#x) from device %s to buffer\n", start, start + size - 1, device);

    if (csm_dump_mem(device, filename_tmp, start, size))
    {
        fprintf(stderr, "error dumping SDRAM\n");
        rc = -1;
    }
    
    return rc;
}


const char *argp_program_version = VERSION;
const char *argp_program_bug_address = "alex.winter@freescale.com";
const char doc[] = "msp_io_app - program to perform ioctl utilities to MSP from CSP\n\
msp_io_app -c <filename>\n\
    to core dump sdram to filaname.sdram.gz\n\
\n\
For coredump operation, the -zn option can be specified. With this option the user sets the compression rate (default 9).\n\
";


const struct argp_option options[] =
{
    {"coredump",                     'c',    "FILE",        0, "Dumps device memory to a file."},
    {"compression_level",    'z',    "LEVEL",     0, "Set the compression level for coredump files (default 9)."},
#ifdef SW_UART_DSP
    {"device",                'd',    "DEVICE",     0, "SW UART devices: 'msp', 'dsp'"},    
#else
    {"device",                'd',    "DEVICE",     0, "SW UART devices: 'msp'"},    
#endif    
    {0}
};


/*
 * parser - Switches to different command line options and sets the global variables accordingly.
 */
static error_t parser(int key, char *arg, struct argp_state *state)
{
    switch (key)
    {
        case 'c':
            printf("coredump for %s: \n", DEVICE_NAME);
            snprintf(coredump_filename, 100, arg);
            mem_dump(MSP_DEVICE_NAME, coredump_filename);
            break;

        case 'z':
            compression_level = strtol(arg, NULL, 0);
            break;

        case 'd':
            snprintf(sw_uart_module_name, 100, arg);

            if (strcmp(sw_uart_module_name, "msp") == 0){
                sw_uart_processing(M86XXX_SW_UART_DEVICE_MSP);
#ifdef SW_UART_DSP
            }else if (strcmp(sw_uart_module_name, "dsp") == 0){
                sw_uart_processing(M86XXX_SW_UART_DEVICE_DSP);                
#endif
            } else {
                perror("Error: unknown SW UART communication device\n");
                return ARGP_ERR_UNKNOWN;
            }
            break;
        
        default:
            return ARGP_ERR_UNKNOWN;
    }

    return 0;
}


static struct argp argp = { options, parser, 0, doc, };


/*
 * main - main function of the application.
 */
int main(int argc, char **argv)
{
    argp_parse(&argp, argc, argv, 0, 0, NULL);

    return 0;
}

