#include <Communication/DataParser.h>

SC_HAS_PROCESS(DataParser);

DataParser::DataParser(sc_module_name nm) :
	sc_module(nm)
{
  SC_THREAD(audio_data_parser_thread);
  SC_THREAD(control_data_parser_thread);
}

DataParser::~DataParser()
{

}

void DataParser::audio_data_parser_thread()
{
  std::vector<int> tmp_dataFromISM;
  while(true)
  {
	// wait for data
	wait(audio_data_from_ism.data_written_event());

	tmp_dataFromISM = audio_data_from_ism.read();
	// package data if needed
	audio_data_to_Audio.write(tmp_dataFromISM);
  }
}

void DataParser::control_data_parser_thread()
{
  std::vector<unsigned char> tmp_result;
  while(true)
  {
	// wait for data
	wait(control_data_from_ism.data_written_event());


	tmp_result = control_data_from_ism.read();

	// Package data if needed
    std::string tmp_dataToControl;
    std::vector<unsigned char>::iterator itt = tmp_result.begin();
	while (itt != tmp_result.end())
	{
	  char tmp = *itt;
	  tmp_dataToControl += tmp;
	  ++itt;
	}

	// Output microphone data
	control_data_to_control.write(tmp_dataToControl);
  }
}
