#include <Audio/AudioDecoding.h>

extern "C"
{
#include "AudioDecodingAlgo.h"
}

SC_HAS_PROCESS(AudioDecoding);

AudioDecoding::AudioDecoding(sc_module_name nm) :
	sc_module(nm), receiveBuffer(10),
	audioBufferOffset(0), activeAudioBuffer(0)
{
	playbackBufferLength[0] = playbackBufferLength[1] = -1;

  SC_THREAD(audio_receiving_thread);
  SC_THREAD(audio_decoding_thread);
  SC_THREAD(audio_playback_thread);
}

AudioDecoding::~AudioDecoding()
{

}

void AudioDecoding::audio_receiving_thread()
{
  GSM0610DataFrame tmp_data_frame;
  while(true)
  {
	tmp_data_frame = data_from_communication.read();
	receiveBufferLock.lock();
	receiveBuffer.push_back(tmp_data_frame);
	receiveBufferLock.unlock();
	buffersChanged.notify(SC_ZERO_TIME);
  }
}

void AudioDecoding::audio_decoding_thread()
{
  GSM0610DataFrame tmp_data_frame;
  int i;
  int bufferToUse;
  while(true)
  {
	wait(buffersChanged);
	if (!receiveBuffer.empty())
	{
		bufferToUse = -1;
		// Always look at the active buffer first, in case it is empty
		if (playbackBufferLength[activeAudioBuffer] == -1)
		{
			bufferToUse = activeAudioBuffer;
		}
		else if (playbackBufferLength[activeAudioBuffer == 0 ? 1 : 0] == -1)
		{
			bufferToUse = activeAudioBuffer == 0 ? 1 : 0;
		}

		if (bufferToUse != -1)
		{
			receiveBufferLock.lock();
			tmp_data_frame = receiveBuffer.front();
			receiveBuffer.pop_front();
			receiveBufferLock.unlock();

			playbackBufferLock.lock();

			// TODO add wait
			playbackBufferLength[i] = performAudioDecoding(tmp_data_frame.getBuffer(), tmp_data_frame.length(), playbackBuffer[i], sizeof(playbackBuffer[i]));

			playbackBufferLock.unlock();
		}
	}
  }
}

void AudioDecoding::audio_playback_thread()
{
  int tmp_val_splitter = 0;
  while(true)
  {
	wait(AudioClk);

	if (playbackBufferLength[activeAudioBuffer] > 0)
	{
		tmp_val_splitter = playbackBuffer[activeAudioBuffer][audioBufferOffset];
	}
	data_to_splitter.write(tmp_val_splitter);

	if (++audioBufferOffset == playbackBufferLength[activeAudioBuffer])
	{
		playbackBufferLock.lock();
		audioBufferOffset = 0;
		playbackBufferLength[activeAudioBuffer] = -1;
		activeAudioBuffer = activeAudioBuffer == 0 ? 1 : 0;
		playbackBufferLock.unlock();
		buffersChanged.notify(SC_ZERO_TIME);
	}
  }
}
