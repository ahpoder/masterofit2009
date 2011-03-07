#include <ISM/ISMSim.h>
#include <ISM/defs.h>

SC_HAS_PROCESS(ISMSim);

ISMSim::ISMSim(sc_module_name nm) :
	sc_module(nm), clkDivisionCounter(10) // Start by reaing a value
{
  SC_THREAD(ism_audio_sender_thread);
  SC_THREAD(ism_control_sender_thread);

  SC_THREAD(ism_audio_reader_thread);
  SC_THREAD(ism_control_reader_thread);
  SC_THREAD(ism_firmware_reader_thread);

  fp_ism_audio_input = fopen(INPUT_FILE_AUDIO_ISM, "r");
  fp_ism_audio_output = fopen(OUTPUT_FILE_AUDIO_ISM, "w");
}

ISMSim::~ISMSim()
{
  fclose(fp_ism_audio_input);
  fclose(fp_ism_audio_output);
}

void ISMSim::ism_audio_sender_thread()
{
  std::vector<int> tmp_dataFromCommunication;
  while(true)
  {
	// This wait serves no purpose, as the read is blocking!
	wait(audio_data_from_communication.data_written_event());

	tmp_dataFromCommunication = audio_data_from_communication.read();

	std::vector<int>::iterator itt = tmp_dataFromCommunication.begin();
	while (itt != tmp_dataFromCommunication.end())
	{
	  fprintf(fp_ism_audio_output,"%d\r\n", *itt);
      ++itt;
	}
  }
}

void ISMSim::ism_control_sender_thread()
{

}

void ISMSim::ism_audio_reader_thread()
{
  int tmp_val_audio;
  int i;

  // Read 128 integers
  while(true)
  {
	if (clkDivisionCounter++ == 10)
	{
		std::vector<int> tmp_dataFromISMFile;
		for (i = 0; i < 128; ++i)
		{
			if (fscanf(fp_ism_audio_input, "%d", &tmp_val_audio) == EOF)
			{
				sc_stop();
				return;
			}
			tmp_dataFromISMFile.push_back(tmp_val_audio);
		}
		clkDivisionCounter = 0;
		audio_data_to_communication.write(tmp_dataFromISMFile);
	}
	wait(AudioClk);
  }
}

void ISMSim::ism_control_reader_thread()
{

}

void ISMSim::ism_firmware_reader_thread()
{

}
