#include <stdio.h>
#include <string.h>
#include <system.h>

static void showInfo()
{
  printf("HW control interface\n");
  printf("------------------------------\n");
  printf("Protocol: [type] [target] [value] (ex. \"set led 128 \" | \"get sw \")\n");
  printf("Types: get | set | exit\n");
  printf("Targets: lcd1 | lcd2 | sw | led | ticks\n");
  printf("Value: 0-255 (led) | 0-65535 (ticks) | Text (lcd)\n");
  printf("CMD:/> ");
}

static void handleSWCommand()
{
  unsigned long int switches;
  // We have only set up an 8bit port!!!
  volatile unsigned char* pioBase = (unsigned char*)PIO_INPUT_BASE;

  switches = (unsigned long int)*pioBase;
  printf("Switches: 0x%lX\n", switches);
  printf("CMD:/> ");
}

static FILE* lcdHW = 0;
static void handleLCDCommand(int lcdLine, const char* text)
{
  if (lcdHW != 0)
  {
	  fseek(lcdHW, 0, SEEK_SET); // Always start at the beginning of the line
	  switch (lcdLine)
	  {
	  case 1:
		  fwrite("\x1B[1;1H", 1, 6, lcdHW);
		  fwrite("\x1B[K", 1, 3, lcdHW);
		  fwrite(text, 1, strlen(text), lcdHW);
		  break;
	  case 2:
		  fwrite("\x1B[2;1H", 1, 6, lcdHW);
		  fwrite("\x1B[K", 1, 3, lcdHW);
		  fwrite(text, 1, strlen(text), lcdHW);
		  break;

	  }
  }
}

static void handleLEDCommand(unsigned char led)
{
  volatile unsigned char* pioBase = (unsigned char*)PIO_OUTPUT1_BASE;
  *pioBase = led;
  printf("CMD:/> ");
}

typedef enum
{
  CT_GET,
  CT_SET,
  CT_EXIT,
  CT_UNKNOWN
} CommandType;

static CommandType getCommandType(const char* type)
{
  if (strcmp(type, "get") == 0)
  {
	return CT_GET;
  }
  else if (strcmp(type, "set") == 0)
  {
	return CT_SET;
  }
  else if (strcmp(type, "exit") == 0)
  {
	return CT_EXIT;
  }
  return CT_UNKNOWN;
}

typedef enum
{
  TT_SW,
  TT_LCD1,
  TT_LCD2,
  TT_LED,
  TT_UNKNOWN
} CommandTarget;

static CommandTarget getCommandTarget(const char* target)
{
  if (strcmp(target, "led") == 0)
  {
	return TT_LED;
  }
  else if (strcmp(target, "lcd1") == 0)
  {
	return TT_LCD1;
  }
  else if (strcmp(target, "lcd2") == 0)
  {
	return TT_LCD2;
  }
  else if (strcmp(target, "sw") == 0)
  {
	return TT_SW;
  }
  return TT_UNKNOWN;
}

static void handleCmdLine(const char* cmdLine)
{
  char type[64]; // Only this long for safety reasons
  char target[64]; // Only this long for safety reasons
  int integer;
  // VERY VERY unsafe if the buffer is not sure to be big enough
  sscanf(cmdLine, "%s%s", type, target);

	switch (getCommandType(type))
	{
	case CT_GET:
		switch (getCommandTarget(target))
		{
		case TT_SW:
			handleSWCommand();
			break;
		default: // All others
			printf("Invalid get target recieved: %s\n", target);
			// TODO: Empty stdin buffer
			showInfo();
			break;
		}
		break;
	case CT_SET:
		switch (getCommandTarget(target))
		{
		case TT_LCD1:
			handleLCDCommand(1, cmdLine + 3 + 1 + 4 + 1); // these integers should not be here.
			break;
		case TT_LCD2:
			handleLCDCommand(2, cmdLine + 3 + 1 + 4 + 1);
			break;
		case TT_LED:
			sscanf(cmdLine + 3 + 1 + 3 + 1, "%d", &integer);
			if (integer < 0 || integer > 255)
			{
				printf("Invalid cmd set led recieved, out of range: %d\n", integer);
				// TODO: Empty stdin buffer
				showInfo();
			}
			handleLEDCommand(integer);
			break;
		default: // All others
			printf("Invalid get target recieved: %s\n", target);
			// TODO: Empty stdin buffer
			showInfo();
			break;
		}
		break;
	case CT_EXIT: // Simply ignore
		break;
	case CT_UNKNOWN:
		printf("Invalid cmd recieved: %s\n", type);
		// TODO: Empty stdin buffer
		showInfo();
		break;
	}
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

  // Open LCD driver
  lcdHW = fopen(LCD_NAME, "w");
  if (lcdHW == 0)
  {
	  printf("Failure initializing LCD, lcd commands will not work");
  }

  showInfo();

  do
  {
	cmdLine[0] = '\0'; // Ensure that it is cleared
	readCmdLine(cmdLine, sizeof(cmdLine));
	handleCmdLine(cmdLine);
  }
  while (strcmp(cmdLine, "exit") != 0);
  if (lcdHW != 0)
  {
	  fclose(lcdHW);
  }
  return 0;
}
