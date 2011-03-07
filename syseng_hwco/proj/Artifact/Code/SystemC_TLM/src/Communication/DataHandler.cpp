#include <Communication/DataHandler.h>

SC_HAS_PROCESS(DataHandler);

DataHandler::DataHandler(sc_module_name nm) :
	sc_module(nm)
{
  SC_THREAD(audio_data_handler_thread);
  SC_THREAD(control_data_handler_thread);
}

DataHandler::~DataHandler()
{

}

void DataHandler::audio_data_handler_thread()
{
  std::vector<int> tmp_dataFromAudio;
  while(true)
  {
	// wait for data
	wait(data_from_audio.data_written_event());

	tmp_dataFromAudio = data_from_audio.read();
	// package data if needed
	audio_data_to_ism.write(tmp_dataFromAudio);
  }
}

void DataHandler::control_data_handler_thread()
{
  std::string tmp_dataFromControl;
  while(true)
  {
	// wait for data
	wait(data_from_control.data_written_event());


	tmp_dataFromControl = data_from_control.read();

	// Package data if needed

	std::vector<unsigned char> tmp_result;
	std::string::iterator itt = tmp_dataFromControl.begin();
	while (itt != tmp_dataFromControl.end())
	{
	  char tmp = *itt;
	  tmp_result.push_back((unsigned char)tmp);
	  ++itt;
	}

	// Output microphone data
	control_data_to_ism.write(tmp_result);
  }
}
