#include "AudioDecodingAlgo.h"

#define DATA_FRAME_SIZE 128

int performAudioDecoding(const int* encodedData, int encDataLength, int* resultBuffer, int resultBufferLengt)
{
  int i;

  if (resultBufferLengt < 10*encDataLength)
	  return -1;

  for (i = 0; i < encDataLength; ++i)
  {
	  resultBuffer[i * 10 + 0] = encodedData[i];
	  resultBuffer[i * 10 + 1] = encodedData[i];
	  resultBuffer[i * 10 + 2] = encodedData[i];
	  resultBuffer[i * 10 + 3] = encodedData[i];
	  resultBuffer[i * 10 + 4] = encodedData[i];
	  resultBuffer[i * 10 + 5] = encodedData[i];
	  resultBuffer[i * 10 + 6] = encodedData[i];
	  resultBuffer[i * 10 + 7] = encodedData[i];
	  resultBuffer[i * 10 + 8] = encodedData[i];
	  resultBuffer[i * 10 + 9] = encodedData[i];
  }
  return encDataLength * 10;
}
