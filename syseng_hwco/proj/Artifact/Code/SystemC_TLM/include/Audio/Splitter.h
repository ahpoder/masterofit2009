#ifndef ECHOCANCELLATION_H
#define ECHOCANCELLATION_H
//----------------------------------------------------------------------------------------------
// top.h (systemc)
//
//	Author: KBE / 2010.09.12
//----------------------------------------------------------------------------------------------
#include <systemc.h>

class EchoCancellation : public sc_module
{
public:
  sc_fifo_in<int> data_from_adc;
  sc_fifo_in<int> data_from_splitter;

  sc_fifo_out<int> data_from_echocancellation;

private:
  void echo_cancellation_thread();

public:
	SC_CTOR(EchoCancellation);
	~EchoCancellation();
};

#endif
