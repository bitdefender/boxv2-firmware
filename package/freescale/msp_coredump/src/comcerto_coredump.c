/*
 * drivers/net/comcerto/ comcerto_sysfs.c
 *
  *  Copyright (C) 2006 Mindspeed Technologies, Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */

#include <linux/kernel.h>
#include <linux/vmalloc.h>
#include <linux/proc_fs.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <mach/msp_ioctl.h>
#include <asm/io.h>
#include <asm/uaccess.h>


#define MSP_DEVICE_NAME				"/dev/msp"
#define MSP_DEVICE_MAJOR_NUM			237 /* This could be whatever you want, as long as it does not conflict with other modules */
#define USER					(1 << 2)
#define KERNEL					(1 << 3)


/*
 * memcpy_fromio_toxxx - Copies the specified memory to the user space buffer.
 * @dst: destination buffer
 * @src: source buffer
 * @len: size
 * @flags: flag
 *
 * Returns: 0 on success, -1 on error.
 */
int memcpy_fromio_toxxx(void *dst, void *src, unsigned long len, u8 flags)
{
	unsigned long len_now;
	void *buf;
	int rc;

	if (flags & KERNEL)
	{
		memcpy_fromio(dst, src, len);
	}
	else if (flags & USER)
	{
		buf = vmalloc(SZ_128K);
		
		if (!buf)
		{
			printk(KERN_ERR "\nerror allocating temporary buffer\n");
			rc = -ENOMEM;
			goto err;
		}

		while (len)
		{
			len_now = len > SZ_128K ? SZ_128K : len;

			memcpy_fromio(buf, src, len_now);

			if (copy_to_user(dst, buf, len_now))
			{
				printk(KERN_ERR "\nerror copying to user\n");
				rc = -EFAULT;
				goto err1;
			}

			src += len_now;
			dst += len_now;
			len -= len_now;
		}

		vfree(buf);
	}

	return 0;

err1:
	vfree(buf);

err:
	return rc;
}


/*
 * comcerto_dump_msp - Desides from where (memory address) to copy the info.
 * @addr: base address from where to dump memory
 * @buf: user space buffer
 * @len: size
 * @flags: flag
 *
 * Returns: len on success, -1 on error.
 */
int comcerto_dump_msp(unsigned long addr, void *buf, unsigned long len, u8 flags)
{
	//unsigned long aram_size;
	unsigned long offset;
	int rc;

	if (!len)
	{
		printk(KERN_ERR "\nMSP coredump invalid size\n");
		rc = -EINVAL;
		goto err;
	}

	if ((COMCERTO_MSP_DDR_BASE <= addr)  && (addr < (COMCERTO_MSP_DDR_BASE + COMCERTO_MSP_DDR_SIZE)))
	{
		offset = addr - COMCERTO_MSP_DDR_BASE;

		if ((offset + len) > COMCERTO_MSP_DDR_SIZE)
			len = COMCERTO_MSP_DDR_SIZE - offset;

		rc = memcpy_fromio_toxxx(buf, (void *)COMCERTO_MSP_VADDR + offset, len, flags);

		if (rc)
			goto err;
	}
	else 
	{
		printk(KERN_ERR "\nInvalid coredump memory range %#lx-%#lx\n", addr, addr + len - 1);
		rc = -EINVAL;
		goto err;
	}

	return len;

  err:
		return rc;
}


/*
 * msp_ioctl_from_csp - Switches to different ioctl commands and calls appropriate functions. 
 * @cmd: ioctl command
 * @arg: buffer address
 *
 * Returns: 0 on success, -1 on error.
 */
int msp_ioctl_from_csp(unsigned int cmd, unsigned long arg)
{
	struct MSP_IOCTL_MEM_DUMP *dump;
	int rc = 0;

	switch (cmd)
	{
		case MSP_IOCTL_RESET_MSP_DUMP_TO_BUF:
			printk(KERN_INFO "\nMSP memdump (to user buffer)\n");
			dump = (struct MSP_IOCTL_MEM_DUMP *) arg;
			rc = comcerto_dump_msp(dump->addr, dump->buf, dump->len, USER);

			if (rc < 0)
				break;

			dump->len = rc;
			rc = 0;
			break;

		default:
			printk(KERN_ERR "\ninvalid MSP ioctl (%#x)\n", cmd);
			rc = -EINVAL;
			break;
	}

	return rc;
}


/*
 * msp_ioctl - Device driver's ioctl function.
 *
 * Returns: 0 on success, -1 on error.
 */
static int msp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
	struct MSP_IOCTL_MEM_DUMP dump;
	int rc;

	printk(KERN_INFO "\nmsp_ioctl(%#lx, %#lx, %#lx)\n", (unsigned long)file, (unsigned long)cmd, arg);

	if (_IOC_TYPE(cmd) != MSP_IOC_TYPE)
	{
		rc = -EINVAL;
		goto err;
	}

	switch (cmd)
	{
		case MSP_IOCTL_RESET_MSP_DUMP_TO_BUF:
			if (copy_from_user(&dump, (struct MSP_IOCTL_MEM_DUMP *)arg, sizeof(struct MSP_IOCTL_MEM_DUMP)))
			{
				printk(KERN_ERR "\nmsp_ioctl: error copying data from user space\n");
				rc = -EFAULT;
				goto err;
			}

			rc = msp_ioctl_from_csp(cmd, (unsigned long)&dump);

			if (rc)
				goto err;

			if (copy_to_user((struct MSP_IOCTL_MEM_DUMP *)arg, &dump, sizeof(struct MSP_IOCTL_MEM_DUMP)))
			{
				printk(KERN_ERR "\nmsp_ioctl: error copying data to user space\n");
				rc = -EFAULT;
				goto err;
			}
			break;
		
		default:
			rc = -EINVAL;
			goto err;
			break;
	}

	return 0;

  err:
		return rc;
}


/*
 * msp_open - Device driver's open function.
 *
 * Returns: 0 on success, -1 on error.
 */
static int msp_open(struct inode *inode, struct file *file)
{
	printk(KERN_INFO "\nmsp_open(%#lx)\n", (unsigned long)file);

	return 0;
}


/*
 * msp_release - Device driver's release function.
 *
 * Returns: 0 on success, -1 on error.
 */
static int msp_release(struct inode *inode, struct file *file)
{
	printk(KERN_INFO "\nmsp_release(%#lx)\n", (unsigned long)file);

	return 0;
}

/*
 * Device driver's file operations structure.
 */
struct file_operations msp_fops =
{
	.owner = THIS_MODULE,
	.open = msp_open,
	.release = msp_release,
	.unlocked_ioctl = msp_ioctl,
};


/*
 * msp_init_module - Device driver's init_module function.
 *
 * Returns: 0 on success, -1 on error.
 */
static int __init msp_init_module(void)
{
	if (register_chrdev(MSP_DEVICE_MAJOR_NUM, MSP_DEVICE_NAME, &msp_fops))
	{
		printk(KERN_ERR "\nUnable to register char device");
		goto err1;
	}

	return 0;

	err1:
		return -1;
}


/*
 * msp_cleanup_module - Device driver's cleanup_module function.
 *
 * Returns: 0 on success, -1 on error.
 */
static void __exit msp_cleanup_module(void)
{
	unregister_chrdev(MSP_DEVICE_MAJOR_NUM, MSP_DEVICE_NAME);
}

EXPORT_SYMBOL(msp_ioctl_from_csp);

module_init(msp_init_module);
module_exit(msp_cleanup_module);

