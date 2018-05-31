/**
 * pmu_loader.c
 *
 * Copyright (C) 2013 Mindspeed Technologies
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * version 2 as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA
 *
 */
#include <linux/clk.h>
#include <linux/debugfs.h>
#include <linux/delay.h>
#include <linux/dma-mapping.h>
#include <linux/err.h>
#include <linux/firmware.h>
#include <linux/gpio.h>
#include <linux/init.h>
#include <linux/io.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/mutex.h>
#include <linux/platform_device.h>
#include <linux/slab.h>
#include <linux/stat.h>
#include <linux/sysfs.h>
#include <linux/uaccess.h>
#include <linux/vmalloc.h>
#include <linux/workqueue.h>
#include <linux/of.h>
#include <linux/of_gpio.h>
#include <linux/interrupt.h>
#include <linux/elf.h>

#include <mach/reset.h>

#include "pmu_ctrl.h"

//#define DEBUG_TCM 1

#define PMU_FIRMWARE_FILENAME	"pmu.elf"

/* pmu ressources index as set in platform device */
#define RES_ITCM_IDX	0
#define RES_DTCM_IDX	1

/* ITCM and DTCM base address in Arm926 domain */
#define ITCM_ARM926_BASE	0x00000000 //0x08000000
#define DTCM_ARM926_BASE	0x00100000 //0x08100000

enum firmware_state {
	FIRMWARE_NA,
	FIRMWARE_PENDING,
	FIRMWARE_LOADED,
	FIRMWARE_PANIC
};

static const char * const firmware_state_names[] = {
	[FIRMWARE_NA]	= "none",
	[FIRMWARE_PENDING]	= "pending",
	[FIRMWARE_LOADED]	= "loaded",
	[FIRMWARE_PANIC]	= "panic",
};

struct memory {
	void __iomem *data;
	unsigned int size;
	struct resource *res;
};



struct loader_private {
	struct memory dtcm;
	struct memory itcm;
	struct device *dev;
	enum firmware_state state;
	struct mutex lock;
};



#ifdef DEBUG_TCM
static void debug_tcm(struct loader_private *p, void *mem, int offset, int size)
{
	unsigned char *buf;
	int i;
	
	buf = vmalloc(size);
	if(!buf)
	{
		printk("vmalloc error on tcm debug\n");
		return;
	}
	
	memcpy_fromio((void*)buf, mem + offset, size);
	
	for(i = 0; i < size; i+=4)
		printk("tcm[0x%x]: %02x%02x %02x%02x\n", offset + i, buf[i+3],buf[i+2],buf[i+1],buf[i]);
}

static void debug_itcm(struct loader_private *p, int offset, int size)
{
	debug_tcm(p, p->itcm.data, offset, size);
}

static void debug_dtcm(struct loader_private *p, int offset, int size)
{
	debug_tcm(p, p->dtcm.data, offset, size);
}
#endif

static Elf32_Shdr * get_elf_section_header(const struct firmware *fw, const char *section)
{
	Elf32_Ehdr *elf_hdr = (Elf32_Ehdr *)fw->data;
	Elf32_Shdr *shdr, *shdr_shstr;
	Elf32_Off e_shoff = elf_hdr->e_shoff;
	Elf32_Half e_shentsize = elf_hdr->e_shentsize;
	Elf32_Half e_shnum = elf_hdr->e_shnum;
	Elf32_Half e_shstrndx = elf_hdr->e_shstrndx;
	Elf32_Off shstr_offset;
	Elf32_Word sh_name;
	const char *name;
	int i;

	/* Section header strings */
	shdr_shstr = (Elf32_Shdr *)(fw->data + e_shoff + e_shstrndx * e_shentsize);
	shstr_offset = shdr_shstr->sh_offset;

	for (i = 0; i < e_shnum; i++) {
		shdr = (Elf32_Shdr *)(fw->data + e_shoff + i * e_shentsize);

		sh_name = shdr->sh_name;

		name = (const char *)(fw->data + shstr_offset + sh_name);

		if (!strcmp(name, section))
			return shdr;
	}

	return NULL;
}

