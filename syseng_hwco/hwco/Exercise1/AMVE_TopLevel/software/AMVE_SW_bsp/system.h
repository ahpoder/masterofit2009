/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'cpu_0' in SOPC Builder design 'CPU_System'
 * SOPC Builder design path: ../../CPU_System.sopcinfo
 *
 * Generated: Mon Nov 15 21:02:56 CET 2010
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x100820
#define NIOS2_CPU_FREQ 50000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x0
#define NIOS2_CPU_IMPLEMENTATION "small"
#define NIOS2_DATA_ADDR_WIDTH 21
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x80020
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 1
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 32
#define NIOS2_ICACHE_LINE_SIZE_LOG2 5
#define NIOS2_ICACHE_SIZE 4096
#define NIOS2_INST_ADDR_WIDTH 21
#define NIOS2_RESET_ADDR 0x80000


/*
 * CodecInterface_0 configuration
 *
 */

#define ALT_MODULE_CLASS_CodecInterface_0 CodecInterface
#define CODECINTERFACE_0_BASE 0x101090
#define CODECINTERFACE_0_IRQ -1
#define CODECINTERFACE_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define CODECINTERFACE_0_NAME "/dev/CodecInterface_0"
#define CODECINTERFACE_0_SPAN 16
#define CODECINTERFACE_0_TYPE "CodecInterface"


/*
 * Custom instruction macros
 *
 */

#define ALT_CI_MULTIPLIERADD_INST(A,B) __builtin_custom_inii(ALT_CI_MULTIPLIERADD_INST_N,(A),(B))
#define ALT_CI_MULTIPLIERADD_INST_N 0x0


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_LCD_16207
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID
#define __ALTERA_AVALON_TIMER
#define __ALTERA_NIOS2
#define __ALTERA_UP_AVALON_SRAM_CLASSIC
#define __CODECINTERFACE
#define __MULTIPLIERADD
#define __WAVEFORMGENERATOR


/*
 * System configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2"
#define ALT_CPU_FREQ 50000000
#define ALT_CPU_NAME "cpu_0"
#define ALT_DEVICE_FAMILY "CYCLONEII"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart_0"
#define ALT_STDERR_BASE 0x1010a0
#define ALT_STDERR_DEV jtag_uart_0
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart_0"
#define ALT_STDIN_BASE 0x1010a0
#define ALT_STDIN_DEV jtag_uart_0
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart_0"
#define ALT_STDOUT_BASE 0x1010a0
#define ALT_STDOUT_DEV jtag_uart_0
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "CPU_System"


/*
 * WaveformGenerator_0 configuration
 *
 */

#define ALT_MODULE_CLASS_WaveformGenerator_0 WaveformGenerator
#define WAVEFORMGENERATOR_0_BASE 0x101080
#define WAVEFORMGENERATOR_0_IRQ -1
#define WAVEFORMGENERATOR_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define WAVEFORMGENERATOR_0_NAME "/dev/WaveformGenerator_0"
#define WAVEFORMGENERATOR_0_SPAN 16
#define WAVEFORMGENERATOR_0_TYPE "WaveformGenerator"


/*
 * altera_extended_hal_bsp configuration
 *
 */

#define ALT_MAX_FD 32
#define ALT_SYS_CLK TIMER_SYSTEM
#define ALT_TIMESTAMP_CLK TIMER_TIMESTAMP


/*
 * jtag_uart_0 configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart_0 altera_avalon_jtag_uart
#define JTAG_UART_0_BASE 0x1010a0
#define JTAG_UART_0_IRQ 0
#define JTAG_UART_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_0_NAME "/dev/jtag_uart_0"
#define JTAG_UART_0_READ_DEPTH 64
#define JTAG_UART_0_READ_THRESHOLD 8
#define JTAG_UART_0_SPAN 8
#define JTAG_UART_0_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_0_WRITE_DEPTH 64
#define JTAG_UART_0_WRITE_THRESHOLD 8


/*
 * lcd configuration
 *
 */

