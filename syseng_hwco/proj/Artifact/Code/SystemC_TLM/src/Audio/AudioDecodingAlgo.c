#include "AudioDecodingAlgo.h"

#define DATA_FRAME_SIZE 32

#include <string.h>

int performAudioDecoding(const unsigned char* encodedData, int encDataLength, short* resultBuffer, int resultBufferLengt)
{
  int i, j;
  short temp;

  if (resultBufferLengt < 5*encDataLength)
	  return -1;

  for (i = 0; i < encDataLength; i += 2)
  {
	  memcpy(&temp, encodedData + i, 2);
	  temp = ntohs(temp);
	  for (j = 0; j < 10; ++j)
	  {
		resultBuffer[j + 10 * (i/2)] = temp;
	  }
  }
  return encDataLength * 5;
}
