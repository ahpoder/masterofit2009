#include <Audio/Splitter.h>

SC_HAS_PROCESS(Splitter);

Splitter::Splitter(sc_module_name nm) :
	sc_module(nm)
{
  SC_THREAD(splitter_thread);
}

Splitter::~Splitter()
{

}

void Splitter::splitter_thread()
{
  int tmp_val_audio_decoder;
  while(true)
  {
	tmp_val_audio_decoder = data_from_decoding.read();

	// Simulate communication delay: 2 * 50ns
	wait(100, SC_NS);

//	printf("Splitter::splitter_thread\r\n");

	// Simulate the "splitting"
	wait(50, SC_NS);

	data_to_dac.write(tmp_val_audio_decoder);
	data_to_echocancellation.write(tmp_val_audio_decoder);
  }
}
