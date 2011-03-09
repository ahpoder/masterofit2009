#ifndef ISMSIM_H
#define ISMSIM_H
//----------------------------------------------------------------------------------------------
// top.h (systemc)
//
//	Author: KBE / 2010.09.12
//----------------------------------------------------------------------------------------------
#include <systemc.h>

#include <ISMDataFrame.h>

class ISMSim : public sc_module
{
public:
  // Clock - used to
  sc_in_clk AudioClk;

  sc_fifo_in<ISMDataFrame> data_from_communication;

  sc_fifo_out<ISMDataFrame> data_to_communication;

private:
  void ism_sender_thread();

  int clkDivisionCounter;
  void ism_reader_thread();

  FILE* fp_ism_output;
  FILE* fp_ism_input;

public:
	SC_CTOR(ISMSim);
	~ISMSim();
};

#endif
