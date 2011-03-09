#ifndef AUDIOENCODING_H
#define AUDIOENCODING_H

#include <systemc.h>

#include <GSM0610DataFrame.h>

#include <vector>

class AudioEncoding : public sc_module
{
public:
  sc_fifo_in<int> data_from_echocancellation;

  sc_fifo_out<GSM0610DataFrame> data_to_communication;

private:
  void audio_encoding_thread();

public:
	SC_CTOR(AudioEncoding);
	~AudioEncoding();
};

#endif
