#include <Communication/CommunicationTop.h>

#include <Audio/AudioTop.h>

#include <Communication/DataHandler.h>
#include <Communication/DataParser.h>

#include <Audio/AudioDecoding.h>

SC_HAS_PROCESS(CommunicationTop);

CommunicationTop::CommunicationTop(sc_module_name nm) :
	sc_module(nm),
	communicationToISMFifo("CommunicationToISMFifo"),
	communicationToAudioFifo("CommunicationToAudioFifo")
{
  dataHandler = new DataHandler("DataHandler");
  dataParser = new DataParser("DataParser");

  dataHandler->data_to_ism(communicationToISMFifo);

  dataParser->audio_data_to_Audio(communicationToAudioFifo);
//  dataParser->control_data_to_control(communicationToControlFifo);
//  dataParser->firmware_data_to_firmware_update(communicationToFirmwareFifo);
}

CommunicationTop::~CommunicationTop()
{
  delete dataHandler;
  delete dataParser;
}

void CommunicationTop::connect(AudioTop* audio)
{
  dataHandler->data_from_audio(audio->encodingToCommunicationFifo);
  audio->audioDecoding->data_from_communication(communicationToAudioFifo);
}