static void get_version_info(const struct firmware *fw)
{
	static char *version = NULL;

	Elf32_Shdr *shdr = get_elf_section_header(fw, ".version");

	if (shdr)
	{
		version = (char *)(fw->data + be32_to_cpu(shdr->sh_offset));

		printk(KERN_INFO "PMU binary version: %s\n", version);
	}
	else
	{
		printk(KERN_INFO "PMU elf version not found\n");
	}
}

static int num_section = 2;
static char * section_name[] = {"ROOT_RO", "DATA"};

static int pmu_load_elf(const struct firmware *fw, struct loader_private *p)
{
	Elf32_Shdr *shdr;
	int section, rc = 0;

	/* clear itcm memory */
	memset_io((void*)p->itcm.data, 0, p->itcm.size);
	memset_io((void*)p->dtcm.data, 0, p->dtcm.size);

	for(section = 0; section < num_section; section++)
	{
		shdr = get_elf_section_header(fw, section_name[section]);

		if (shdr && shdr->sh_size)
		{
			printk ("%s: %d bytes to load at addr:0x%08x from elf offset: 0x%x\n",
				section_name[section],
				shdr->sh_size,
				shdr->sh_addr,
				shdr->sh_offset);

			if((shdr->sh_addr >= ITCM_ARM926_BASE) && (shdr->sh_addr <= (ITCM_ARM926_BASE + p->itcm.size)))
			{
				/* load itcm section */
				printk("itcm section dst: %p src: %p\n", (void*)(p->itcm.data + (shdr->sh_addr - ITCM_ARM926_BASE)), (void*)((unsigned long)(fw->data) + shdr->sh_offset));
				memcpy_toio(p->itcm.data + (shdr->sh_addr - ITCM_ARM926_BASE), (void*)((unsigned long)(fw->data) + shdr->sh_offset), shdr->sh_size);
			}
			else if((shdr->sh_addr >= DTCM_ARM926_BASE) && (shdr->sh_addr <= (DTCM_ARM926_BASE + p->dtcm.size)))
			{
				/* load dtcm section */
				printk("dtcm section dst: %p src: %p\n", (void*)(p->dtcm.data + (shdr->sh_addr - DTCM_ARM926_BASE)), (void*)((unsigned long)(fw->data) + shdr->sh_offset));
				memcpy_toio(p->dtcm.data + (shdr->sh_addr - DTCM_ARM926_BASE), (void*)((unsigned long)(fw->data) + shdr->sh_offset), shdr->sh_size);
			}
			else
			{
				printk("Unknow section address\n");
				rc = -EINVAL;
			}
		}
	}

	return rc;
}


static void got_firmware(const struct firmware *fw, void *context)
{
	struct loader_private *p = (struct loader_private *)context;
	Elf32_Ehdr *elf_hdr = (Elf32_Ehdr *)fw->data;

	if (!fw) {
		p->state = FIRMWARE_NA;
		dev_err(p->dev, "loading pmu firmware failed\n");
		return;
	}

	mutex_lock(&p->lock);
	if (pmu_power_up()) {
		dev_err(p->dev, "cannot power up pmu\n");
		mutex_unlock(&p->lock);
		return;
	}

	/* Some sanity checks */
	if (strncmp(&elf_hdr->e_ident[EI_MAG0], ELFMAG, SELFMAG))
	{
		dev_err(p->dev, "%s: incorrect elf magic number (%s)\n", __func__, &elf_hdr->e_ident[EI_MAG0]);
		goto out_err;
	}

	if (elf_hdr->e_ident[EI_CLASS] != ELFCLASS32)
	{
		dev_err(p->dev, "%s: incorrect elf class (%x)\n", __func__, elf_hdr->e_ident[EI_CLASS]);
		goto out_err;
	}

	if (elf_hdr->e_ident[EI_DATA] != ELFDATA2LSB)
	{
		dev_err(p->dev, "%s: incorrect elf data (%x)\n", __func__, elf_hdr->e_ident[EI_DATA]);
		goto out_err;
	}

	if (elf_hdr->e_type != ET_EXEC)
	{
		dev_err(p->dev, "%s: incorrect elf file type (%x)\n", __func__, elf_hdr->e_type);
		goto out_err;
	}

	dev_info(p->dev, "got_firmware: elf size %d elf magic %x class %x data %x type %x\n", fw->size, elf_hdr->e_ident[EI_MAG0], elf_hdr->e_ident[EI_CLASS], elf_hdr->e_ident[EI_DATA], elf_hdr->e_type);

	get_version_info(fw);

	if(pmu_load_elf(fw, p) < 0)
		goto out_err;

	/* release ARM from reset */
	pmu_reset_release();

	mdelay(2);

	p->state = FIRMWARE_LOADED;
	dev_info(p->dev, "successfully loaded PMU firmware\n");

	goto out;

out_err:
	dev_err(p->dev, "failed to load PMU firmware\n");
	pmu_power_down();
	p->state = FIRMWARE_NA;
out:
	release_firmware(fw);
	mutex_unlock(&p->lock);
}

