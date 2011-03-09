#include <Audio/AudioTop.h>
#include <Communication/CommunicationTop.h>
#include <ISM/ISMTop.h>

#include <systemc.h>

int sc_main( int argc, char **argv)
{
	// Initialize the blocks
	AudioTop audioTop("Audio");
	CommunicationTop communicationTop("Communication");
	ISMTop ismTop("ISM");

	// connect the blocks (internal connections are done by the respective block initializers
	ismTop.connect(&communicationTop);
	communicationTop.connect(&audioTop);

	// Setup the remaining clock
	ismTop.setClock(&audioTop.AudioClock);

	sc_start( 100, SC_SEC );

	return 0;
}
