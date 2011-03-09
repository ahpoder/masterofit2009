#ifndef COMMUNICATIONTOP_H
#define COMMUNICATIONTOP_H

#include <systemc.h>

#include <GSM0610DataFrame.h>
#include <ISMDataFrame.h>

class AudioTop;

class DataHandler;
class DataParser;

class CommunicationTop : public sc_module
{
public:
  void connect(AudioTop* audio);
// TODO connect(ControlTop* control);

private:
  DataHandler* dataHandler;
  DataParser* dataParser;

  sc_fifo<ISMDataFrame> communicationToISMFifo;

  sc_fifo<GSM0610DataFrame> communicationToAudioFifo;
//  sc_fifo<ControlData> communicationToControlFifo;
//  sc_fifo<FirmwareData> communicationToFirmwareFifo;

  friend class ISMTop;

public:
	SC_CTOR(CommunicationTop);
	~CommunicationTop();
};

#endif
