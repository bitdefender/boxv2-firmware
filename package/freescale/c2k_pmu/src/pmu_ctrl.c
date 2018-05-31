/*
 *  pmu_ctrl.c
 *
 *
 * Copyright (C) 2013 Mindspeed Techologies
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

#include <linux/interrupt.h>
#include <linux/delay.h>
#include <mach/hardware.h>
#include <asm/io.h>

#include "pmu_ctrl.h"

static void css_clock_disable(void)
{
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG0) & ~CSS_MAIN_CLOCK_ENABLE_BIT, COMCERTO_GPIO_CSS_DECT_SYS_CFG0);
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG1), COMCERTO_GPIO_CSS_DECT_SYS_CFG1);
}

static void css_reset(void)
{
	/* set CSS to reset */
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG0) | CSS_MAIN_RESET_BIT, COMCERTO_GPIO_CSS_DECT_SYS_CFG0);
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG1), COMCERTO_GPIO_CSS_DECT_SYS_CFG1);
}


static void css_clock_enable(void)
{
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG0) | CSS_MAIN_CLOCK_ENABLE_BIT, COMCERTO_GPIO_CSS_DECT_SYS_CFG0);
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG1), COMCERTO_GPIO_CSS_DECT_SYS_CFG1);
}

static void arm926_clock_disable(void)
{
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG0) & ~ARM_CLOCK_ENABLE_BIT, COMCERTO_GPIO_CSS_DECT_SYS_CFG0);
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG1), COMCERTO_GPIO_CSS_DECT_SYS_CFG1);
}

static void arm926_reset(void)
{
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG0) | ARM_MAIN_RESET_BIT, COMCERTO_GPIO_CSS_DECT_SYS_CFG0);
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG1), COMCERTO_GPIO_CSS_DECT_SYS_CFG1);
}

static void arm926_release_from_reset(void)
{
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG0) & ~ARM_MAIN_RESET_BIT, COMCERTO_GPIO_CSS_DECT_SYS_CFG0);
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG1), COMCERTO_GPIO_CSS_DECT_SYS_CFG1);
}

static void arm926_clock_enable(void)
{
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG0) | ARM_CLOCK_ENABLE_BIT, COMCERTO_GPIO_CSS_DECT_SYS_CFG0);
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG1), COMCERTO_GPIO_CSS_DECT_SYS_CFG1);
}

static void clocks_disable(void)
{
	/* disable all device clocks :
	 * o ARM926 clock
	 * o BMP clock
	 * o GDMAC clock (DMA controller)
	 * o Timers 1&2 clocks
	 */
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG0) & ~(ARM_CLOCK_ENABLE_BIT | TIMER1_CLOCK_ENABLE_BIT | TIMER2_CLOCK_ENABLE_BIT | GDMAC_HCLK_CLOCK_ENABLE_BIT | GDMAC_PCLK_CLOCK_ENABLE_BIT | BMP_HCLK_CLOCK_ENABLE_BIT | BMP_OSC_CLOCK_ENABLE_BIT), COMCERTO_GPIO_CSS_DECT_SYS_CFG0);
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG1), COMCERTO_GPIO_CSS_DECT_SYS_CFG1);
}

static void bmp_reset(void)
{
	/* set BMP reset */
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG0) | BMP_RESET_BIT, COMCERTO_GPIO_CSS_DECT_SYS_CFG0);
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG1), COMCERTO_GPIO_CSS_DECT_SYS_CFG1);
}

static void gdmac_reset(void)
{
	/* set GDMAC reset */
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG0) | GDMAC_RESET_BIT, COMCERTO_GPIO_CSS_DECT_SYS_CFG0);
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG1), COMCERTO_GPIO_CSS_DECT_SYS_CFG1);
}

static void timers_reset(void)
{
	/* set TIMERS reset */
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG0) | TIMERS_RESET_BIT, COMCERTO_GPIO_CSS_DECT_SYS_CFG0);
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG1), COMCERTO_GPIO_CSS_DECT_SYS_CFG1);
}

static void dect_reset(void)
{
	/* reset DECT */
	writel(0x0, DECT_RESET);
}

static void slave_remap(void)
{
	/* DECT slave interface remaping */
	writel(0x3808, COMCERTO_GPIO_CSS_DECT_CTRL);
}

static void set_initial_reset_state(void)
{
	/* set initial state: all is in reset */
	writel(CSS_MAIN_RESET_BIT | ARM_MAIN_RESET_BIT | TIMERS_RESET_BIT | GDMAC_RESET_BIT | BMP_RESET_BIT, COMCERTO_GPIO_CSS_DECT_SYS_CFG0);
	writel(0x0, COMCERTO_GPIO_CSS_DECT_SYS_CFG1);
}

static void css_block_release_from_reset(void)
{
	/* leave only ARM at reset */
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG0) & ~(CSS_MAIN_RESET_BIT | TIMERS_RESET_BIT | GDMAC_RESET_BIT | BMP_RESET_BIT), COMCERTO_GPIO_CSS_DECT_SYS_CFG0);
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG1), COMCERTO_GPIO_CSS_DECT_SYS_CFG1);
}

static void css_block_clocks_enable(void)
{
	/* enable clocks for CSS block */
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG0) | (CSS_MAIN_CLOCK_ENABLE_BIT | GDMAC_HCLK_CLOCK_ENABLE_BIT | GDMAC_PCLK_CLOCK_ENABLE_BIT | BMP_HCLK_CLOCK_ENABLE_BIT | BMP_OSC_CLOCK_ENABLE_BIT), COMCERTO_GPIO_CSS_DECT_SYS_CFG0);
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG1), COMCERTO_GPIO_CSS_DECT_SYS_CFG1);
}

static void arm926_clocks_enable(void)
{
	/* enable clocks for ARM926 */
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG0) | (ARM_CLOCK_ENABLE_BIT | TIMER1_CLOCK_ENABLE_BIT | TIMER2_CLOCK_ENABLE_BIT), COMCERTO_GPIO_CSS_DECT_SYS_CFG0);
	writel(readl(COMCERTO_GPIO_CSS_DECT_SYS_CFG1) | BCLK_CLOCK_ENABLE_BIT, COMCERTO_GPIO_CSS_DECT_SYS_CFG1);
}


/*
 * Put the code that Power UP arm926 here
 */
int pmu_power_up(void)
{
	dect_reset();

	slave_remap();

	set_initial_reset_state();

	css_block_clocks_enable();

	css_block_release_from_reset();

	arm926_clocks_enable();

//  arm926_release_from_reset();

	return 0;
}

/*
 * Put the code that Power DOWN arm926 here
 */
int pmu_power_down(void)
{
	arm926_clock_disable();

	arm926_reset();

	arm926_clock_enable();

	msleep(1);

	clocks_disable();

	bmp_reset();

	gdmac_reset();

	timers_reset();

	css_clock_disable();

	css_reset();

	css_clock_enable();

	msleep(2);

	css_clock_disable();

	return 0;
}

/*
 * Put the code that put arm926 int RESET
 */
int pmu_reset_on(void)
{
	arm926_clock_disable();

	arm926_reset();

	arm926_clock_enable();

	return 0;
}

/*
 * Put the code that release arm926 from RESET
 */
int pmu_reset_release(void)
{
	arm926_release_from_reset();

	return 0;
}

