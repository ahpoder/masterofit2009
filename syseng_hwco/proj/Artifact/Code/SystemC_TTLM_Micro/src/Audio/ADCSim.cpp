#include <Audio/ADCSim.h>
#include <Audio/defs.h>

SC_HAS_PROCESS(ADCSim);

ADCSim::ADCSim(sc_module_name nm) :
	sc_module(nm)
{
  SC_THREAD(adc_reader_thread);
  sensitive << AudioClk;
  dont_initialize();

  fp_microphone = fopen(INPUT_FILE_MICROPHONE, "r");
}

ADCSim::~ADCSim()
{
  fclose(fp_microphone);
}

void ADCSim::adc_reader_thread()
{
  short tmp_val_microphone;
  short tmp_val_speaker;
  while(true)
  {
    wait(); // wait for next Audio clock
//    wait(125, SC_US); // wait for next Audio clock

//    printf("ADCSim::adc_reader_thread\r\n");

	if (fscanf(fp_microphone, "%hd", &tmp_val_microphone) == EOF)
	{
		printf("No more audio input\r\n");
		sc_stop();
		break;
	}

	// This is to ensure that the speaker is allowed to
	// write first. There can never be more than 1 value
	// in the fifo, so a fifo is total overkill.
	tmp_val_speaker = 0;
	if (data_from_speakers.num_available() > 0)
	{
		// It is possible it can be 0 for
		// the first 5 samples, due to the
		// Acoustic echo delay
		tmp_val_speaker = data_from_speakers.read();
	}

	// Simulate the ADC sampling
	// 1 clock at 20MHz = 1 * 50ns
	wait(50, SC_NS);

	// Output microphone data
	data_to_echo_cancellation.write(tmp_val_microphone + tmp_val_speaker);
  }
}
