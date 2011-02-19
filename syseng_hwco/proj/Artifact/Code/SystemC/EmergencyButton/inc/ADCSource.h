/*
 * ADCSource.h
 *
 *  Created on: 17/02/2011
 *      Author: saa
 */

#ifndef ADCSOURCE_H_
#define ADCSOURCE_H_
#include <systemc.h>
#include "CirBuffer.h"

#ifdef _EA_IMPORT

class ADCSource : public sc_module
{
  public:

#else

SC_MODULE(ADCSource)
{

#endif

  // Local channels
  sc_in<sc_logic> clk_in;
  sc_out<sc_logic> busy_out;
  sc_out<sc_lv<SAMPLE_BITS> > data_out;

  // Test variables
  sc_uint<SAMPLE_BITS> counter;
  CirBuffer *m_CirBuffer;

  SC_CTOR( ADCSource);

  void SampleReady(void);

};

#endif /* ADCSOURCE_H_ */
