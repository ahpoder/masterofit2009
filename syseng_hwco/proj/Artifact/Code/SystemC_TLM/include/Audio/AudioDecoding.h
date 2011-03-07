#ifndef AUDIODECODING_H
#define AUDIODECODING_H

#include <systemc.h>

#include <vector>

class AudioDecoding : public sc_module
{
public:
  // Clock
  sc_in_clk AudioClk;

  sc_fifo_in<std::vector<int> > data_from_communication;

  sc_fifo_out<int> data_to_splitter;

private:
  GSM0610DataFrame buffer[10]; // Buffer can hold 10 frames from ISM.
  void audio_decoding_thread();

  // Double buffered for quick switch. A full decoded buffer is
  // always available
  int playbackBuffer1[1280]; // Buffer can hold a single decoded frame
  int playbackBuffer2[1280]; // Buffer can hold a single decoded frame
  void audio_playback_thread();

public:
	SC_CTOR(AudioDecoding);
	~AudioDecoding();
};

#endif
