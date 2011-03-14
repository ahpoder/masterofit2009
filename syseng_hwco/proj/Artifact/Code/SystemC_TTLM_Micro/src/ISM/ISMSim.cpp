#include <ISM/ISMSim.h>
#include <ISM/defs.h>
#include <util.h>

SC_HAS_PROCESS(ISMSim);

ISMSim::ISMSim(sc_module_name nm) :
	sc_module(nm), clkDivisionCounter(160) // Start by reaing a value
{
  SC_THREAD(ism_sender_thread);
  SC_THREAD(ism_reader_thread);
  sensitive << AudioClk;
  dont_initialize();

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
  const unsigned char* sendBuf;
  int i;
  short temp;
  while(true)
  {
	std::auto_ptr<ISMDataFrame> ptr(data_from_communication.read());

	// Simulate the communication delay: 2*37*50ns
	wait(3.7, SC_US);

//	printf("ISMSim::ism_sender_thread\r\n");

	switch (ptr->getFrameType())
	{
	case FT_AUDIO:
		sendBuf = ptr->getBuffer();
		for (i = 0; i < ptr->length(); i+=2)
		{
		  memcpy(&temp, sendBuf + i, 2);
		  temp = ntohs(temp);
		  fprintf(fp_ism_output,"%hd\r\n", temp);
		}
		break;
	default:
		// ERROR
		break;
	}
  }
}

bool ISMSim::readData()
{
  short tmp_val_ism;
  unsigned char buf[2];
  int i;
//	printf("ISMSim::ism_reader_thread\r\n");

	ISMDataFrame* tmp_dataFromISMFile = new ISMDataFrame();
	tmp_dataFromISMFile->setFrameType(FT_AUDIO);

	for (i = 0; i < 16; ++i) // 32 bytes as 16 short
	{
		if (fscanf(fp_ism_input, "%hd", &tmp_val_ism) == EOF)
		{
			return false;
		};
		tmp_val_ism = htons(tmp_val_ism);
		memcpy(buf, &tmp_val_ism, 2);
		tmp_dataFromISMFile->push_back(buf[1]);
		tmp_dataFromISMFile->push_back(buf[0]);
	}

	data_to_communication.write(tmp_dataFromISMFile);
	return true;
}

void ISMSim::ism_reader_thread()
{
  // Do a little buffering
  readData();
  readData();
  while(true)
  {
	if (--clkDivisionCounter == 0) //  160 shorts in each packet
	{
		if (!readData())
		{
			printf("No more ism input data\r\n");
//			sc_stop();
			return;
		}
		clkDivisionCounter = 160;
	}
//	wait(125, SC_US); // packets should be received at 50Hz
//	wait(AudioClk.posedge_event());
	wait();
  }
}
