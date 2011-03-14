#ifndef AUDIODECODING_H
#define AUDIODECODING_H

#include <systemc.h>

#include <stl/circular.h>
#include <GSM0610DataFrame.h>

class AudioDecoding : public sc_module
{
public:
  // Clock
  sc_in_clk AudioClk;

  sc_fifo_in<GSM0610DataFrame*> data_from_communication;

  sc_fifo_out<short> data_to_splitter;

private:
  sc_mutex receiveBufferLock;
  // Here is a memory leak if the buffer overflows
  circular_buffer<GSM0610DataFrame*> receiveBuffer; // Buffer can hold 10 frames from ISM.
  void audio_receiving_thread();

  void audio_decoding_thread();

// Double buffered for quick switch. A full decoded buffer is
  // always available
  sc_event buffersChanged;
  sc_mutex playbackBufferLock; // Only when the buffer is switched or validity is updated
  	  	  	  	  	  	  	  // is there a need to have a mutual exclusion

  int playbackBufferLength[2];
  short playbackBuffer[2][160]; // Buffer can hold a single decoded frame
  	  	  	  	  	  	  	  	// and there is 2 to use double buffering

  int audioBufferOffset;
  int activeAudioBuffer;
  void audio_playback_thread();

public:
	SC_CTOR(AudioDecoding);
	~AudioDecoding();
};

#endif
