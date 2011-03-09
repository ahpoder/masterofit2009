#ifndef ISMTOP_H
#define ISMTOP_H

#include <systemc.h>

#include <ISMDataFrame.h>

class CommunicationTop;

class ISMSim;

class ISMTop : public sc_module
{
public:
  void connect(CommunicationTop* comm);
  void setClock(sc_clock* clk);

private:
  ISMSim* ismSim;

  sc_fifo<ISMDataFrame> ismToCommunicationFifo;

public:
	SC_CTOR(ISMTop);
	~ISMTop();
};

#endif
