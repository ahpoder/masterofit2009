#include <Audio/AudioEncoding.h>

extern "C"
{
#include "AudioEncodingAlgo.h"
}

SC_HAS_PROCESS(AudioEncoding);

AudioEncoding::AudioEncoding(sc_module_name nm) :
	sc_module(nm)
{
  SC_THREAD(audio_encoding_thread);
}

AudioEncoding::~AudioEncoding()
{

}

void AudioEncoding::audio_encoding_thread()
{
  short tmp_val_echo_cancel;
  unsigned char* tmp_result_buffer;
  int tmp_result_buffer_length;
  while(true)
  {
	tmp_val_echo_cancel = data_from_echocancellation.read();

	// Simlate delay in communication from EchoCancellation
	// 2 clocks at 20MHz = 2 * 50ns
	wait(100, SC_NS);
//	printf("AudioEncoding::audio_encoding_thread\r\n");

	// Audio Encoding algorithm

	tmp_result_buffer = performAudioEncoding(tmp_val_echo_cancel, &tmp_result_buffer_length);
	// Simulate the encoding
	// 500 clocks at 20MHz = 500 * 50ns
	wait(25, SC_US);

	if (tmp_result_buffer != 0)
	{
	  GSM0610DataFrame* tmp_result = new GSM0610DataFrame();
	  tmp_result->push_back_all(tmp_result_buffer, tmp_result_buffer_length);
	  data_to_communication.write(tmp_result);
	}
  }
}
