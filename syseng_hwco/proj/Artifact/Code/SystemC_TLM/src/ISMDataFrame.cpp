#include <ISMDataFrame.h>

#include <string.h>
#include <util.h>

ISMDataFrame::ISMDataFrame()
  : idx(0)
{
  type = FT_UNKNOWN;
  memset(buffer, 0x00, sizeof(buffer));
}

void ISMDataFrame::setFrameType(FrameType fType)
{
  type = fType;
}

void ISMDataFrame::setFrameContent(const unsigned char* data, int length)
{
  memcpy(buffer, data, length);
  idx = length;
}

FrameType ISMDataFrame::getFrameType()
{
  return type;
}
int ISMDataFrame::length()
{
	return idx;
}

const unsigned char* ISMDataFrame::getBuffer()
{
  return buffer;
}

int ISMDataFrame::capacity()
{
  return sizeof(buffer);
}

int ISMDataFrame::serialize(unsigned char* data, int length)
{
  short temp;
  data[0] = (char)type;
  data[1] = 0; // unused
  temp = htons(idx);
  memcpy(data + 2, &temp, 2);
  memcpy(data + 4, buffer, idx);
  return idx + 4;
}

int ISMDataFrame::deserialize(const unsigned char* data, int length)
{
  short temp;
  type = (FrameType)data[0];
  temp = *((short*)(data + 2));
  idx = ntohs(temp);
  memcpy(buffer, data + 4, idx);
  return idx + 4;
}

std::ostream& operator<<(std::ostream& os, const ISMDataFrame& trans)
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

void sc_trace(sc_trace_file*& tf, const ISMDataFrame& trans, std::string nm)
{
  // TODO not used
}
