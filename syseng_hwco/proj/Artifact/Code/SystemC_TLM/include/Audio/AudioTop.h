#ifndef AUDIOTOP_H
#define AUDIOTOP_H
//----------------------------------------------------------------------------------------------
// top.h (systemc)
//
//	Author: KBE / 2010.09.12
//----------------------------------------------------------------------------------------------
#include <systemc.h>

class ADCSim;
class DACSim;

class AudioTop : public sc_module
{
public:

private:
  ADCSim* adcSim;
  DACSim* dacSim;


public:
	SC_CTOR(AudioTop);
	~AudioTop();

};

#endif
