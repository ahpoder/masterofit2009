#include <stdio.h>
#include <string.h>
#include <stdlib.h> // usleep
#include "system.h"
#include <io.h> // IOWR

static void showInfo()
{
  printf("Sweep generator\n");
  printf("------------------------------\n");
  printf("sweep <delay> <Attenuation>\n");
  printf("delay (0-65535), Attenuation (0-15)\n");
  printf("CMD:/> ");
}

static void handleCmdLine(const char* cmdLine)
{
  int delay;
  int attenuation;
  int i = 0;

  sscanf(cmdLine, "sweep %d %d", &delay, &attenuation);

  if (delay > 65535 || delay < 0)
  {
	printf("Delay out of range\n");
	showInfo();
	return;
  }

  if (attenuation > 15 || attenuation < 0)
  {
	printf("Attenuation out of range\n");
	showInfo();
	return;
  }

  IOWR(CODECINTERFACE_0_BASE,0x0000,0x0001); // INITIALIZE
  usleep(100);
  IOWR(CODECINTERFACE_0_BASE,0x0000,0x0000); // RESET

  IOWR(WAVEFORMGENERATOR_0_BASE, 0x00000000, attenuation); // Write attenuation (not really necessary, see below)

  printf("Beginning sweep\n");
  while (i <= 255)
  {
	IOWR(WAVEFORMGENERATOR_0_BASE, 0x00000000, (i << 8) | attenuation); // Write frequency (and attenuation. Must be included every time as we write 32bit)

	usleep(delay);
	++i;
  }

  IOWR(WAVEFORMGENERATOR_0_BASE, 0x00000000, 0x0001); // Write frequency (and attenuation. Must be included every time as we write 32bit)
   printf("Sweep done");
}

void readCmdLine(char* cmdLine, int length)
{
	int readBytes = 0;
	do
	{
		fread(cmdLine + readBytes, 1, 1, stdin);
		++readBytes;
	}
	while (cmdLine[readBytes - 1] != '\n' && readBytes < length - 1);
	cmdLine[readBytes - 1] = '\0'; // remove newline - had it been \r\n this would have to have been different
}

int main()
{
  char cmdLine[64] = { '\0' };

  showInfo();

  do
  {
	cmdLine[0] = '\0'; // Ensure that it is cleared
	readCmdLine(cmdLine, sizeof(cmdLine));
	handleCmdLine(cmdLine);
  }
  while (strcmp(cmdLine, "exit") != 0);
  return 0;
}
