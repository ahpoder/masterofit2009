#include <Audio/ADCSim.h>
#include <Audio/defs.h>

SC_HAS_PROCESS(ADCSim);

ADCSim::ADCSim(sc_module_name nm) :
	sc_module(nm)
{
  SC_THREAD(adc_reader_thread);
  sensitive << AudioClk;

  fp_microphone = fopen(INPUT_FILE_MICROPHONE, "r");
}

ADCSim::~ADCSim()
{
  fclose(fp_microphone);
}

void ADCSim::adc_reader_thread()
{
  int tmp_val_microphone;
  int tmp_val_speaker;
  while(true)
  {
	if (fscanf(fp_microphone, "%d", &tmp_val_microphone) == EOF)
	{
		sc_stop();
		break;
	};

	// This is to ensure that the speaker is allowed to
	// write first. There can never be more than 1 value
	// in the fifo, so a fifo is total overkill.
	if (data_from_speakers.num_available() == 0)
		wait(data_from_speakers.data_written_event());

	tmp_val_speaker = data_from_speakers.read();

	// Output microphone data
	data_from_adc.write(tmp_val_microphone + tmp_val_speaker);

	wait(); // wait for next Audio clock
  }
}