static ssize_t set_load(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	struct loader_private *p = dev_get_drvdata(dev);
	int ret = 0;
	unsigned int value = simple_strtoul(buf, NULL, 0);

	mutex_lock(&p->lock);
	
	if ((value >= 1) && (p->state != FIRMWARE_PENDING)) 
	{
		if (p->state == FIRMWARE_LOADED || p->state == FIRMWARE_PANIC) 
		{
			dev_err(dev, "failed to reload pmu\n");
			pmu_power_down();
			p->state = FIRMWARE_NA;
		}

		ret = request_firmware_nowait(THIS_MODULE,
		                              1,
		                              PMU_FIRMWARE_FILENAME,
		                              dev,
		                              GFP_KERNEL,
		                              (void *)p,
		                              got_firmware);

		if (ret == 0)
			p->state = FIRMWARE_PENDING;
	}
	
	mutex_unlock(&p->lock);

	if (ret != 0)
		return 0;

	return count;
}

static ssize_t get_state(struct device *dev, struct device_attribute *attr, char *buf)
{
	struct loader_private *p = dev_get_drvdata(dev);

	return sprintf(buf, "%s\n", firmware_state_names[p->state]);
}


static struct device_attribute pmu_attrs[] = {
	__ATTR(load, S_IWUSR, NULL, set_load),
	__ATTR(state, S_IRUSR, get_state, NULL)
};

