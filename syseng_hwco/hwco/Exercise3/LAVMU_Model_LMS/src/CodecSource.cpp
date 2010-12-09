//----------------------------------------------------------------------------------------------
// source.cpp (systemc)
//
//	Author: KBE / 2010.09.12
//----------------------------------------------------------------------------------------------
#include <systemc.h>
#include "CodecSource.h"

void CodecSource::entry()
{ 
	int tmp_val;
	int clk_count;
	bool lastAudioSync;
	FILE *fp_data;
	fp_sn = fopen(INPUT_FILE_SIGNALNOISE, "r");
	fp_n = fopen(INPUT_FILE_NOISE, "r");

	AudioInNoise.write(0);
	AudioInSignalNoise.write(0);
	lastAudioSync = true;
	AudioSync.write(true);

	//cout << "CodecSource started" << endl;
	while(true)
	{ 
		clk_count++;
		if (clk_count == AUDIO_SYNC_CNT)
		{
			// Read simulation input data from signal + noise file
			if (fscanf(fp_sn, "%d", &tmp_val) == EOF)
			{
				//cout << "End of Input Stream: Simulation Stops" << endl;
				sc_stop();
				break;
			};
			// Output audio data
			AudioInSignalNoise.write(tmp_val);

			// Read simulation input data from noise file
			if (fscanf(fp_n, "%d", &tmp_val) == EOF)
			{
				//cout << "End of Input Stream: Simulation Stops" << endl;
				sc_stop();
				break;
			};
			// Output audio data
			AudioInNoise.write(tmp_val);

			lastAudioSync = !lastAudioSync;
			AudioSync.write(!lastAudioSync);

			clk_count = 0;
		}
		wait();
	}
}
