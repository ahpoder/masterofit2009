/*
 * AudioTop.h
 *
 *  Created on: 17/02/2011
 *      Author: saa
 */

#ifndef AUDIOTOP_H_
#define AUDIOTOP_H_

// Asynchronous input buffer with 4-128 samples of n bit width
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#include <systemc.h>
#include "defines.h"
#include "ADCSource.h"
#include "DACSource.h"
#include "EchoCancellation.h"
#include "AudioEncoder.h"
#include "AudioDecoder.h"
#include "CommunicationSim.h"




SC_MODULE(AudioTop)
{
  sc_clock AudioClock; // Clock used for sampling purpose (44KHz)
  sc_clock HS_Clock; // High Speed Clock used for Data transmission(16 MHz)

  // Channels between ADCSource and ADCInput
  sc_signal<sc_logic> AudioClk; // Sample clock channel to ADC
  sc_signal<sc_logic> hsClk; // data transmission clock

  sc_signal<sc_logic> ADC_busy; // Logical low == ADC output not ready
  sc_signal<bool> COMSIM_busy; // Logical high == Decoder output not ready
  sc_signal<sc_logic> EC_busy; // Logical low == EchoCancellation output not ready
  sc_signal<bool> ENCOD_busy;// Logical low == CommunicationSim output not ready


  sc_signal<sc_uint<SAMPLE_BITS> > outDataADC; // Data input from CommunicationSim
  sc_signal<sc_uint<SAMPLE_BITS> > outDataEC;  // Data input from EchoCancellation
  sc_signal<sc_uint<SAMPLE_BITS> > outDataEnc; // Data input from Decoder
  sc_signal<sc_uint<SAMPLE_BITS> > outDataComSim; // Data input from CommunicationSim
  sc_signal<sc_uint<SAMPLE_BITS> > outDataDec; // Data input from Encoder

  // Output interface
  //sc_signal<sc_uint<SAMPLE_BITS> > outDataADC; // Data output from ADCbuffer

  // Modules and Components
  ADCSource         *pADC;
  DACSource         *pDAC;
  EchoCancellation  *pEC;
  AudioEncoder      *pAEnc;
  CommunicationSim  *pSim;
  AudioDecoder      *pADec;
  sc_trace_file     *tracefile;

  SC_CTOR( AudioTop);
  ~AudioTop();

  void AudioClockSignal(void);
  void HighSpeedClockSignal(void);
};

#endif /* AudioTOP_H_ */
