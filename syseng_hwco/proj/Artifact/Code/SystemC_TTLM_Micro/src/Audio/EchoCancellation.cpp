#include <Audio/EchoCancellation.h>

extern "C"
{
#include "EchoCancellationAlgo.h"
}

SC_HAS_PROCESS(EchoCancellation);

EchoCancellation::EchoCancellation(sc_module_name nm) :
	sc_module(nm)
{
  SC_THREAD(echo_cancellation_thread);
}

EchoCancellation::~EchoCancellation()
{

}

void EchoCancellation::echo_cancellation_thread()
{
  int tmp_val_adc;
  int tmp_val_splitter;
  int tmp_val_result;
  while(true)
  {
	tmp_val_adc = data_from_adc.read();
	tmp_val_splitter = data_from_splitter.read();

	// Simulate the communication delay
	// 2 clock at 20MHz = 2 * 50ns
	wait(100, SC_NS);

//	printf("EchoCancellation::echo_cancellation_thread\r\n");

	// EchoCancellation algorithm
	// Insert delay in Echo cancellation
	tmp_val_result = performEchoCancellation(tmp_val_adc, tmp_val_splitter);
	// Simulate time to perform the Echo cancellation
	// 15 clocks at 20MHz =15 * 50ns
	wait(750, SC_NS);

	// Output microphone data
	data_to_audio_encoding.write(tmp_val_result);
  }
}
