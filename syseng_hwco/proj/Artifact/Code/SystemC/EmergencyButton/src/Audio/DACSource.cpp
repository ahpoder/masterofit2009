/*
 * DACSource.cpp
 *
 *  Created on: 19/02/2011
 *      Author: saa
 */

#include "DACSource.h"
//#include "EmBtnTop.h"
#include <iostream>
#include <iomanip>
using namespace std;


DACSource::DACSource(sc_module_name nm) :
  sc_module(nm)
{
  SC_THREAD( thrd_getData);
  sensitive << AudioClk_in.neg();
  dont_initialize();
}

void DACSource::thrd_getData(void)
{
  while (true)
  {
    wait();
    //Simulate DAC's internal propagation delay
    wait(20, SC_NS);
    //cout << data_in->read();
  }
}
