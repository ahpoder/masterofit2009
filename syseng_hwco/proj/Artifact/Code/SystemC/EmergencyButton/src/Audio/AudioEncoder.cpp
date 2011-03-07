/*
 * AudioEncoder.cpp
 *
 *  Created on: 17/02/2011
 *      Author: saa
 */

#include "AudioEncoder.h"
#include <iostream>
#include <iomanip>
using namespace std;


AudioEncoder::AudioEncoder(sc_module_name nm) :
  sc_module(nm),
  EncodingDone(false),
  len(0),
  idx(0)
{
  SC_THREAD( thrd_EncodeData);
  sensitive << data_ready_in.pos();
//  dont_initialize();

  SC_THREAD(thrd_SendEncodedData);
  sensitive << hs_Clk_in;// << e1;
//  dont_initialize();
}


void AudioEncoder::thrd_EncodeData(void)
{
  while(true)
  {
    wait();//wait for dataReady event
    packet[idx++] = data_in->read();

    if ( idx == MAX_SIZE)
    {//enough data to encode
      //Delay due to Encoding algorithm

      //wait(10, SC_US);
      wait(10, SC_NS);

      /*****debug start******/
#if (MY_DEBUG_1)
      for (sc_uint<2> i = 0 ; i <= 2; i++)
      {
        cout << "Encoder: packet[" << i * 11 << ".." << (i * 11) + 10 << "]: ";
        for(sc_uint<4> j = 0; j < 11; j++)
        {
          cout << setw(3) << packet[((len%MAX_SIZE)*MAX_SIZE)+(i*11) +j] << " ";
        }
        cout << endl;
      }
      /*****debug stop*******/
#endif
      wait(hs_Clk_in.negedge_event());
      wait(hs_Clk_in.posedge_event());
      EncodingDone = true;
      idx = 0;
    }
  }
}


void AudioEncoder::thrd_SendEncodedData(void)
{
  while (true)
  {
    wait();
    //ready_out.write(false);
    if(EncodingDone== true)
    {//Encoded packet ready to send
      if(hs_Clk_in.read() == true)
      {
        d = packet[len++];
//        if( (len - 1) == 0)
//        {
//          d = 255;
//        }
        data_out.write(d);//>> COM_BUS_WIDTH);

#if (MY_DEBUG_1)
        cout << "\n Encoder: len = "<< setw(3) << len - 1 << "    data: " << d << endl;
#endif
        wait(10, SC_NS);
        ready_out.write(true);
      }
      else
      {
        ready_out.write(false);
      }
      if (len == MAX_SIZE)
      {//No more data to send
        wait(40, SC_NS);// Must be less than ½ * f_hs_clk, but long enough to be read by ComSim
        ready_out.write(false);
        EncodingDone = false;
        len = 0;
      }
    }
  }
}