#define ALT_MODULE_CLASS_lcd altera_avalon_lcd_16207
#define LCD_BASE 0x101070
#define LCD_IRQ -1
#define LCD_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LCD_NAME "/dev/lcd"
#define LCD_SPAN 16
#define LCD_TYPE "altera_avalon_lcd_16207"


/*
 * pio_input configuration
 *
 */

#define ALT_MODULE_CLASS_pio_input altera_avalon_pio
#define PIO_INPUT_BASE 0x101060
#define PIO_INPUT_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_INPUT_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_INPUT_CAPTURE 0
#define PIO_INPUT_DATA_WIDTH 8
#define PIO_INPUT_DO_TEST_BENCH_WIRING 0
#define PIO_INPUT_DRIVEN_SIM_VALUE 0x0
#define PIO_INPUT_EDGE_TYPE "NONE"
#define PIO_INPUT_FREQ 50000000u
#define PIO_INPUT_HAS_IN 1
#define PIO_INPUT_HAS_OUT 0
#define PIO_INPUT_HAS_TRI 0
#define PIO_INPUT_IRQ -1
#define PIO_INPUT_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_INPUT_IRQ_TYPE "NONE"
#define PIO_INPUT_NAME "/dev/pio_input"
#define PIO_INPUT_RESET_VALUE 0x0
#define PIO_INPUT_SPAN 16
#define PIO_INPUT_TYPE "altera_avalon_pio"


/*
 * pio_output1 configuration
 *
 */

#define ALT_MODULE_CLASS_pio_output1 altera_avalon_pio
#define PIO_OUTPUT1_BASE 0x101040
#define PIO_OUTPUT1_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_OUTPUT1_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_OUTPUT1_CAPTURE 0
#define PIO_OUTPUT1_DATA_WIDTH 8
#define PIO_OUTPUT1_DO_TEST_BENCH_WIRING 0
#define PIO_OUTPUT1_DRIVEN_SIM_VALUE 0x0
#define PIO_OUTPUT1_EDGE_TYPE "NONE"
#define PIO_OUTPUT1_FREQ 50000000u
#define PIO_OUTPUT1_HAS_IN 0
#define PIO_OUTPUT1_HAS_OUT 1
#define PIO_OUTPUT1_HAS_TRI 0
#define PIO_OUTPUT1_IRQ -1
#define PIO_OUTPUT1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_OUTPUT1_IRQ_TYPE "NONE"
#define PIO_OUTPUT1_NAME "/dev/pio_output1"
#define PIO_OUTPUT1_RESET_VALUE 0x0
#define PIO_OUTPUT1_SPAN 16
#define PIO_OUTPUT1_TYPE "altera_avalon_pio"


/*
 * pio_output2 configuration
 *
 */

#define ALT_MODULE_CLASS_pio_output2 altera_avalon_pio
#define PIO_OUTPUT2_BASE 0x101050
#define PIO_OUTPUT2_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_OUTPUT2_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_OUTPUT2_CAPTURE 0
#define PIO_OUTPUT2_DATA_WIDTH 8
#define PIO_OUTPUT2_DO_TEST_BENCH_WIRING 0
#define PIO_OUTPUT2_DRIVEN_SIM_VALUE 0x0
#define PIO_OUTPUT2_EDGE_TYPE "NONE"
#define PIO_OUTPUT2_FREQ 50000000u
#define PIO_OUTPUT2_HAS_IN 0
#define PIO_OUTPUT2_HAS_OUT 1
#define PIO_OUTPUT2_HAS_TRI 0
#define PIO_OUTPUT2_IRQ -1
#define PIO_OUTPUT2_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_OUTPUT2_IRQ_TYPE "NONE"
#define PIO_OUTPUT2_NAME "/dev/pio_output2"
#define PIO_OUTPUT2_RESET_VALUE 0x0
#define PIO_OUTPUT2_SPAN 16
#define PIO_OUTPUT2_TYPE "altera_avalon_pio"


