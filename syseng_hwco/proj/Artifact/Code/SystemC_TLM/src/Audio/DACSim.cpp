#include <Audio/DACSim.h>

#include <Audio/defs.h>

SC_HAS_PROCESS(DACSim);

DACSim::DACSim(sc_module_name nm) :
	sc_module(nm)
{
  SC_THREAD(dac_writer_thread);

  fp_speaker = fopen(OUTPUT_FILE_SPEAKER, "w");
}

DACSim::~DACSim()
{
  fclose(fp_speaker);
}

void DACSim::dac_writer_thread()
{
  short tmp_val_speaker;
  while(true)
  {
	tmp_val_speaker = data_from_splitter.read();

//	printf("DACSim::dac_writer_thread\r\n");

    fprintf(fp_speaker, "%d\r\n", tmp_val_speaker);

	data_to_adcsim.write(tmp_val_speaker);
  }
}
