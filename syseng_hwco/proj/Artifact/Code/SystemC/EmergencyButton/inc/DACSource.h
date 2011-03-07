/*
 * DACSource.h
 *
 *  Created on: 19/02/2011
 *      Author: saa
 */

#ifndef DACSOURCE_H_
#define DACSOURCE_H_

#include <systemc.h>
#include "defines.h"
//#include "AudioEncoder.h"


SC_MODULE(DACSource)
{

  // Input interface
  sc_in<sc_logic> AudioClk_in;
  sc_in<sc_uint<SAMPLE_BITS> > data_in; // Data ouput from buffer

  SC_CTOR( DACSource);

  // Thread to simulate PowerPC empties buffer
  void thrd_getData(void);

};

#endif /* DACSOURCE_H_ */
