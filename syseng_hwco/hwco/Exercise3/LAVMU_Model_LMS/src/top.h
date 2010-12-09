#ifndef TOP_H
#define TOP_H
//----------------------------------------------------------------------------------------------
// top.h (systemc)
//
//	Author: KBE / 2010.09.12
//----------------------------------------------------------------------------------------------
#include <systemc.h>
#include "defs.h"
#include "CodecSink.h"
#include "CodecSource.h"
#include "PView.h"

class Top : public sc_module
{
public:
	// Sample clock
	sc_clock clock;								
	sc_clock AudioClock;
	sc_signal<bool> reset; // Reset signal

	// Input channels/signals
	sc_signal<sc_int<ALGO_BITS> > AudioInNoise;
	sc_signal<sc_int<ALGO_BITS> > AudioInSignalNoise;
	sc_signal<bool> AudioSync;

	// Output channels/signals
	sc_signal<sc_int<ALGO_BITS> > AudioOut;

	// Programmers View - User registers
	sc_signal<sc_int<WBUS> >  in_converg;  // Input register (LMS convergence factor)


private:
	// Modules and Components 
	CodecSource *pSource;
	algo *pAlgo;
	CodecSink *pSink;
	PView *pPView;

	sc_trace_file *tracefile;

public:
	SC_CTOR(Top);
	~Top();

};

#endif
