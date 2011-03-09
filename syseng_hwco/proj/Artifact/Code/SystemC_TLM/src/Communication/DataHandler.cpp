#include <Communication/DataHandler.h>

#include <util.h>

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
  unsigned char buffer[1500];
  GSM0610DataFrame tmp_dataFromAudio;
  ISMDataFrame tmp_data_to_ism;
  int i;
  int temp;
  while(true)
  {
	tmp_dataFromAudio = data_from_audio.read();

	tmp_data_to_ism.setFrameType(FT_AUDIO);

	for (i = 0; i < tmp_dataFromAudio.length(); ++i)
	{
		temp = tmp_dataFromAudio.at(i);
		temp = htonl(temp);
		memcpy((buffer + (i*4)), &temp, 4);
	}

	tmp_data_to_ism.setFrameContent(buffer, tmp_dataFromAudio.length() * 4);

	data_to_ism.write(tmp_data_to_ism);
  }
}

void DataHandler::control_data_handler_thread()
{
	/*
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
*/
}