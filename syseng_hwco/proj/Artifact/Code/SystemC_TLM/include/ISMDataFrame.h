#ifndef ISMDATAFRAME_H
#define ISMDATAFRAME_H

#include <systemc.h>

typedef enum
{
  FT_CONTROL = 'c',
  FT_AUDIO = 'a',
  FT_FIRMWARE = 'f',
  FT_UNKNOWN = 'u'
} FrameType;

class ISMDataFrame
{
public:
  ISMDataFrame();
  void setFrameType(FrameType fType);
  void setFrameContent(const unsigned char* data, int length);
  FrameType getFrameType();
  int length();
  const unsigned char* getBuffer();
  int capacity();

  int serialize(unsigned char* data, int length);
  int deserialize(const unsigned char* data, int length);

public:
  // Required by SystemC
  ISMDataFrame& operator=(const ISMDataFrame& rhs)
  {
	idx = rhs.idx;
	if (idx > 0)
	{
	  memcpy(buffer, rhs.buffer, idx);
	}
	return *this;
  }
  bool operator==(const ISMDataFrame& rhs) const
  {
	if (idx == rhs.idx)
	{
		if (idx <= 0)
			return true;
		return memcmp(buffer, rhs.buffer, idx) == 0;
	}
    return false;
  }
  friend std::ostream& operator<<(std::ostream& file, const ISMDataFrame& trans);
  friend void sc_trace(sc_trace_file*& tf, const ISMDataFrame& trans, std::string nm);
private:
  FrameType type;
  short idx;
  unsigned char buffer[1500];
};

#endif
