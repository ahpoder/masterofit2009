//----------------------------------------------------------------------------------------------
// PView.h (systemc)
//
//	Author: KBE / 2010.09.12
//----------------------------------------------------------------------------------------------
#include <systemc.h>
#include "defs.h"

// Macro to wait a number of ms
#define WaitMs(ms) 	wait(CLK_PERIODE*200*ms, SC_NS)

// Macro to print log text
#define LogTxt(txt)	cout << "Time " << sc_time_stamp().to_double() << " " << txt << endl;

class PView: public sc_module
{
public:
	// Clock
	sc_in_clk CLK;   
	sc_out<bool> reset;

	sc_out<sc_int<WBUS> >  set_converg;  // LMS convergence factor

private:

	void SetConvergenceFactor(void);
	void Entry(); 

public:
	SC_CTOR(PView);
};
