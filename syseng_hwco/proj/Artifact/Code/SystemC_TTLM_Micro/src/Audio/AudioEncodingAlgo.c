#include "AudioEncodingAlgo.h"

#include <util.h>

#include <string.h>

#define DATA_FRAME_SIZE 32

static int dataCount = 0;
static int bufferCount = 0;
static unsigned char encodingBuffer[DATA_FRAME_SIZE];

unsigned char* performAudioEncoding(short value, int* length)
{
  short temp;
  if (dataCount % 10 == 0)
  {
	temp = htons(value);
	memcpy(encodingBuffer + bufferCount, &temp, 2);
	bufferCount += 2;
  }
  ++dataCount;
  if (bufferCount == DATA_FRAME_SIZE)
  {
	  dataCount = 0;
	  bufferCount = 0;
	  *length = DATA_FRAME_SIZE;
	  return encodingBuffer;
  }
  return 0;
}
