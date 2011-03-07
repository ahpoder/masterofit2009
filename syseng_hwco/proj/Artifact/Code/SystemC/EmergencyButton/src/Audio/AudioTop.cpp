/*
 * AudioTop.cpp
 *
 *  Created on: 17/02/2011
 *      Author: saa
 */

// Asynchronous input buffer with 4-128 samples of n bit width
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#include "AudioTop.h"

AudioTop::AudioTop(sc_module_name nm) :
  sc_module(nm),
  AudioClock("AudioClock", sc_time(SAMPLE_PERIODE_ADC, SC_NS)),
  HS_Clock("HS_Clock", sc_time(HS_CLK_PERIODE, SC_NS)),
  AudioClk("AudioClk"),
  hsClk("hsClk"),
  ADC_busy("ADC_busy"),
  COMSIM_busy("COMSIM_busy"),
  EC_busy("EC_busy"),
  ENCOD_busy("ENCOD_busy"),
  outDataADC("outDataADC"),
  outDataEC("outDataEC"),
  outDataEnc("outDataEnc"),
  outDataComSim("outDataComSim"),
  outDataDec("outDataDec")
{
  // Create instances
  pADC = new ADCSource("ADC7276");
  pEC = new EchoCancellation("EchoCancellation");
  pAEnc = new AudioEncoder("AudioEncoder");
  pSim = new CommunicationSim("CommunicationSim");
  pADec = new AudioDecoder("AudioDecoder");
  pDAC = new DACSource("DAC7237");



  // Connect ports to channels
  //
  /***** ADC section **********/
  pADC->AudioClk_in(AudioClk);
  pADC->data_out(outDataADC);
  pADC->ready_out(ADC_busy);

  /***** EchoCancellation section **********/
  pEC->data_ready_in(ADC_busy);
  pEC->echo_in(outDataDec);
  pEC->data_in(outDataADC);
  pEC->ready_out(EC_busy);
  pEC->data_out(outDataEC);


  /***** Encoder section **********/
  pAEnc->hs_Clk_in(hsClk);
  pAEnc->data_ready_in(EC_busy);
  pAEnc->data_in(outDataEC);
  pAEnc->ready_out(ENCOD_busy);
  pAEnc->data_out(outDataEnc);


  /***** CommunicationSim section **********/
  pSim->hs_Clk_in(hsClk);
  pSim->data_ready_in(ENCOD_busy);
  pSim->data_in(outDataEnc);
  pSim->ready_out(COMSIM_busy);
  pSim->data_out(outDataComSim);


  /***** Decoder section **********/
  pADec->hs_Clk_in(hsClk);
  pADec->AudioClk_in(AudioClk);
  pADec->data_ready_in(COMSIM_busy);
  pADec->data_in(outDataComSim);
  pADec->data_out(outDataDec);

  /***** DAC section **********/
  pDAC->AudioClk_in(AudioClk);
  pDAC->data_in(outDataDec);


  /*************************************/
  // Assign connection between clock and channel
  SC_METHOD( AudioClockSignal);
  sensitive << AudioClock.signal();
  dont_initialize();
  SC_METHOD( HighSpeedClockSignal);
  sensitive << HS_Clock.signal();
  dont_initialize();

  /***** tacefile section **********/
  tracefile = sc_create_vcd_trace_file("AudioWave");
  if (!tracefile)
    cout << "Could not create trace file." << endl;

  sc_trace(tracefile, AudioClock, "Audio_clk");
  sc_trace(tracefile, ADC_busy, "ADC_busy");
  sc_trace(tracefile, outDataADC, "ADCData");

  sc_trace(tracefile, EC_busy, "EC_busy");
  sc_trace(tracefile, outDataEC, "EchoCanData");

  sc_trace(tracefile, ENCOD_busy, "ENCOD_busy");
  sc_trace(tracefile, hsClk, "hsClk");
  sc_trace(tracefile, outDataEnc, "EncoderData");

  sc_trace(tracefile, COMSIM_busy, "COMSIM_busy");
  sc_trace(tracefile, outDataComSim, "ComSimData");

  sc_trace(tracefile, outDataDec, "DecoderData");
}

AudioTop::~AudioTop()
{
  sc_close_vcd_trace_file( tracefile);
  cout << "Created AudioWave.vcd" << endl;
}

void AudioTop::AudioClockSignal()
{
  sc_logic clock_tmp(AudioClock.signal().read());
  AudioClk.write(clock_tmp);
}

void AudioTop::HighSpeedClockSignal()
{
  sc_logic clock_tmp(HS_Clock.signal().read());
  hsClk.write(clock_tmp);
}
