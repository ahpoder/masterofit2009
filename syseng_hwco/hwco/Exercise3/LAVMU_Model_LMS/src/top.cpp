//----------------------------------------------------------------------------------------------
// top.cpp (systemc)
//
//	Author: KBE / 2010.09.12
//----------------------------------------------------------------------------------------------
#include "algo.h"
#include "Top.h"

Top::Top(sc_module_name nm) : 

	sc_module(nm),

	clock("clock", sc_time(CLK_PERIODE, SC_NS) ),
	AudioClock("AudioClock", sc_time(AUDIOCLK_PER, SC_NS) ),

	AudioInNoise("AudioInNoise"),
	AudioInSignalNoise("AudioInSignalNoise"),
	AudioSync("AudioSync"),
	AudioOut("AudioOut")
{

	// Create instances
	
	pSource = new CodecSource("CodecSource");
	pAlgo = new algo("Algo");
	pSink = new CodecSink("CodecSink");
	pPView = new PView("PView");

	// Reset high
	reset.write(true);

	// Assign ports to channels 

	pAlgo->AudioSync(AudioSync);
	// Sample data input interface
	pAlgo->in_dataN(AudioInNoise);
	pAlgo->in_dataSN(AudioInSignalNoise);
	// Sample data output interface
	pAlgo->out_data(AudioOut);

	// Programmers View user register
	pAlgo->CLK(clock.signal());
	pAlgo->AudioClk(AudioClock.signal());

	// Source to simulate audio input from codec
	pSource->AudioInNoise(AudioInNoise);
	pSource->AudioInSignalNoise(AudioInSignalNoise);
	pSource->AudioSync(AudioSync);
	pSource->AudioClk(AudioClock.signal());
	 
	// Sink to simulate audio output to codec
	pSink->AudioOut(AudioOut);
	pSink->AudioSync(AudioSync);
	pSink->AudioClk(AudioClock.signal());

	// User to simulate Programmers View
	pPView->reset(reset);
	pPView->set_converg(in_converg);
	pPView->CLK(clock.signal());

	// Create tacefile
	tracefile = sc_create_vcd_trace_file("LAVMU_Wave");
	if (!tracefile) cout << "Could not create trace file." << endl;

	// Set resolution of trace file to be in 10 US
	tracefile->set_time_unit(1, SC_NS);

	sc_trace(tracefile, clock.signal(), "clock");

	sc_trace(tracefile, AudioClock.signal(), "AudioClock");

	sc_trace(tracefile, reset, "reset");

	sc_trace(tracefile, in_converg, "in_converg");

	sc_trace(tracefile, AudioSync, "AudioSync");
	sc_trace(tracefile, AudioInNoise, "AudioInNoise");
	sc_trace(tracefile, AudioInSignalNoise, "AudioInSignalNoise");
	sc_trace(tracefile, AudioOut, "AudioOut");
}

Top::~Top()
{
	sc_close_vcd_trace_file(tracefile);

	cout << "Created LAVMU_Wave.vcd" << endl;
}
