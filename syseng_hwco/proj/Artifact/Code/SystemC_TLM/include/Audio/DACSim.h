#ifndef DACSIM_H
#define DACSIM_H

#include <systemc.h>

class DACSim : public sc_module
{
public:

  sc_fifo_in<int> data_to_speaker;
};

#endif