static int pmu_probe(struct platform_device *pdev)
{
	int ret;
	int i;
	struct resource *itcm_res;
	struct resource *dtcm_res;
	struct loader_private *p;

	printk("pmu_probe: RES_ITCM_IDX %d RES_DTCM_IDX %d dev->num_resources %d \n", RES_ITCM_IDX, RES_DTCM_IDX, pdev->num_resources);
	
	itcm_res = platform_get_resource(pdev, IORESOURCE_MEM, RES_ITCM_IDX);
	if (!itcm_res) {
		printk("pmu_probe: itcm_res ERROR\n");
		return -EINVAL;
	}
	
	printk("pmu_probe: itcm_res @%p\n", itcm_res);

	dtcm_res = platform_get_resource(pdev, IORESOURCE_MEM, RES_DTCM_IDX);
	if (!dtcm_res) {
		printk("pmu_probe: dtcm_res ERROR\n");
		return -EINVAL;
	}

	printk("pmu_probe: dtcm_res @%p\n", dtcm_res);

	if (!request_mem_region(itcm_res->start,
	                        itcm_res->end - itcm_res->start + 1,
	                        pdev->name)) {
		dev_err(&pdev->dev, "failed to request ITCM memory resource\n");
		ret = -EBUSY;
		goto out;
	}

	printk("pmu_probe: request_mem_region itcm_res->start 0x%X itcm_res->end 0x%X size %d\n", 
		   itcm_res->start, itcm_res->end, itcm_res->end - itcm_res->start);

	if (!request_mem_region(dtcm_res->start,
	                        dtcm_res->end - dtcm_res->start + 1,
	                        pdev->name)) {
		dev_err(&pdev->dev, "failed to request DTCM memory resource\n");
		ret = -EBUSY;
		goto out_release_itcm_res;
	}

	printk("pmu_probe: request_mem_region dtcm_res->start 0x%X dtcm_res->end 0x%X size %d\n", 
		   dtcm_res->start, dtcm_res->end, dtcm_res->end - dtcm_res->start);

	p = kzalloc(sizeof(*p), GFP_KERNEL);
	if (!p) {
		ret = -ENOMEM;
		goto out_release_dtcm_res;
	}

	p->itcm.res = itcm_res;
	p->dtcm.res = dtcm_res;

	//FIXME: bsp has wrong itcm dtcm size definition using hardcoded values for now...
	p->itcm.size = 0x9E020000/*itcm_res->end*/ - itcm_res->start + 1; //128K
	p->dtcm.size = 0x9E108000/*dtcm_res->end*/ - dtcm_res->start + 1; //32K

	p->state = FIRMWARE_NA;
	p->dev = &pdev->dev;

	mutex_init(&p->lock);

	platform_set_drvdata(pdev, p);

	p->itcm.data = ioremap_nocache(itcm_res->start, p->itcm.size);
	if (!p->itcm.data) {
		dev_err(&pdev->dev, "failed to remap ITCM\n");
		ret = -ENOMEM;
		goto out_unmap_ahbram;
	}

	printk("pmu_probe: ioremap_nocache itcm %p size %d\n", p->itcm.data, p->itcm.size);

	p->dtcm.data = ioremap_nocache(dtcm_res->start, p->dtcm.size);
	if (!p->dtcm.data) {
		dev_err(&pdev->dev, "failed to remap DTCM\n");
		ret = -ENOMEM;
		goto out_unmap_itcm;
	}

	printk("pmu_probe: ioremap_nocache dtcm %p size %d\n", p->dtcm.data, p->dtcm.size);

	/* do this as the very last step */
	for (i = 0; i < ARRAY_SIZE(pmu_attrs); i++) {
		ret = device_create_file(&pdev->dev, &pmu_attrs[i]);
		if (ret) {
			while (--i >= 0)
				device_remove_file(&pdev->dev, &pmu_attrs[i]);
			dev_err(&pdev->dev, "failed to create pmu sysfs\n");
			goto out_unmap_dtcm;
		}
	}

	return 0;

out_unmap_dtcm:
	iounmap(p->dtcm.data);

out_unmap_itcm:
	iounmap(p->itcm.data);

out_unmap_ahbram:
	mutex_destroy(&p->lock);
	kfree(p);

out_release_dtcm_res:
	release_mem_region(dtcm_res->start, dtcm_res->end - dtcm_res->start + 1);

out_release_itcm_res:
	release_mem_region(itcm_res->start, itcm_res->end - itcm_res->start + 1);

out:	
	return ret;
}


static int pmu_remove(struct platform_device *pdev)
{
	struct loader_private *p = platform_get_drvdata(pdev);
	int i;

	if (p->state == FIRMWARE_LOADED || p->state == FIRMWARE_PANIC) 
	{
		printk("pmu_remove: shutting down pmu\n");
		pmu_power_down();
		p->state = FIRMWARE_NA;
	}

	for (i = 0; i < ARRAY_SIZE(pmu_attrs); i++)
		device_remove_file(&pdev->dev, &pmu_attrs[i]);

	iounmap(p->dtcm.data);
	iounmap(p->itcm.data);

	release_mem_region(p->dtcm.res->start,
	                   p->dtcm.res->end - p->dtcm.res->start + 1);
	release_mem_region(p->itcm.res->start,
	                   p->itcm.res->end - p->itcm.res->start + 1);

	mutex_destroy(&p->lock);

	kfree(p);

	return 0;
}

static struct platform_driver pmu_driver = {
	.probe = pmu_probe,
	.remove = pmu_remove,
	.driver = {
		.name = "css",  /* for now reuse of css device plateform definition in c2k BSP */
	},
};

static int __init pmu_module_init(void)
{
	printk(KERN_INFO "%s\n", __func__);

	return platform_driver_register(&pmu_driver);
}
module_init(pmu_module_init);

static void __exit pmu_module_exit(void)
{
	printk(KERN_INFO "%s\n", __func__);

	platform_driver_unregister(&pmu_driver);
}
module_exit(pmu_module_exit);

MODULE_AUTHOR("Mindspeed Technologies.");
MODULE_LICENSE("GPL");
