#ifndef SPLITTER_H
#define SPLITTER_H

#include <systemc.h>

class Splitter : public sc_module
{
public:
  sc_fifo_in<int> data_from_decoding;

  sc_fifo_out<int> data_to_dac;
  sc_fifo_out<int> data_to_echocancellation;

private:
  void splitter_thread();

public:
	SC_CTOR(Splitter);
	~Splitter();
};

#endif
