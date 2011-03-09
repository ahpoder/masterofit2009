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
  int tmp_val_echo_cancel;
  int* tmp_result_buffer;
  int tmp_result_buffer_length;
  while(true)
  {
	tmp_val_echo_cancel = data_from_echocancellation.read();

	// Audio Encoding algorithm
	// Insert delay For audio encoding
	tmp_result_buffer = performAudioEncoding(tmp_val_echo_cancel, &tmp_result_buffer_length);

	if (tmp_result_buffer != 0)
	{
	  GSM0610DataFrame tmp_result;
	  tmp_result.push_back_all(tmp_result_buffer, tmp_result_buffer_length);
	  data_to_communication.write(tmp_result);
	}

	wait(); // wait for next value from echo cancellation
  }
}
