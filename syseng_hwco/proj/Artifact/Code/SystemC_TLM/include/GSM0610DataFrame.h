#ifndef GSM0610DATAFRAME_H
#define GSM0610DATAFRAME_H

class GSM0610DataFrame
{
public:
  GSM0610DataFrame();
  bool push_back(int value);
  int at(int index);
private:
  int idx;
  int buffer[128];
};

#endif
