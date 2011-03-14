#include <GSM0610DataFrame.h>

#include <string.h>

#define DATA_FRAME_SIZE 32

GSM0610DataFrame::GSM0610DataFrame()
  : idx(0)
{
  memset(buffer, 0x00, sizeof(buffer));
}

bool GSM0610DataFrame::push_back(unsigned char value)
{
  if (idx == DATA_FRAME_SIZE)
    return false;
  buffer[idx++] = value;
  return true;
}

bool GSM0610DataFrame::push_back_all(const unsigned char* cpBuffer, int length)
{
  int cpLength = length;
  if ((cpLength + idx) > DATA_FRAME_SIZE)
	cpLength = DATA_FRAME_SIZE - idx;
  memcpy(buffer, cpBuffer, length);
  idx += length;
  return cpLength == length;
}

unsigned char GSM0610DataFrame::at(int index)
{
  if (index < idx && index >= 0)
	return buffer[index];
  return -1;
}

int GSM0610DataFrame::length()
{
	return idx;
}

const unsigned char* GSM0610DataFrame::getBuffer()
{
  return buffer;
}

int GSM0610DataFrame::capacity()
{
	return DATA_FRAME_SIZE;
}

std::ostream& operator<<(std::ostream& os, const GSM0610DataFrame& trans)
{
  int i;
  os << "{" << std::endl << "  "
	 << "idx: " << trans.idx <<", ";
  if (trans.idx > 0)
  {
	  for (i = 0; i < i; ++i)
	  {
		os << "buffer[" << i << "]: " << trans.buffer[i];
	  }
  }
  return os;
}

void sc_trace(sc_trace_file*& tf, const GSM0610DataFrame& trans, std::string nm)
{
  // TODO not used
}
