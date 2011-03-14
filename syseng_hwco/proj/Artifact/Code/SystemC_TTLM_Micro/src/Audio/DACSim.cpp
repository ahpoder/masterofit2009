#include <Audio/DACSim.h>

#include <Audio/defs.h>

SC_HAS_PROCESS(DACSim);

DACSim::DACSim(sc_module_name nm) :
	sc_module(nm)
{
  SC_THREAD(dac_writer_thread);
  SC_THREAD(dac_feedback_thread);

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

	// Simulate the communication: 2 * 50ns
	wait(100, SC_NS);
//	printf("DACSim::dac_writer_thread\r\n");

	// Simulate the DAC delay: 10 * 50ns
    wait(500, SC_NS);

    fprintf(fp_speaker, "%hd\r\n", tmp_val_speaker);

	bufferForEcho.write(tmp_val_speaker);
	firstSampleArrived.notify(SC_ZERO_TIME);
  }
}

void DACSim::dac_feedback_thread()
{
  wait(firstSampleArrived);
  wait(587, SC_US);
  while(true)
  {
	data_to_adcsim.write(bufferForEcho.read());
	wait(125, SC_US); // wait for next sample (8kHz = 125us)
  }
}
