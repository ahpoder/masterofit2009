/*
 * EmBtnTop.h
 *
 *  Created on: 17/02/2011
 *      Author: saa
 */

#ifndef EMBTNTOP_H_
#define EMBTNTOP_H_

// Asynchronous input buffer with 4-128 samples of n bit width
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#include <systemc.h>
#include "ADCSource.h"
#include "DACSource.h"
#include "CirBuffer.h"
#include "AudioEncoder.h"
#include "AudioDecoder.h"

#define SAMPLE_PERIODE_ADC 1050 // ADC Sample periode in nS (48 kSPS = 21000 ns)
#define SAMPLE_PERIODE_DEC 2100 // Decoder Sample periode in nS (48 kSPS = 21000 ns)


#ifdef _EA_IMPORT

class EmBtnTop : public sc_module
{
  public:

#else

SC_MODULE(EmBtnTop)
{

#endif
  sc_clock clockADC; // ADC Sample clock
  sc_clock clockDec; // Decoder Sample clock

  // Channels between ADCSource and ADCInput
  sc_signal<sc_logic> clkADC; // Sample clock channel to ADC
  sc_signal<sc_logic> clkDec; // Sample clock channel to Decoder
  sc_signal<sc_logic> busyADC; // Logical high (1) when new din sample
  sc_signal<sc_logic> busyDec; // Logical high (1) when new din sample
  sc_signal<sc_lv<SAMPLE_BITS> > inDataADC; // Data input from ADC
  sc_signal<sc_lv<SAMPLE_BITS> > inDataDec; // Data input from Decoder

  // Output interface
  sc_signal<bool> readADC; // Read strobe for data in buffer
  sc_signal<bool> readDec; // Read strobe for data in buffer
  sc_signal<bool> readyADC; // Ready signal when data_out valid
  sc_signal<bool> readyDec; // Ready signal when data_out valid
  sc_signal<sc_uint<SAMPLE_BITS> > outDataADC; // Data ouput from ADCbuffer
  sc_signal<sc_uint<SAMPLE_BITS> > outDataDec; // Data ouput from Decbuffer

  // Modules and Components
  ADCSource     *pADC;
  DACSource     *pDAC;
  CirBuffer     *pADC_Buf;
  CirBuffer     *pDAC_Buf;
  AudioEncoder  *pAudioEncoder;
  AudioDecoder  *pAudioDecoder;
  sc_trace_file *tracefile;

  SC_CTOR( EmBtnTop);
  ~EmBtnTop();

  void ClockADCSignal();
  void ClockDecSignal();

};

#endif /* EMBTNTOP_H_ */
