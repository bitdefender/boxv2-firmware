/*
 * mmiotool - user-level access to physical memory space
 *
 * Code taken from gpiotool, (C) 2006 by Harald Welte <laforge@openezx.org>
 *
 * This program is Free Software and licensed under GNU GPL Version 2,
 * as published by the Free Software Foundation.
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <sys/types.h>
#include <sys/mman.h>

#define _GNU_SOURCE
#include <getopt.h>

#if 0
#define DEBUGP(x, args ...) fprintf(stderr, x, ## args)
#else
#define DEBUGP(x, args ...)
#endif


#define mmiotool_help	"Usage: mmiotool [-r PHYSADDR] [-w PHYSADDR VALUE] [-R PHYSADDR RANGE] [-m SLEEP] -h\n" \
			"          -r, --read PHYSADDR        : Read 32 bits from physical memory address PHYSADDR \n" \
			"          -w, --write PHYSADDR VALUE : Write VALUE at physical memory address PHYSADDR \n" \
			"          -R, --mread PHYSADDR RANGE : Read RANGE bytes starting from physical address PHYSADDR \n" \
			"          -W, --mwrite PHYSADDR VALUE RANGE INCR : Write VALUE at physical address PHYSADDR over RANGE bytes, incrementing VALUE by INCR at each step \n" \
			"          -m, --msleep SLEEP         : Sleep for SLEEP milliseconds \n" \
                        "          -h, --help                 : print this help message. \n"

static int fd;
static int page_size;


static u_int32_t phys2page_offset(u_int32_t phys_addr, u_int32_t *page_addr)
{
	u_int32_t *mem;
	u_int32_t i;

	phys_addr &= ~(sizeof(mem[0]) - 1);
	*page_addr = phys_addr & ~(page_size - 1);
	i = (phys_addr - *page_addr) / sizeof(mem[0]);

	return i;
}

u_int32_t * mmio_mmap(u_int32_t phys_addr, int prot, u_int32_t *offset)
{
	u_int32_t page_addr;
	u_int32_t *mem;

	*offset = phys2page_offset(phys_addr, &page_addr);

	mem = mmap(NULL, page_size, prot, MAP_SHARED, fd, page_addr);
	if (mem == MAP_FAILED) {
		perror("mmap()");
		return NULL;
	}

	return mem;
}


u_int32_t mmio_rd(u_int32_t phys_addr)
{
	u_int32_t offset, ret;
	u_int32_t *mem;

	DEBUGP("mmio_rd(phys_addr=0x%08lx): ",
		phys_addr);

	mem = mmio_mmap(phys_addr, PROT_READ, &offset);
	ret = mem[offset];
	munmap(mem, page_size);

	DEBUGP("returning 0x%08x\n", ret);

	return ret;
}

u_int32_t mmio_mrd(u_int32_t phys_addr, u_int32_t size)
{
	u_int32_t offset, i;
	u_int32_t *mem;
	
	i = 0;
	mem = mmio_mmap(phys_addr+i, PROT_READ, &offset);

	while (i<size) {
		if (i%1024 == 0) {
			printf("\n          :         +0         +4         +8         +C        +10        +14        +18        +1C");
		}

		if (i%32 == 0) {
			printf("\n0x%08x: ", phys_addr+i);
		}

		if (offset*4 == page_size) {
			munmap(mem, page_size);
			mem = mmio_mmap(phys_addr+i, PROT_READ, &offset);
		}

		printf("0x%08x ", mem[offset]);
		offset += 1;
		i += 4;
	}

	printf("\n");
	munmap(mem, page_size);


	return 0;
}

int mmio_wr(u_int32_t phys_addr, u_int32_t value)
{
	u_int32_t offset;
	u_int32_t *mem;

	DEBUGP("mmio_wr(phys_addr=0x%08x, value=0x%08x): ",
		phys_addr, value);

	mem = mmio_mmap(phys_addr, PROT_WRITE, &offset);
	mem[offset] = value;
	munmap(mem, page_size);

	DEBUGP("returning success\n");

	return 0;
}

int mmio_mwr(u_int32_t phys_addr, u_int32_t value, u_int32_t size, u_int32_t incr)
{
	u_int32_t offset, i, current_incr;
	u_int32_t *mem;

	DEBUGP("mmio_wr(phys_addr=0x%08x, value=0x%08x): ",
		phys_addr, value);

	i = 0;
	current_incr = 0;
	mem = mmio_mmap(phys_addr, PROT_WRITE, &offset);

	while (i<size) {

		if (offset*4 == page_size) {
			munmap(mem, page_size);
			mem = mmio_mmap(phys_addr+i, PROT_WRITE, &offset);
		}

		mem[offset] = value + current_incr;;

		current_incr += incr;
		offset += 1;
		i += 4;
	}

	munmap(mem, page_size);
	DEBUGP("returning success\n");

	return 0;
}

int mmio_init(void)
{
	page_size = getpagesize();
	fd = open("/dev/mem", O_RDWR | O_SYNC);
	if (fd < 0)
		return fd;

	return 0;
}

void mmio_fini(void)
{
	close (fd);
}


static u_int32_t get_physaddr(char *opt_arg)
{
	u_int32_t phys_addr;
	char *endptr;

	phys_addr = strtoul(opt_arg, &endptr, 16);

	if (phys_addr == 0) {
		fprintf(stderr, "unknown reg/addr `%s'\n", opt_arg);
		exit(1);
	}

	return phys_addr;
}


static struct option opts[] = {
	/* genric mmio functions */
	{ "read",	1, 0, 'r' },
	{ "mread",	1, 0, 'R' },
	{ "write",	1, 0, 'w' },
	{ "mwrite",	1, 0, 'W' },
	{ "help",	0, 0, 'h' },
	{ "msleep",	1, 0, 'm' }
};

