#ifndef DATAPARSER_H
#define DATAPARSER_H
//----------------------------------------------------------------------------------------------
// top.h (systemc)
//
//	Author: KBE / 2010.09.12
//----------------------------------------------------------------------------------------------
#include <systemc.h>

#include <GSM0610DataFrame.h>
#include <ISMDataFrame.h>
//#include <ControlData.h>
//#include <FirmwareData.h>

class DataParser : public sc_module
{
public:
  sc_fifo_in<ISMDataFrame*> data_from_ism;

//  sc_fifo_out<ControlData> control_data_to_control;
//  sc_fifo_out<FirmwareData> firmware_data_to_firmware_update;
  sc_fifo_out<GSM0610DataFrame*> audio_data_to_Audio;

private:
  void data_parser_thread();

public:
	SC_CTOR(DataParser);
	~DataParser();
};

#endif
