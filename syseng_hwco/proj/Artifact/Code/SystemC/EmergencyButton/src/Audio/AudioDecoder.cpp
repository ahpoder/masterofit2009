/*
 * AudioDecoder.cpp
 *
 *  Created on: 19/02/2011
 *      Author: saa
 */
#include "AudioDecoder.h"

AudioDecoder::AudioDecoder(sc_module_name nm) :
  sc_module(nm), counter(0)
{
  SC_METHOD( SampleReady);
  sensitive << clk_in;
  dont_initialize();
}

void AudioDecoder::SampleReady(void)
{
  if (clk_in.read() == true)
  {
//    sc_uint<SAMPLE_BITS> d = rand()&0xfff;
    sc_uint < SAMPLE_BITS > d = counter;
    counter += 1;
    data_out->write(d);
    busy_out->write(SC_LOGIC_1);
  }
  else
    busy_out->write(SC_LOGIC_0);
}
