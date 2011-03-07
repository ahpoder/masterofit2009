/*
 * AudioDecoder.cpp
 *
 *  Created on: 19/02/2011
 *      Author: saa
 */
#include "AudioDecoder.h"
#include "defines.h"
#include <string.h>

#include <iostream>
#include <iomanip>
using namespace std;


AudioDecoder::AudioDecoder(sc_module_name nm) :
  sc_module(nm),
  idx(0),
  len(0),
  templen(0)

{
  SC_THREAD(thrd_GetData);
  sensitive << data_ready_in.pos();
  //dont_initialize();

  SC_THREAD( thrd_DecodeData);
  sensitive << AudioClk_in.pos();// << e1;
  //dont_initialize();
}

void AudioDecoder::thrd_GetData(void)
{
  while(true)
  {
    wait();
    //read data packet
    packet_in[templen++] = data_in.read();
#if (MY_DEBUG_1)
      cout << "\n Decoder get: Temp len = " << setw(3) << templen-1
           << "   data: " << setw(3) << packet_in[templen-1] << endl  ;
#endif
    if(templen == MAX_SIZE)
    {
#if (MY_DEBUG_1)
      cout << "\n Decoder copy: Temp len = " << setw(3) << templen << "  her kopierer vi bufferen. \n" ;
#endif
      //Lock mutex
      bufferAccess.lock();
#if (MY_DEBUG_1)
      cout << "bufferAccess lock: " << (packet_in[templen-1] + 1)/MAX_SIZE << endl;
      cout << packet_in[templen-1] + 1 <<endl;
#endif
      //memcpy(buffer_out, packet_in, templen);  Duer ikke i SystemC (3 timer)Ævvvvvvvv
      for(sc_uint<6> i = 0; i < MAX_SIZE; i++)
      {
        buffer_out[i] = packet_in[i];
      }

#if (MY_DEBUG)
      cout << "DEC_OUTPUT_BUFFER: [";
      for(sc_uint<6> i = 0; i < MAX_SIZE; i++)
      {
        cout << buffer_out[i] << ", ";
      }
      cout << endl;
#endif
      len = templen;
      templen = 0;
      //unlock mutex
      bufferAccess.unlock();
    }
  }
}

void AudioDecoder::thrd_DecodeData(void)
{
  while(true)
  {
    wait();
    //cout << endl << "Decoder: len = " << len << endl;
    if (len != 0)
    {
      len--;
      //Lock mutex
      bufferAccess.lock();
      data_out->write(buffer_out[idx++]);
    }
    else
    {//buffer empty
      //unlock mutex
      bufferAccess.unlock();
      idx = 0;
      data_out->write(0);
    }
  }
}
