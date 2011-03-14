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
  sensitive << AudioClk;
  dont_initialize();
}

AudioDecoding::~AudioDecoding()
{

}

void AudioDecoding::audio_receiving_thread()
{
  while(true)
  {
	GSM0610DataFrame* tmp_data_frame = data_from_communication.read();

	receiveBufferLock.lock();

	printf("AudioDecoding::audio_receiving_thread: %d\r\n", receiveBuffer.capacity() - receiveBuffer.size());
	if (receiveBuffer.capacity() - receiveBuffer.size() == 0)
	{
		printf("Audio receive buffer Overflow\r\n");
		sc_stop();
		break;
	}

	receiveBuffer.push_back(tmp_data_frame);
	receiveBufferLock.unlock();
	buffersChanged.notify(SC_ZERO_TIME);
  }
}

void AudioDecoding::audio_decoding_thread()
{
  GSM0610DataFrame tmp_data_frame;
  int bufferToUse;
  while(true)
  {
	wait(buffersChanged);

//	printf("AudioDecoding::audio_decoding_thread: %d\r\n", receiveBuffer.capacity() - receiveBuffer.size());

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
			std::auto_ptr<GSM0610DataFrame> ptr(receiveBuffer.front());
			receiveBuffer.pop_front();
			printf("AudioDecoding::audio_decoding_thread: %d\r\n", receiveBuffer.capacity() - receiveBuffer.size());
			receiveBufferLock.unlock();

			playbackBufferLock.lock();

			// TODO add wait
			playbackBufferLength[bufferToUse] = performAudioDecoding(ptr->getBuffer(), ptr->length(), playbackBuffer[bufferToUse], sizeof(playbackBuffer[bufferToUse]));

			playbackBufferLock.unlock();
        }
    }
	else
	{
		printf("No data to decode\r\n");
		return;
	}
  }
}

void AudioDecoding::audio_playback_thread()
{
  short tmp_val_splitter;
  while(true)
  {
	//	wait(AudioClk.posedge_event());
	wait();
	// wait(125, SC_US);

//	printf("AudioDecoding::audio_playback_thread\r\n");

	tmp_val_splitter = 0;
	if (playbackBufferLength[activeAudioBuffer] > 0)
	{
		tmp_val_splitter = playbackBuffer[activeAudioBuffer][audioBufferOffset];
		if (++audioBufferOffset == playbackBufferLength[activeAudioBuffer])
		{
			playbackBufferLock.lock();
			audioBufferOffset = 0;
			playbackBufferLength[activeAudioBuffer] = -1;
			activeAudioBuffer = activeAudioBuffer == 0 ? 1 : 0;
			printf("Switching buffer to: %d\r\n", activeAudioBuffer);
			playbackBufferLock.unlock();
			buffersChanged.notify(SC_ZERO_TIME);
		}
	}
	else
	{
		printf("Playback buffer Underflow\r\n");
		sc_stop();
		break;
	}
	data_to_splitter.write(tmp_val_splitter);
  }
}
