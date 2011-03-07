/*
 * EchoCancellation.cpp
 *
 *  Created on: 26/02/2011
 *      Author: saa
 */


#include "EchoCancellation.h"
#include <iostream>
#include <iomanip>
using namespace std;


EchoCancellation::EchoCancellation(sc_module_name nm) :
  sc_module(nm), SampleData(0), EchoData(0)
{
  SC_THREAD( thrd_RunEchoCancellation);
  sensitive << data_ready_in;
}


void EchoCancellation::thrd_RunEchoCancellation(void)
{
#if (MY_DEBUG_1)
  cout << endl;
  cout << "Data     EchoData    OutData" << endl;
  cout << "----     --------    -------" << endl;
#endif
  while (1)
  {
    //wait for negative data_ready edge
    wait();
    if(data_ready_in.read() == SC_LOGIC_1)
    {
      //Read data from ADC (mic)
      SampleData = data_in->read();
      EchoData = echo_in->read();
      //5 µs to simulate Echo cancellation algorithm
      wait(5, SC_US);
#if (MY_DEBUG_1)
      cout <<"\n Echo: "
           << setw(4) << SampleData << "  "
           << setw(4) << EchoData << "  "
           << setw(4) << SampleData - EchoData << endl;
#endif
      data_out->write(SampleData - EchoData);
      //delay due communication on wires
      wait(10, SC_NS);
      ready_out->write(SC_LOGIC_1);
    }
    else
    {
      ready_out->write(SC_LOGIC_0);
    }
  }
}
