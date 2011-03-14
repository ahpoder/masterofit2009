#include <ISM/ISMTop.h>

#include <Communication/CommunicationTop.h>

#include <Communication/DataParser.h>

#include <ISM/ISMSim.h>

ISMTop::ISMTop(sc_module_name nm) :
	sc_module(nm),
	ismToCommunicationFifo("ISMToCommunicationFifo")
{
  ismSim = new ISMSim("ISMSim");

  ismSim->data_to_communication(ismToCommunicationFifo);
}

ISMTop::~ISMTop()
{
  delete ismSim;
}

void ISMTop::connect(CommunicationTop* comm)
{
  ismSim->data_from_communication(comm->communicationToISMFifo);

  comm->dataParser->data_from_ism(ismToCommunicationFifo);
}

void ISMTop::setClock(sc_clock* clk)
{
  ismSim->AudioClk(clk->signal());
}
