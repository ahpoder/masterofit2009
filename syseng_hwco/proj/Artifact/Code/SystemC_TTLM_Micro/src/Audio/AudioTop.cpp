#include <Audio/AudioTop.h>

#include <Audio/ADCSim.h>
#include <Audio/DACSim.h>
#include <Audio/Splitter.h>
#include <Audio/EchoCancellation.h>
#include <Audio/AudioDecoding.h>
#include <Audio/AudioEncoding.h>

SC_HAS_PROCESS(AudioTop);

AudioTop::AudioTop(sc_module_name nm) :
		                                   // 125us = 8kHz
	sc_module(nm), AudioClock("AudioClock", sc_time(125, SC_US) ),
	adcToEchoFifo("ADCToEchoFifo"),
	echoToEncodingFifo("EchoToEncodingFifo"),
	encodingToCommunicationFifo("EncodingToCommunicationFifo"),
	decodingToSplitterFifo("DecodingToSplitterFifo"),
	splitterToDACFifo("SplitterToDACFifo"),
	splitterToEchoFifo("SplitterToEchoFifo"),
	speakerToMicrophoneFifo("SpeakerToMicrophoneFifo")
{
  adcSim = new ADCSim("ADCSim");
  dacSim = new DACSim("DACSim");
  splitter = new Splitter("Splitter");
  echoCancellation = new EchoCancellation("EchoCancellation");
  audioDecoding = new AudioDecoding("AudioDecoding");
  audioEncoding = new AudioEncoding("AudioEncoding");

  // Connect the fifo's
  adcSim->data_from_speakers(speakerToMicrophoneFifo);
  adcSim->data_to_echo_cancellation(adcToEchoFifo);

  echoCancellation->data_from_adc(adcToEchoFifo);
  echoCancellation->data_to_audio_encoding(echoToEncodingFifo);
  echoCancellation->data_from_splitter(splitterToEchoFifo);

  audioEncoding->data_from_echocancellation(echoToEncodingFifo);
  audioEncoding->data_to_communication(encodingToCommunicationFifo);

  dacSim->data_from_splitter(splitterToDACFifo);
  dacSim->data_to_adcsim(speakerToMicrophoneFifo);

  splitter->data_to_echocancellation(splitterToEchoFifo);
  splitter->data_to_dac(splitterToDACFifo);
  splitter->data_from_decoding(decodingToSplitterFifo);

  audioDecoding->data_to_splitter(decodingToSplitterFifo);
  // The last one is set by communication
  //audioDecoding->data_from_communication

  audioDecoding->AudioClk(AudioClock.signal());
  adcSim->AudioClk(AudioClock.signal());
}

AudioTop::~AudioTop()
{
  delete adcSim;
  delete dacSim;
  delete splitter;
  delete echoCancellation;
  delete audioDecoding;
  delete audioEncoding;
}

