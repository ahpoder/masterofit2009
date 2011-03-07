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
	wait(data_from_adc.data_written_event());

	// This is to ensure that both values are ready to be
	// read
	if (data_from_splitter.num_available() == 0)
		wait(data_from_splitter.data_written_event());

	tmp_val_adc = data_from_adc.read();
	tmp_val_splitter = data_from_splitter.read();

	// EchoCancellation algorithm
	// Insert delay in Echo cancellation
	tmp_val_result = performEchoCancellation(tmp_val_adc, tmp_val_splitter);

	// Output microphone data
	data_from_echocancellation.write(tmp_val_result);
  }
}
