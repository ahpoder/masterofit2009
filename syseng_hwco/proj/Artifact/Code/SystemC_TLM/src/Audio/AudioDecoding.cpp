#include <Audio/AudioDecoding.h>

extern "C"
{
#include "AudioDecodingAlgo.h"
}

SC_HAS_PROCESS(AudioDecoding);

AudioDecoding::AudioDecoding(sc_module_name nm) :
	sc_module(nm)
{
  SC_THREAD(audio_decoding_thread);
  SC_THREAD(audio_playback_thread);
}

AudioDecoding::~AudioDecoding()
{

}

void AudioDecoding::audio_decoding_thread()
{
  std::vector<int> ;
  int* tmp_result_buffer;
  int tmp_result_buffer_length;
  while(true)
  {
	wait(data_from_communication.data_written_event());

	tmp_val_echo_cancel = data_from_communication.read();

	// Audio Encoding algorithm
	// Insert delay For audio encoding
	tmp_result_buffer = performAudioEncoding(tmp_val_echo_cancel, &tmp_result_buffer_length);

	if (tmp_result_buffer != 0)
	{
	  std::vector<int> tmp_result(tmp_result_buffer_length);
	  for (int i = 0; i < tmp_result_buffer_length; ++i)
	  {
		  tmp_result.push_back(tmp_result_buffer[i]);
	  }
	  data_from_audioencoding.write(tmp_result);
	}

	wait(); // wait for next value from echo cancellation
  }
}

void AudioDecoding::audio_playback_thread()
{
  int tmp_val_echo_cancel;
  int* tmp_result_buffer;
  int tmp_result_buffer_length;
  while(true)
  {
	wait(AudioClk);

	if ()
	tmp_val_echo_cancel = data_from_communication.read();

	// Audio Encoding algorithm
	// Insert delay For audio encoding
	tmp_result_buffer = performAudioEncoding(tmp_val_echo_cancel, &tmp_result_buffer_length);

	if (tmp_result_buffer != 0)
	{
	  std::vector<int> tmp_result(tmp_result_buffer_length);
	  for (int i = 0; i < tmp_result_buffer_length; ++i)
	  {
		  tmp_result.push_back(tmp_result_buffer[i]);
	  }
	  data_from_audioencoding.write(tmp_result);
	}

	wait(); // wait for next value from echo cancellation
  }
}
