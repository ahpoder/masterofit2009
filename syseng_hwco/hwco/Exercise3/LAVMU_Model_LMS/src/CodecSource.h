//----------------------------------------------------------------------------------------------
// source.h (systemc)
//
//	Author: KBE / 2010.09.12
//----------------------------------------------------------------------------------------------
#include "defs.h"

class CodecSource: public sc_module
{
public:
	// Clock
	sc_in_clk AudioClk;

	// Ports
	sc_out<sc_int<ALGO_BITS> >  AudioInNoise;
	sc_out<sc_int<ALGO_BITS> >  AudioInSignalNoise;
	sc_out<bool> AudioSync;

	void entry();

	SC_CTOR(CodecSource)
    {
      SC_THREAD(entry);
	  sensitive_pos << AudioClk;
   	  dont_initialize();
    }

	~CodecSource()
	{
	  fclose(fp_sn);
	  fclose(fp_n);
	}

private:
	FILE *fp_sn;
	FILE *fp_n;

};
