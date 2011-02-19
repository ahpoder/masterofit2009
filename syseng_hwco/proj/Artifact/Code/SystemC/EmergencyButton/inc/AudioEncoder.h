/*
 * AudioEncoder.h
 *
 *  Created on: 17/02/2011
 *      Author: saa
 */

#ifndef AUDIOENCODER_H_
#define AUDIOENCODER_H_

#include <systemc.h>
#include "CirBuffer.h"

#ifdef _EA_IMPORT

class Communication : public sc_module
{
  public:

#else

SC_MODULE(AudioEncoder)
{

#endif

  // Input interface
  sc_out<bool> read_out; // Read stobe for data in buffer
  sc_in<bool> ready_in; // Ready signal when data_out valid
  sc_in<sc_uint<SAMPLE_BITS> > data_in; // Data ouput from buffer

  SC_CTOR( AudioEncoder);

  // Thread to simulate PowerPC empties buffer
  void Simulate();

};

#endif /* AUDIOENCODER_H_ */
