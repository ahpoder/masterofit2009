/*
 * AudioDecoder.h
 *
 *  Created on: 19/02/2011
 *      Author: saa
 */

#ifndef AUDIODECODER_H_
#define AUDIODECODER_H_

#include <systemc.h>
#include "defines.h"
//#include "AudioEncoder.h"

SC_MODULE(AudioDecoder)
{
  // Local channels
  sc_in<sc_logic> AudioClk_in;
  sc_in<sc_logic> hs_Clk_in;
  sc_in<bool> data_ready_in;
  sc_in< sc_uint<COM_BUS_WIDTH> > data_in; // Data output from ISM
  sc_out<sc_uint<SAMPLE_BITS> > data_out;//Data to DAC

  //mutex to control access to the buffer
  sc_mutex bufferAccess;

  // Local data for  buffer
  sc_uint<MAX_BITS> idx; // index to address buffer elements
  sc_uint<MAX_BITS> len; // Number of samples in buffer
  sc_uint<MAX_BITS> templen;
  sc_uint<SAMPLE_BITS> buffer_out[MAX_SIZE];
  sc_uint<COM_BUS_WIDTH> packet_in[MAX_SIZE];


  SC_CTOR( AudioDecoder);

  void thrd_GetData(void);
  void thrd_DecodeData(void);
};

#endif /* AUDIODECODER_H_ */
