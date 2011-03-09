#ifndef DACSIM_H
#define DACSIM_H

#include <systemc.h>

// Sample data at a fixed interval and put it on the fifo
// The data is read from a file
class DACSim : public sc_module
{
public:
  sc_fifo_in<int> data_from_splitter;

  // This is to simulate that the data from the Speakers are
  // also picked up by the microphone
  sc_fifo_out<int> data_to_adcsim;

private:
  void dac_writer_thread();
  FILE* fp_speaker;

public:
	SC_CTOR(DACSim);
	~DACSim();
};

#endif
