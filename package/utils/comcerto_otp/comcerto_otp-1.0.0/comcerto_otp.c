#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <stdio.h>
#include <sys/types.h>
#include <string.h>
#include <errno.h>
#include <sys/stat.h>
#include "../../../../build_dir/target-arm_cortex-a9_glibc-2.21_eabi/linux-comcerto2000_hgw/linux-3.19.3/arch/arm/mach-comcerto/include/mach/otp.h"

int ioctl_wr_enable(int fd)
{
	return ioctl(fd, COMCERTO_OTPIOC_WR_ENABLE);
}

int ioctl_byte_enable(int fd)
{
	return ioctl(fd, COMCERTO_OTPIOC_OPS_BYTE);
}

int ioctl_wr_disable(int fd)
{
	return ioctl(fd, COMCERTO_OTPIOC_WR_DISABLE);
}

int comcerto_otp_read(int fd, char *buf, size_t count, off_t offset)
{
	lseek(fd, offset, SEEK_SET);
	return read(fd, buf, count);
}

int comcerto_otp_write(int fd, char *buf, size_t count, off_t offset)
{
	lseek(fd, offset, SEEK_SET);
	return write(fd, buf, count);
}

int main(int argc, char *argv[])
{

	int fd  = open("/dev/comcerto_otp", O_RDWR);
	if(fd < 0){
                printf("comcerto_otp: can't open device file\n");
                exit(1);
        }

	if(strcmp(argv[1], "read") == 0){
		off_t offset = atoi(argv[3]);
		int size = atoi(argv[2]);
		char *buf = (char *)malloc(size*sizeof(char));
	        int ret = comcerto_otp_read(fd, buf, size, offset);
		if(ret<0){
			printf("comcerto_otp: read failed\n");
		} else {
			int i=0;
			while(i<size){
				printf("%02X\n", (unsigned)buf[i]);
				i++;
			}
		}
	}else if(strcmp(argv[1], "write") == 0){
		char *buf = (char *)malloc(argc*sizeof(char));
		off_t offset = atoi(argv[3]);
                int size = atoi(argv[2]);
		int i = 4;
		ioctl_byte_enable(fd);
		/*while(i<argc){
			buf[i] = argv[i];
			i++;
		}*/
		ioctl_wr_enable(fd);
		int ret = comcerto_otp_write(fd, argv[4], size, offset);
		if(ret<0){
                	printf("comcerto_otp: write failed\n");
                	printf("ret = %d\n", ret);
                	printf("ERROR: %s\n", strerror(errno));
                	exit(1);
        	}else{
			printf("comcerto_otp: write succeeded\n");
		}
	}else if(strcmp(argv[1], "--mac") == 0){
                char *buf = (char *)malloc(12*sizeof(char));
                int ret = comcerto_otp_read(fd, buf, 12, 944);
                if(ret<0){
                        printf("comcerto_otp: read failed\n");
                } else {
                        int i=0;
                        while(i<12){
                                printf("%02X", (unsigned)buf[i]);
                                if(i==5 || i == 11){
					printf("\n");
				}else{
					printf(":");
				}
				i++;
                        }
                }

	}else if(strcmp(argv[1], "--sn") == 0){
		char *buf = (char *)malloc(24*sizeof(char));
                int ret = comcerto_otp_read(fd, buf, 24, 968);
                if(ret<0){
                        printf("comcerto_otp: read failed\n");
                } else {
                        int i=0;
                        while(i<24){
                                printf("%c", (unsigned)buf[i]);
                                i++;
                        }
			printf("\n");
                }
	}else if(strcmp(argv[1], "--wifipass") == 0){

		char *buf = (char *)malloc(32*sizeof(char));
                int ret = comcerto_otp_read(fd, buf, 32, 992);
                if(ret<0){
                        printf("comcerto_otp: read failed\n");
                } else {
                        int i=0;
                        while(i<32){
                                printf("%c", (unsigned)buf[i]);
                                i++;
                        }
                        printf("\n");
                }
	}else if(strcmp(argv[1], "--UUID") == 0){

		char *buf = (char *)malloc(36*sizeof(char));
                int ret = comcerto_otp_read(fd, buf, 36, 907);
                if(ret<0){
                        printf("comcerto_otp: read failed\n");
                } else {
                        int i=0;
                        while(i<36){
                                printf("%c", (unsigned)buf[i]);
                                i++;
                        }
                        printf("\n");
                }
	}else if(strcmp(argv[1], "writemac") == 0){
		char p[6], p1[6];
		printf("First MAC: ");
		scanf("%x:%x:%x:%x:%x:%x", &p[0], &p[1], &p[2], &p[3], &p[4], &p[5]);
		printf("Last MAC: ");
		scanf("%x:%x:%x:%x:%x:%x", &p1[0], &p1[1], &p1[2], &p1[3], &p1[4], &p1[5]);
		ioctl_byte_enable(fd);
        ioctl_wr_enable(fd);
        int ret = comcerto_otp_write(fd, p, 6, 944);
		int ret2 = comcerto_otp_write(fd, p1, 6, 950);
		if(ret<0 || ret2<0){
                        printf("comcerto_otp: write failed\n");
                        printf("ret = %d\n", ret);
                        printf("ERROR: %s\n", strerror(errno));
                        exit(1);
                }else{
                        printf("comcerto_otp: write succeeded\n");
                }
	}else if(strcmp(argv[1], "writehw") == 0){
		char p[4];
        printf("HW type: ");
		scanf("%x.%x.%x.%x", &p[0], &p[1], &p[2], &p[3]);
        ioctl_wr_enable(fd);
		ioctl_byte_enable(fd);
                int ret = comcerto_otp_write(fd, p, 4, 956);
                if(ret<0){
                        printf("comcerto_otp: write failed\n");
                        printf("ret = %d\n", ret);
                        printf("ERROR: %s\n", strerror(errno));
                        exit(1);
                }else{
                        printf("comcerto_otp: write succeeded\n");
                }

	}else if(strcmp(argv[1], "--boreahw") == 0){
		char *buf = (char *)malloc(8*sizeof(char));
                int ret = comcerto_otp_read(fd, buf, 8, 960);
                if(ret<0){
                        printf("comcerto_otp: read failed\n");
                } else {
                        int i=0;
                        while(i<8){
                                printf("%c", (unsigned)buf[i]);
                                i++;
                        }
                        printf("\n");
                }

	}else if(strcmp(argv[1], "--hwversion") == 0){
		char *buf = (char *)malloc(4*sizeof(char));
                int ret = comcerto_otp_read(fd, buf, 4, 956);
                if(ret<0){
                        printf("comcerto_otp: read failed\n");
                } else {
                        int i=0;
                        while(i<4){
                                printf("%d", (unsigned)buf[i]);
                                i++;
                        }
                        printf("\n");
                }

	}

	char polje[6] = {'\xAB', '\xCD', '\xEF', '\x11', '\x22', '\x33'};

	close(fd);
}
