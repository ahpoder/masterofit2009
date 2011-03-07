/*
 * CommunicationSim.h
 *
 *  Created on: 28/02/2011
 *      Author: saa
 */

#ifndef COMMUNICATIONSIM_H_
#define COMMUNICATIONSIM_H_

#include <systemc.h>
#include "defines.h"

SC_MODULE(CommunicationSim)
{
  sc_in<sc_logic> hs_Clk_in;

  // Input interface
  sc_in<bool> data_ready_in;
  sc_in<sc_uint<SAMPLE_BITS> > data_in; // Data output from Audio Encoder

  // Output interface
  sc_out<bool> ready_out;
  sc_out<sc_uint<SAMPLE_BITS> > data_out; // Data output to ISM
  sc_uint<SAMPLE_BITS> d;


  SC_CTOR( CommunicationSim);

  // Thread to simulate Communication block
  void thrd_SimulateCommunication();

};

#endif /* COMMUNICATIONSIM_H_ */
