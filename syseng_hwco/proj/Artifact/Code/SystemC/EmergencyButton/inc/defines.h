/*
 * defines.h
 *
 *  Created on: 28/02/2011
 *      Author: saa
 */

#ifndef DEFINES_H_
#define DEFINES_H_

#include <systemc.h>

#define SAMPLE_PERIODE_ADC 22727 // ADC Sample period in nS (44 kSPS = 22727 ns)
#define HS_CLK_PERIODE 125// Data transmission period in nS (8 MHz = 125 ns)

#define MAX_SIZE    33  // Maximum buffer size (bytes needed to start encode)
#define SAMPLE_BITS 12   // Number of bits in sample
#define COM_BUS_WIDTH 12//8  // number of bits in encoded data
#define MAX_BITS    6    //len can maximum become 128

//typedef sc_uint<SAMPLE_BITS> CodedPackettype[MAX_SIZE];
//typedef sc_uint<SAMPLE_BITS> CodedPackettype;


#endif /* DEFINES_H_ */
