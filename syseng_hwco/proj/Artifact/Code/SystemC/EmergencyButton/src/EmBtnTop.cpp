/*
 * EmBtnTop.cpp
 *
 *  Created on: 17/02/2011
 *      Author: saa
 */

// Asynchronous input buffer with 4-128 samples of n bit width
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#include "EmBtnTop.h"

EmBtnTop::EmBtnTop(sc_module_name nm) :
  sc_module(nm),
  clkADC("clk_adc"),
  busyADC("busy_adc"),
  inDataADC("inDataADC"),
  readADC("read_adc"),
  readyADC("ready_adc"),
  outDataADC("OutDataADC"),
  //clkDec("clk_dec"),
  busyDec("busy_decoder"),
  inDataDec("inDataDecoder"),
  readDec("read_dac"),
  readyDec("ready_dac"),
  outDataDec("OutDataDecoder"),
#if (SC_API_VERSION_STRING == sc_api_version_2_2_0)
  clockDec("clockDecoder", sc_time(SAMPLE_PERIODE_DEC / 2, SC_NS)),
  clockADC("clockADC", sc_time(SAMPLE_PERIODE_ADC / 2, SC_NS))
#else
  clockDec("clockDecoder", SAMPLE_PERIODE_Dec/2, 0.5, 0.0, false),
  clockADC("clockADC", SAMPLE_PERIODE_ADC/2, 0.5, 0.0, false)

#endif

{
  // Create instances
  pADC = new ADCSource("ADC7276");
  pDAC = new DACSource("DAC7237");
  pADC_Buf = new CirBuffer("CircularBuf_ADC");
  pDAC_Buf = new CirBuffer("CircularBuf_DAC");
  pAudioEncoder = new AudioEncoder("AudioEncoder");
  pAudioDecoder = new AudioDecoder("AudioDecoder");
  // Connect ports to channels

  /***** ADC/DAC section **********/
  // ADC
  pADC->clk_in(clkADC);
  pADC->busy_out(busyADC);
  pADC->data_out(inDataADC);
  // DAC
  pDAC->read_out(readDec);
  pDAC->ready_in(readyDec);
  pDAC->data_in(outDataDec);


  /***** Buffer section **********/
  // ADC_Buffer input interface
  pADC_Buf->busy_in(busyADC);
  pADC_Buf->data_in(inDataADC);
  // ADC_Buffer output interface
  pADC_Buf->read_in(readADC);
  pADC_Buf->ready_out(readyADC);
  pADC_Buf->data_out(outDataADC);

  // DAC_Buffer input interface
  pDAC_Buf->busy_in(busyDec);
  pDAC_Buf->data_in(inDataDec);
  // DAC_Buffer output interface
  pDAC_Buf->read_in(readDec);
  pDAC_Buf->ready_out(readyDec);
  pDAC_Buf->data_out(outDataDec);

  /***** En/De-coder section **********/
  // pAudioEncoder input
  pAudioEncoder->read_out(readADC);
  pAudioEncoder->ready_in(readyADC);
  pAudioEncoder->data_in(outDataADC);
  // pAudioDecoder output
  pAudioDecoder->clk_in(clkDec);
  pAudioDecoder->busy_out(busyDec);
  pAudioDecoder->data_out(inDataDec);


  /*************************************/
  // Assign connection between clock and channel
  SC_METHOD( ClockADCSignal);
  sensitive << clockADC.signal();
  SC_METHOD( ClockDecSignal);
  sensitive << clockDec.signal();
  dont_initialize();

  /***** tacefile section **********/
  tracefile = sc_create_vcd_trace_file("ADCInputWave");
  if (!tracefile)
    cout << "Could not create trace file." << endl;

  sc_trace(tracefile, clkADC, "clk_adc");
  sc_trace(tracefile, busyADC, "busy_adc");
  sc_trace(tracefile, inDataADC, "inData_adc");
  sc_trace(tracefile, readADC, "read_adc");
  sc_trace(tracefile, readyADC, "ready_adc");
  sc_trace(tracefile, outDataADC, "outData_adc");
  sc_trace(tracefile, clkDec, "clk_dec");
  sc_trace(tracefile, busyDec, "busy_dec");
  sc_trace(tracefile, inDataDec, "inData_dec");
  sc_trace(tracefile, readDec, "read_dec");
  sc_trace(tracefile, readyDec, "ready_dec");
  sc_trace(tracefile, outDataDec, "outData_dec");
}

EmBtnTop::~EmBtnTop()
{
  sc_close_vcd_trace_file( tracefile);
  cout << "Created ADCInputWave.vcd" << endl;
}

void EmBtnTop::ClockADCSignal()
{
  sc_logic clock_tmp(clockADC.signal().read());
  clkADC.write(clock_tmp);
}

void EmBtnTop::ClockDecSignal()
{
  sc_logic clock_tmp(clockDec.signal().read());
  clkDec.write(clock_tmp);
}
