/*
 * ADCSource.cpp
 *
 *  Created on: 17/02/2011
 *      Author: saa
 */

#include "ADCSource.h"

ADCSource::ADCSource(sc_module_name nm) :
  sc_module(nm), counter(0)
{
  SC_THREAD( thrd_SampleReady);
  sensitive << AudioClk_in.pos();
  //dont_initialize();
}

void ADCSource::thrd_SampleReady(void)
{
  while(true)
  {
    wait();
    ready_out->write(SC_LOGIC_0);
    sc_uint<SAMPLE_BITS> d = rand()&0xfff;
//    sc_uint < SAMPLE_BITS > d = counter;
//    counter += 1;
    //Simulate ADC internal propagation delay
    wait(500, SC_NS);
    //wait(SC_ZERO_TIME);
    data_out->write(d);
#if (MY_DEBUG_1)
    cout << endl << "ADC_data_out: " << d << endl;
#endif
    //delay due communication on wires
    wait(10, SC_NS);
    ready_out->write(SC_LOGIC_1);
  }
}

