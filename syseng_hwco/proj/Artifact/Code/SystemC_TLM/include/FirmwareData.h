#ifndef GSM0610DATAFRAME_H
#define GSM0610DATAFRAME_H

#include <systemc.h>

class GSM0610DataFrame
{
public:
  GSM0610DataFrame();
  bool push_back(int value);
  bool push_back_all(int* buffer, int length);
  int at(int index);
  int length();
  const int* getBuffer();
  int capacity();

public:
  // Required by SystemC
  GSM0610DataFrame& operator=(const GSM0610DataFrame& rhs)
  {
	idx = rhs.idx;
	if (idx > 0)
	{
	  memcpy(buffer, rhs.buffer, idx);
	}
	return *this;
  }
  bool operator==(const GSM0610DataFrame& rhs) const
  {
	if (idx == rhs.idx)
	{
		if (idx <= 0)
			return true;
		return memcmp(buffer, rhs.buffer, idx) == 0;
	}
    return false;
  }
  friend std::ostream& operator<<(std::ostream& file, const GSM0610DataFrame& trans);
  friend void sc_trace(sc_trace_file*& tf, const GSM0610DataFrame& trans, std::string nm);
private:
  int idx;
  int buffer[128];
};

#endif