/*
 * sram_0 configuration
 *
 */

#define ALT_MODULE_CLASS_sram_0 altera_up_avalon_sram_classic
#define SRAM_0_BASE 0x80000
#define SRAM_0_IRQ -1
#define SRAM_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SRAM_0_NAME "/dev/sram_0"
#define SRAM_0_SPAN 524288
#define SRAM_0_TYPE "altera_up_avalon_sram_classic"


/*
 * sysid configuration
 *
 */

#define ALT_MODULE_CLASS_sysid altera_avalon_sysid
#define SYSID_BASE 0x1010a8
#define SYSID_ID 679605662u
#define SYSID_IRQ -1
#define SYSID_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_NAME "/dev/sysid"
#define SYSID_SPAN 8
#define SYSID_TIMESTAMP 1289848493u
#define SYSID_TYPE "altera_avalon_sysid"


/*
 * timer_system configuration
 *
 */

#define ALT_MODULE_CLASS_timer_system altera_avalon_timer
#define TIMER_SYSTEM_ALWAYS_RUN 0
#define TIMER_SYSTEM_BASE 0x101000
#define TIMER_SYSTEM_COUNTER_SIZE 32
#define TIMER_SYSTEM_FIXED_PERIOD 0
#define TIMER_SYSTEM_FREQ 50000000u
#define TIMER_SYSTEM_IRQ 1
#define TIMER_SYSTEM_IRQ_INTERRUPT_CONTROLLER_ID 0
#define TIMER_SYSTEM_LOAD_VALUE 49999ULL
#define TIMER_SYSTEM_MULT 0.0010
#define TIMER_SYSTEM_NAME "/dev/timer_system"
#define TIMER_SYSTEM_PERIOD 1
#define TIMER_SYSTEM_PERIOD_UNITS "ms"
#define TIMER_SYSTEM_RESET_OUTPUT 0
#define TIMER_SYSTEM_SNAPSHOT 1
#define TIMER_SYSTEM_SPAN 32
#define TIMER_SYSTEM_TICKS_PER_SEC 1000u
#define TIMER_SYSTEM_TIMEOUT_PULSE_OUTPUT 0
#define TIMER_SYSTEM_TYPE "altera_avalon_timer"


/*
 * timer_timestamp configuration
 *
 */

#define ALT_MODULE_CLASS_timer_timestamp altera_avalon_timer
#define TIMER_TIMESTAMP_ALWAYS_RUN 0
#define TIMER_TIMESTAMP_BASE 0x101020
#define TIMER_TIMESTAMP_COUNTER_SIZE 32
#define TIMER_TIMESTAMP_FIXED_PERIOD 0
#define TIMER_TIMESTAMP_FREQ 50000000u
#define TIMER_TIMESTAMP_IRQ 2
#define TIMER_TIMESTAMP_IRQ_INTERRUPT_CONTROLLER_ID 0
#define TIMER_TIMESTAMP_LOAD_VALUE 49999ULL
#define TIMER_TIMESTAMP_MULT 0.0010
#define TIMER_TIMESTAMP_NAME "/dev/timer_timestamp"
#define TIMER_TIMESTAMP_PERIOD 1
#define TIMER_TIMESTAMP_PERIOD_UNITS "ms"
#define TIMER_TIMESTAMP_RESET_OUTPUT 0
#define TIMER_TIMESTAMP_SNAPSHOT 1
#define TIMER_TIMESTAMP_SPAN 32
#define TIMER_TIMESTAMP_TICKS_PER_SEC 1000u
#define TIMER_TIMESTAMP_TIMEOUT_PULSE_OUTPUT 0
#define TIMER_TIMESTAMP_TYPE "altera_avalon_timer"

#endif /* __SYSTEM_H_ */
