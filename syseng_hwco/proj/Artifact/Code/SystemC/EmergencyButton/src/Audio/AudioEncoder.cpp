/*
 * AudioEncoder.cpp
 *
 *  Created on: 17/02/2011
 *      Author: saa
 */

#include "AudioEncoder.h"
#include "EmBtnTop.h"

#define PER_DIV 1  // How fast to simulate reading buffer based on sample periode
AudioEncoder::AudioEncoder(sc_module_name nm) :
  sc_module(nm)
{
  SC_THREAD( Simulate);
  sensitive << ready_in;
  dont_initialize();
}

void AudioEncoder::Simulate(void)
{
  while (1)
  {
    wait(SAMPLE_PERIODE_ADC, SC_NS);

    // Poll for data in buffer
    while (ready_in->read() == true)
    {
      // Read all data in buffer
      read_out->write(true);
      wait(1, SC_NS);// Wait for data to be ready
      cout << "Data : " << data_in->read() << ", ";
      wait(20, SC_NS);
      read_out->write(false);
      wait(20, SC_NS);
    }

    // Newline if buffer is empty
    cout << " ... \n";
  }

}
