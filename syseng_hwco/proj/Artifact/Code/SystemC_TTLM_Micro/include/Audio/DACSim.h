#ifndef DACSIM_H
#define DACSIM_H

#include <systemc.h>

// Sample data at a fixed interval and put it on the fifo
// The data is read from a file
class DACSim : public sc_module
{
public:
  sc_fifo_in<short> data_from_splitter;

  // This is to simulate that the data from the Speakers are
  // also picked up by the microphone
  sc_fifo_out<short> data_to_adcsim;

private:
  void dac_writer_thread();
  void dac_feedback_thread();
  FILE* fp_speaker;
  sc_event firstSampleArrived;
  sc_fifo<short> bufferForEcho;

public:
	SC_CTOR(DACSim);
	~DACSim();
};

#endif
