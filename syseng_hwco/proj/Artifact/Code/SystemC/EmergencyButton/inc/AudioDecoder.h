/*
 * AudioDecoder.h
 *
 *  Created on: 19/02/2011
 *      Author: saa
 */

#ifndef AUDIODECODER_H_
#define AUDIODECODER_H_

#include <systemc.h>
#include "CirBuffer.h"

#ifdef _EA_IMPORT

class AudioDecoder : public sc_module
{
  public:

#else

SC_MODULE(AudioDecoder)
{

#endif

  // Local channels
  sc_in<sc_logic> clk_in;
  sc_out<sc_logic> busy_out;
  sc_out<sc_lv<SAMPLE_BITS> > data_out;

  // Test variables
  sc_uint<SAMPLE_BITS> counter;
  CirBuffer *m_CirBuffer;

  SC_CTOR( AudioDecoder);

  void SampleReady(void);

};

#endif /* AUDIODECODER_H_ */
