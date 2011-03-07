#include <Audio/AudioTop.h>

int sc_main( int argc, char **argv)
{
	AudioTop audioTop("Audio");

	sc_start( 2000, SC_US );

	return 0;
}
