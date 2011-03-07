/*
 * main.cpp
 *
 *  Created on: 17/02/2011
 *      Author: saa
 */

#include "AudioTop.h"
//#include <systemc.h>

#if defined(_MSC_VER) || defined (__CYGWIN__)

// Visual Studio version
int sc_main(int argc, char **argv)
{
  // Depricated since version SystemC version 2.2 is used
  //sc_report_handler::set_actions("/IEEE_Std_1666/deprecated", SC_DO_NOTHING);


#if defined(_MSC_VER)
  cout << "\n\tVisual Studio 8.0 - build with SystemC Ver.:" SC_RELEASE_STRING << "\n\n";
#endif

#if defined(__CYGWIN__)
  cout << "\n\tEclipse 3.3 and Cygwin - build with SystemC Ver.:" SC_RELEASE_STRING << "\n\n";
#endif

  AudioTop AudioTop("EmergencyButtonTest");

  sc_start(3, SC_MS);

  return 0;
}

#else

SC_MODULE_EXPORT(ADCTop);

#endif
