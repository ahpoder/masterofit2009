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
  while(true)
  {
	std::auto_ptr<GSM0610DataFrame> ptr(data_from_audio.read());

	// Simulate communication delay 33 * 2 * 50ns
	wait(3.3, SC_US);

//	printf("DataHandler::audio_data_handler_thread\r\n");

    ISMDataFrame* tmp_data_to_ism = new ISMDataFrame();
	tmp_data_to_ism->setFrameType(FT_AUDIO);
	tmp_data_to_ism->setFrameContent(ptr->getBuffer(), ptr->length());

	// Simulate handling the data: 177 * 50ns
	wait(8.85, SC_US);

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
