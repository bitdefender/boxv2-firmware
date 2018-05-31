/*
 *  pmu_ctrl.h
 *
 * Copyright (C) 2013 Mindspeed Technologies
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

#ifndef __ARM926_PMU_H
#define __ARM926_PMU_H

/* COMCERTO_GPIO_CSS_DECT_SYS_CFG0 */
#define BMP_RESET_BIT			(1 << 14)
#define GDMAC_RESET_BIT			(1 << 13)
#define TIMERS_RESET_BIT		(1 << 12)
#define ARM_MAIN_RESET_BIT		(1 << 11)
#define CSS_MAIN_RESET_BIT		(1 << 10)
#define BMP_OSC_CLOCK_ENABLE_BIT	(1 << 7)
#define BMP_HCLK_CLOCK_ENABLE_BIT	(1 << 6)
#define GDMAC_PCLK_CLOCK_ENABLE_BIT	(1 << 5)
#define GDMAC_HCLK_CLOCK_ENABLE_BIT	(1 << 4)
#define TIMER2_CLOCK_ENABLE_BIT		(1 << 3)
#define TIMER1_CLOCK_ENABLE_BIT		(1 << 2)
#define ARM_CLOCK_ENABLE_BIT		(1 << 1)
#define CSS_MAIN_CLOCK_ENABLE_BIT	(1 << 0)

/* COMCERTO_GPIO_CSS_DECT_SYS_CFG1 */
#define BCLK_CLOCK_ENABLE_BIT		(1 << 16)

/* COMCERTO_GPIO_PMU_INTR_SET */
#define GPIO0_IRQ_BIT			(1 << 0)

/* COMCERTO_GPIO_CSS_DECT_CTRL */
#define RF_RESET_BIT			(1 << 16)



/*
 * Put the code that Power UP arm926 here
 */
int pmu_power_up(void);

/*
 * Put the code that Power DOWN arm926 here
 */
int pmu_power_down(void);

/*
 * Put the code that put arm926 int RESET
 */
int pmu_reset_on(void);

/*
 * Put the code that relese arm926 from RESET
 */
int pmu_reset_release(void);


#endif
