#ifndef DATAHANDLER_H
#define DATAHANDLER_H
//----------------------------------------------------------------------------------------------
// top.h (systemc)
//
//	Author: KBE / 2010.09.12
//----------------------------------------------------------------------------------------------
#include <systemc.h>

class DataHandler : public sc_module
{
public:
  sc_fifo_in<GSM0610DataFrame > data_from_audio;
  sc_fifo_in<std::string> data_from_control;

  sc_fifo_out<std::vector<int> > audio_data_to_ism;
  sc_fifo_out<std::vector<unsigned char> > control_data_to_ism;

private:
  void audio_data_handler_thread();
  void control_data_handler_thread();

public:
	SC_CTOR(DataHandler);
	~DataHandler();
};

#endif
