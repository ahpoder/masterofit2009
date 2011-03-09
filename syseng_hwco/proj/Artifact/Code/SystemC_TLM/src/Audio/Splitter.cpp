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

	data_to_dac.write(tmp_val_audio_decoder);
	data_to_echocancellation.write(tmp_val_audio_decoder);
  }
}
