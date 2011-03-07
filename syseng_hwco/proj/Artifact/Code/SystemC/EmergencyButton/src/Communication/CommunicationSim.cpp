/*
 * CommunicationSim.cpp
 *
 *  Created on: 28/02/2011
 *      Author: saa
 */

#include "CommunicationSim.h"
#include "defines.h"

#include <iostream>
#include <iomanip>
using namespace std;
//#include "EmBtnTop.h"
//#include "AudioEncoder.h"
//extern AudioEncoder      *pAEnc;

CommunicationSim::CommunicationSim(sc_module_name nm) :
  sc_module(nm)
{
  SC_THREAD( thrd_SimulateCommunication);
  sensitive << data_ready_in;
}

void CommunicationSim::thrd_SimulateCommunication(void)
{
  while(true)
  {
    wait();//wait for dataReady event
    if(data_ready_in.read() == true)
    {
      ready_out.write(false);
      d = data_in.read();
#if (MY_DEBUG_1)
      cout << "\n ComSim: data_in = " << setw(3) << d <<endl ;
#endif
    }
    else
    {//write data at neg edge
      data_out.write(d);
      wait(10,SC_NS);
      ready_out.write(true);
#if (MY_DEBUG_1)
      cout << "\n ComSim: dataout = " << setw(3) << d <<endl ;
#endif
      //signal data packet ready (toggle ready_out)
    }
  }
}
