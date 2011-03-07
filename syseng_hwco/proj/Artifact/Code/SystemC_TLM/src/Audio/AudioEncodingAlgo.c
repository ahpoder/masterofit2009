#include "EchoCancellationAlgo.h"

#define DATA_FRAME_SIZE 128

static int dataCount = 0;
static int bufferCount = 0;
static int encodingBuffer[DATA_FRAME_SIZE];

int* performAudioEncoding(int value, int* length)
{
  if (dataCount % 10)
  {
	encodingBuffer[bufferCount++] = value;
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
