#ifndef AUDIOTOP_H
#define AUDIOTOP_H
//----------------------------------------------------------------------------------------------
// top.h (systemc)
//
//	Author: KBE / 2010.09.12
//----------------------------------------------------------------------------------------------
#include <systemc.h>

class ADCSim;
class DACSim;
class Splitter;
class EchoCancellation;
class AudioDecoding;
class AudioEncoding;

#include <GSM0610DataFrame.h>

class AudioTop : public sc_module
{
public:
	sc_clock AudioClock;

private:
  ADCSim* adcSim;
  DACSim* dacSim;
  Splitter* splitter;
  EchoCancellation* echoCancellation;
  AudioDecoding* audioDecoding;
  AudioEncoding* audioEncoding;

  sc_fifo<int> adcToEchoFifo;
  sc_fifo<int> echoToEncodingFifo;
  sc_fifo<GSM0610DataFrame> encodingToCommunicationFifo;

  sc_fifo<int> decodingToSplitterFifo;
  sc_fifo<int> splitterToDACFifo;
  sc_fifo<int> splitterToEchoFifo;

  sc_fifo<int> speakerToMicrophoneFifo; // To simulate feedback noise

  friend class CommunicationTop;

public:
	SC_CTOR(AudioTop);
	~AudioTop();

};

#endif
