#ifndef FIRMWAREDATAFRAME_H
#define FIRMWAREDATAFRAME_H

#include <systemc.h>

class FirmwareDataFrame
{
public:
	FirmwareDataFrame();
  bool push_back(int value);
  bool push_back_all(int* buffer, int length);
  int at(int index);
  int length();
  const int* getBuffer();
  int capacity();

public:
  // Required by SystemC
  FirmwareDataFrame& operator=(const FirmwareDataFrame& rhs)
  {
	idx = rhs.idx;
	if (idx > 0)
	{
	  memcpy(buffer, rhs.buffer, idx);
	}
	return *this;
  }
  bool operator==(const FirmwareDataFrame& rhs) const
  {
	if (idx == rhs.idx)
	{
		if (idx <= 0)
			return true;
		return memcmp(buffer, rhs.buffer, idx) == 0;
	}
    return false;
  }
  friend std::ostream& operator<<(std::ostream& file, const FirmwareDataFrame& trans);
  friend void sc_trace(sc_trace_file*& tf, const FirmwareDataFrame& trans, std::string nm);
private:
  int idx;
  int buffer[128];
};

#endif
