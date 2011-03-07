/*
 * AudioEncoder.h
 *
 *  Created on: 17/02/2011
 *      Author: saa
 */

#ifndef AUDIOENCODER_H_
#define AUDIOENCODER_H_

#include <systemc.h>
#include "defines.h"



SC_MODULE(AudioEncoder)
{
  sc_in<sc_logic> hs_Clk_in;

  // Input interface
  sc_in<sc_logic> data_ready_in;
  sc_in<sc_uint<SAMPLE_BITS> > data_in; // Data output from buffer

  // Output interface
  sc_out<bool> ready_out;
  sc_out<sc_uint<COM_BUS_WIDTH> > data_out; // Data output

  //sc_event e1;

  //sc_fifo_in<> EncData;

  bool EncodingDone;
  // Local data for  buffer
  sc_uint<MAX_BITS> len; // Number of samples in buffer
  sc_uint<MAX_BITS> idx;
  sc_uint<COM_BUS_WIDTH> packet[MAX_SIZE];
  sc_uint<COM_BUS_WIDTH> d;

  SC_CTOR( AudioEncoder);

  // Thread to simulate PowerPC empties buffer
  void thrd_EncodeData(void);
  void thrd_SendEncodedData(void);

};

#endif /* AUDIOENCODER_H_ */
