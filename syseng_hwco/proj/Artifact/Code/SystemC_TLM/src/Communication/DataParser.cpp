#include <Communication/DataParser.h>

#include <util.h>
#include <memory>

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
  const unsigned char* ismData;
  while(true)
  {
    std::auto_ptr<ISMDataFrame> ptr(data_from_ism.read());
//	printf("DataParser::data_parser_thread\r\n");

	switch (ptr->getFrameType())
	{
	case FT_AUDIO:
	{
		GSM0610DataFrame* audioFrame = new GSM0610DataFrame();
		ismData = ptr->getBuffer();
		audioFrame->push_back_all(ismData, ptr->length());
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
