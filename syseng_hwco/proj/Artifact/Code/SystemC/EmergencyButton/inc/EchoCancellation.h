/*
 * EchoCancellation.h
 *
 *  Created on: 26/02/2011
 *      Author: saa
 */

#ifndef ECHOCANCELLATION_H_
#define ECHOCANCELLATION_H_

#include <systemc.h>
#include "defines.h"

SC_MODULE(EchoCancellation)
{
  // Input interface
  sc_in<sc_logic> data_ready_in;
  sc_in<sc_uint<SAMPLE_BITS> > data_in; // Data input from ADC (audio in)
  sc_in<sc_uint<SAMPLE_BITS> > echo_in; // Data input from audio out

  // Output interface
  sc_out<sc_logic> ready_out;// Ready signal when data_out valid
  sc_out<sc_uint<SAMPLE_BITS> > data_out; // Data output

  //sc_event eADC_dataReady;
  sc_uint<SAMPLE_BITS> SampleData;
  sc_uint<SAMPLE_BITS> EchoData;

  SC_CTOR( EchoCancellation);


  // Receives saple data from ADC and executes echo cancellation algorithm
  void thrd_RunEchoCancellation();

};
#endif /* ECHOCANCELLATION_H_ */
