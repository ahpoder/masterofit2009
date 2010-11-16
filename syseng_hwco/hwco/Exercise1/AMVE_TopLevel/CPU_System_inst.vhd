  --Example instantiation for system 'CPU_System'
  CPU_System_inst : CPU_System
    port map(
      LCD_E_from_the_lcd => LCD_E_from_the_lcd,
      LCD_RS_from_the_lcd => LCD_RS_from_the_lcd,
      LCD_RW_from_the_lcd => LCD_RW_from_the_lcd,
      LCD_data_to_and_from_the_lcd => LCD_data_to_and_from_the_lcd,
      SRAM_ADDR_from_the_sram_0 => SRAM_ADDR_from_the_sram_0,
      SRAM_CE_N_from_the_sram_0 => SRAM_CE_N_from_the_sram_0,
      SRAM_DQ_to_and_from_the_sram_0 => SRAM_DQ_to_and_from_the_sram_0,
      SRAM_LB_N_from_the_sram_0 => SRAM_LB_N_from_the_sram_0,
      SRAM_OE_N_from_the_sram_0 => SRAM_OE_N_from_the_sram_0,
      SRAM_UB_N_from_the_sram_0 => SRAM_UB_N_from_the_sram_0,
      SRAM_WE_N_from_the_sram_0 => SRAM_WE_N_from_the_sram_0,
      coe_AudioData_export_from_the_WaveformGenerator_0 => coe_AudioData_export_from_the_WaveformGenerator_0,
      coe_AudioOut_export_from_the_CodecInterface_0 => coe_AudioOut_export_from_the_CodecInterface_0,
      coe_AudioSync_export_from_the_CodecInterface_0 => coe_AudioSync_export_from_the_CodecInterface_0,
      coe_CodecDacDat_export_from_the_CodecInterface_0 => coe_CodecDacDat_export_from_the_CodecInterface_0,
      coe_CodecScl_export_from_the_CodecInterface_0 => coe_CodecScl_export_from_the_CodecInterface_0,
      coe_CodecSda_export_to_and_from_the_CodecInterface_0 => coe_CodecSda_export_to_and_from_the_CodecInterface_0,
      coe_CodecXClk_export_from_the_CodecInterface_0 => coe_CodecXClk_export_from_the_CodecInterface_0,
      out_port_from_the_pio_output1 => out_port_from_the_pio_output1,
      out_port_from_the_pio_output2 => out_port_from_the_pio_output2,
      clk => clk,
      clk12 => clk12,
      coe_Audioin_export_to_the_CodecInterface_0 => coe_Audioin_export_to_the_CodecInterface_0,
      coe_CodecAdcDat_export_to_the_CodecInterface_0 => coe_CodecAdcDat_export_to_the_CodecInterface_0,
      coe_CodecAdcLrc_export_to_the_CodecInterface_0 => coe_CodecAdcLrc_export_to_the_CodecInterface_0,
      coe_CodecBClk_export_to_the_CodecInterface_0 => coe_CodecBClk_export_to_the_CodecInterface_0,
      coe_CodecDacLrc_export_to_the_CodecInterface_0 => coe_CodecDacLrc_export_to_the_CodecInterface_0,
      in_port_to_the_pio_input => in_port_to_the_pio_input,
      reset_n => reset_n
    );


