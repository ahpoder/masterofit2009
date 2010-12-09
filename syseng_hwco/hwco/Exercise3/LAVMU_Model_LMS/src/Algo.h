//----------------------------------------------------------------------------------------------
// algo.h (systemc)
//
//	Author: KBE / 2010.09.12
//----------------------------------------------------------------------------------------------
#include <systemc.h>
#include "defs.h"

class algo: public sc_module 
{

public:
	// Clock
	sc_in<bool> CLK;    

	// Input ports
	sc_in<sc_int<ALGO_BITS> >  in_dataSN;
	sc_in<sc_int<ALGO_BITS> >  in_dataN;
	
	// Output ports
	sc_out<sc_int<ALGO_BITS> > out_data;

	sc_in<bool> AudioSync;

	sc_in<bool> AudioClk;

	// Programmers View (User parameters)
	// Should be mapped to memory space of processor
	sc_in<sc_int<WBUS> >  in_converg;   // Input register (Set Gain)

private:
	// Local sample buffer
	sc_int<ALGO_BITS> m_sample;
	sc_int<ALGO_BITS> m_SNsample;
	sc_int<ALGO_BITS> m_Nsample;
	int m_converg;

	void LMSProcess();		     // Process of algorithm

	void Entry();

public:
	SC_CTOR(algo)
	{
		SC_THREAD(Entry);	
		sensitive_pos << AudioClk;
	}

};      
