#include <Communication/DataParser.h>

#include <util.h>

SC_HAS_PROCESS(DataParser);

DataParser::DataParser(sc_module_name nm) :
	sc_module(nm)
{
  SC_THREAD(data_parser_thread);
}

DataParser::~DataParser()
{

}

void DataParser::data_parser_thread()
{
  ISMDataFrame tmp_dataFromISM;
  int temp;
  int i;
  const unsigned char* ismData;
  while(true)
  {
	tmp_dataFromISM = data_from_ism.read();
	switch (tmp_dataFromISM.getFrameType())
	{
	case FT_AUDIO:
	{
		GSM0610DataFrame audioFrame;
		ismData = tmp_dataFromISM.getBuffer();

		for (i = 0; i < tmp_dataFromISM.length(); i += 4)
		{
			memcpy(&temp, ismData + i, 4);
			temp = ntohl(temp);
			audioFrame.push_back(temp);
		}
		audio_data_to_Audio.write(audioFrame);
	}
		break;
	case FT_CONTROL:
		break;
	case FT_FIRMWARE:
		break;
	case FT_UNKNOWN:
		break;
	}
  }
}
