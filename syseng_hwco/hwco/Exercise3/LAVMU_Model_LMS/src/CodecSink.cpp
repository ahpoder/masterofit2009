//----------------------------------------------------------------------------------------------
// CodecSink.cpp (systemc)
//
//	Author: KBE / 2010.09.12
//----------------------------------------------------------------------------------------------
#include <systemc.h>
#include "CodecSink.h"

void CodecSink::entry()
{
	bool AudioSync_last = false;
	int tmp_out;
	sc_int<ALGO_BITS> tmp;
	fp_signal = fopen(OUTPUT_FILE_SIGNAL,"w");

	cout << "CodecSink started" << endl;
	while(true)
	{ 
		// Wait for next AudioSync signal
		if (AudioSync != AudioSync_last)
		{
			tmp = AudioOut.read();
			tmp_out = tmp;
			fprintf(fp_signal, "%d\n", tmp_out);
		}

		AudioSync_last = AudioSync;
		wait();
	}
}
