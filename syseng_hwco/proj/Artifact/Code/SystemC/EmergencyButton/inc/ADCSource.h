/*
 * ADCSource.h
 *
 *  Created on: 17/02/2011
 *      Author: saa
 */

#ifndef ADCSOURCE_H_
#define ADCSOURCE_H_

#include <systemc.h>
#include "defines.h"

SC_MODULE(ADCSource)
{
  // Local channels
  sc_in<sc_logic> AudioClk_in;
  sc_out<sc_logic> ready_out;
  sc_out<sc_uint<SAMPLE_BITS> > data_out;

  // Test variables
  sc_uint<SAMPLE_BITS> counter;

  SC_CTOR( ADCSource);

  void thrd_SampleReady(void);
};

#endif /* ADCSOURCE_H_ */
