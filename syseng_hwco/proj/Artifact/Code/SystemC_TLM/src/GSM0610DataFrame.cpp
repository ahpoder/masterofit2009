#include <GSM0610DataFrame.h>

#include <string.h>

GSM0610DataFrame::GSM0610DataFrame()
  : idx(0)
{
  memset(buffer, 0x00, sizeof(buffer));
}

bool GSM0610DataFrame::push_back(int value)
{
  if (idx == 128)
    return false;
  buffer[idx++] = value;
  return true;
}

bool GSM0610DataFrame::push_back_all(int* cpBuffer, int length)
{
  int cpLength = length;
  if ((cpLength + idx) > 128)
	cpLength = 128 - idx;
  memcpy(buffer, cpBuffer, length);
  idx += length;
  return cpLength == length;
}

int GSM0610DataFrame::at(int index)
{
  if (index < idx && index >= 0)
	return buffer[index];
  return -1;
}

int GSM0610DataFrame::length()
{
	return idx;
}

const int* GSM0610DataFrame::getBuffer()
{
  return buffer;
}

int GSM0610DataFrame::capacity()
{
	return 128;
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
