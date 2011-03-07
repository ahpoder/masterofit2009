#ifndef DATAPARSER_H
#define DATAPARSER_H
//----------------------------------------------------------------------------------------------
// top.h (systemc)
//
//	Author: KBE / 2010.09.12
//----------------------------------------------------------------------------------------------
#include <systemc.h>

class DataParser : public sc_module
{
public:
  sc_fifo_in<std::vector<int> > audio_data_from_ism;
  sc_fifo_in<std::vector<unsigned char> > control_data_from_ism;

  sc_fifo_out<std::string> control_data_to_control;
  sc_fifo_out<std::vector<int> > audio_data_to_Audio;

private:
  void audio_data_parser_thread();
  void control_data_parser_thread();

public:
	SC_CTOR(DataParser);
	~DataParser();
};

#endif