int main(int argc, char **argv)
{
	int c;
	u_int32_t phys_addr;
	u_int32_t val, size, incr;

	mmio_init();

	while (1) {
		int index = 0;

		c = getopt_long(argc, argv, "r:R:w:W:hm:", opts, NULL);
		if (c == -1)
			break;

		switch (c) {
		case 'r':
			phys_addr = get_physaddr(optarg);
			printf("Read from 0x%08x: 0x%08x\n", phys_addr, mmio_rd(phys_addr));
			break;
		case 'R':
			index = (optarg == NULL)?optind+1:optind;
			if (index < argc) {
				phys_addr = get_physaddr(argv[index-1]);
				val = strtoul(argv[index], NULL, 0);
				mmio_mrd(phys_addr, val);
			} else
				printf(mmiotool_help);
			break;
		case 'w':
			index = (optarg == NULL)?optind+1:optind;
			if (index < argc) {
				phys_addr = get_physaddr(argv[index-1]);
				val = strtoul(argv[index], NULL, 0);
				mmio_wr(phys_addr, val);
				printf("Wrote to  0x%08x: 0x%08x\n", phys_addr, val);
			} else
				printf(mmiotool_help);
			break;
		case 'W':
			index = (optarg == NULL)?optind+3:optind;
			if (index < argc) {
				phys_addr = get_physaddr(argv[index-1]);
				val = strtoul(argv[index], NULL, 0);
				size = strtoul(argv[index+1], NULL, 0);
				incr = strtoul(argv[index+2], NULL, 0);
				mmio_mwr(phys_addr, val, size, incr);
				printf("Wrote to  0x%08x-0x%08x : 0x%08x (increment: 0x%08x)\n", phys_addr, phys_addr + size, val, incr);
			} else
				printf(mmiotool_help);
			break;
		case '?':
		case 'h':
			printf(mmiotool_help);
			break;
		case 'm':
			val = strtoul(optarg, NULL, 10);
			usleep(val*1000);
			break;
		}
	}
	if (argc == 1) printf(mmiotool_help);

	mmio_fini();

	return 0;
}
