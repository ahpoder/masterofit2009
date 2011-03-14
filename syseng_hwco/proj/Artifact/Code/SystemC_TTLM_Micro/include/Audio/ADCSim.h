#ifndef ADCSIM_H
#define ADCSIM_H

#include <systemc.h>

// Sample data at a fixed interval and put it on the fifo
// The data is read from a file
class ADCSim : public sc_module
{
public:
  // Clock
  sc_in_clk AudioClk;

  sc_fifo_out<short> data_to_echo_cancellation;

  // This is to simulate that the data from the Speakers are
  // also picked up by the microphone
  sc_fifo_in<short> data_from_speakers;

private:
  void adc_reader_thread();
  FILE* fp_microphone;

public:
	SC_CTOR(ADCSim);
	~ADCSim();
};

#endif
