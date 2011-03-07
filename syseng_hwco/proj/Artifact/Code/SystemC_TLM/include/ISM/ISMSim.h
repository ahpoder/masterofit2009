#ifndef ISMSIM_H
#define ISMSIM_H
//----------------------------------------------------------------------------------------------
// top.h (systemc)
//
//	Author: KBE / 2010.09.12
//----------------------------------------------------------------------------------------------
#include <systemc.h>

class ISMSim : public sc_module
{
public:
  // Clock - used to
  sc_in_clk AudioClk;

  sc_fifo_in<std::vector<int> > audio_data_from_communication;
  sc_fifo_in<std::vector<unsigned char> > control_data_from_communication;

  sc_fifo_out<std::vector<int> > audio_data_to_communication;
  sc_fifo_out<std::vector<unsigned char> > control_data_to_communication;
  sc_fifo_out<std::vector<unsigned char> > firmware_data_to_communication;

private:
  void ism_audio_sender_thread();
  void ism_control_sender_thread();

  int clkDivisionCounter;
  void ism_audio_reader_thread();
  void ism_control_reader_thread();
  void ism_firmware_reader_thread();

  FILE* fp_ism_audio_output;
  FILE* fp_ism_audio_input;

public:
	SC_CTOR(ISMSim);
	~ISMSim();
};

#endif
