//----------------------------------------------------------------------------------------------
// algo.cpp (systemc)
//
//	Author: KBE / 2010.09.12
//----------------------------------------------------------------------------------------------
// This is the implementation of the algorithm
#include "algo.h"

extern "C" {
	#include "LMSFilter.h"
}

#define LMSLen				128		// Length of LMS adaptive filter

// LMS Filter section
static short LMSDelay[LMSLen];
static short LMSWeights[LMSLen];

/** 
   Algo entry function
*/
void algo::Entry()
{ 
	// Variable Declarations
	sc_int<ALGO_BITS> tmp_data;
	bool AudioSync_last = false;
	m_converg = -1;

	// Thread loop
	cout << "Algo started" << endl;
	while(true)
	{ 
		if (AudioSync != AudioSync_last)
		{
			// Signal + Noise channel
			m_SNsample = in_dataSN.read();
			// Noise channel
			m_Nsample = in_dataN.read();
			LMSProcess();
			out_data.write(m_sample);

		}
		AudioSync_last = AudioSync;

		wait();
	}      
}

/** 
  Processing data block. Performs Input gain, IIR filter and peak detector.

  Gain is performed on input signal x = g*input
  IIR filter (Biquad) y = a0*x + a1*x1 + a2*x2 - b0*y1 - b1*y2 
  Peak is detected on output signal y
  Algo processing time in cycles = ALGO_BLOCK_SIZE + 1
*/
void algo::LMSProcess()
{
	short output;
	short error;
	// Read LMS convergence factor
	int in_convergence = in_converg.read();
		
	// Test if different.
	if (m_converg != in_convergence)
	{
	  m_converg = in_convergence;
	  initLMSFilter(LMSDelay, LMSWeights, LMSLen, m_converg);
	}

	LMSFilter(m_Nsample, m_SNsample, &output, &error);

	// Save output
	m_sample = error;
}
