#include <GSM0610DataFrame.h>

#include <string.h>

GSM0610DataFrame::GSM0610DataFrame()
  : idx(0)
{
  memset(buffer, 0x00, sizeof(buffer));
}

bool GSM0610DataFrame::push_back(int value)
{
  if (idx == 128)
    return false;
  buffer[idx++] = value;
  return true;
}

int GSM0610DataFrame::at(int index)
{
  if (index < idx && index >= 0)
	return buffer[index];
  return -1;
}
