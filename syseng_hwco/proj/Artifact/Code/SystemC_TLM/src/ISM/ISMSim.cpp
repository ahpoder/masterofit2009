#include <ISM/ISMSim.h>
#include <ISM/defs.h>

SC_HAS_PROCESS(ISMSim);

ISMSim::ISMSim(sc_module_name nm) :
	sc_module(nm), clkDivisionCounter(10) // Start by reaing a value
{
  SC_THREAD(ism_sender_thread);
  SC_THREAD(ism_reader_thread);

  fp_ism_input = fopen(INPUT_FILE_ISM, "r");
  fp_ism_output = fopen(OUTPUT_FILE_ISM, "w");
}

ISMSim::~ISMSim()
{
  fclose(fp_ism_input);
  fclose(fp_ism_output);
}

void ISMSim::ism_sender_thread()
{
  unsigned char sendBuf[1504];
  int length;
  int i;
  ISMDataFrame tmp_dataFromCommunication;
  while(true)
  {
	tmp_dataFromCommunication = data_from_communication.read();

	length = tmp_dataFromCommunication.serialize(sendBuf, sizeof(sendBuf));
	while (i < length)
	{
	  fprintf(fp_ism_output,"%d\r\n", sendBuf[i]);
	  ++i;
	}
  }
}

void ISMSim::ism_reader_thread()
{
  unsigned char buffer[(128 * 4) + 4];

  // Read 128 integers
  while(true)
  {
	if (clkDivisionCounter++ == 10)
	{
		ISMDataFrame tmp_dataFromISMFile;
		int length = fread(buffer, 1, sizeof(buffer), fp_ism_input);
		if (length > 4) // minimum a header
		{
			tmp_dataFromISMFile.deserialize(buffer, length);
			clkDivisionCounter = 0;
			data_to_communication.write(tmp_dataFromISMFile);
		}
		else
		{
			sc_stop();
			return;
		}
	}
	wait(AudioClk);
  }
}
