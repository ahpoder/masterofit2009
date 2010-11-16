-------------------------------------------------------------------------------
-- Title      : Testbench for design "CodecInterface"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : CodecInterface_tb.vhd
-- Author     :   <phm@E4300-004>
-- Company    : 
-- Created    : 2009-10-08
-- Last update: 2009-10-23
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2009 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2009-10-08  1.0      phm	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity CodecInterface_tb is

end CodecInterface_tb;

-------------------------------------------------------------------------------

architecture wave of CodecInterface_tb is

  -- component ports
  signal AudioClk12MHz          : std_logic;
  signal AudioReset             : std_logic;
  signal AudioOut               : std_logic_vector(23 downto 0);
  signal Audioin                : std_logic_vector(23 downto 0) := X"F54321";
  signal AudioSync              : std_logic;
  signal csi_clockreset_clk     : std_logic :='0';
  signal csi_clockreset_reset_n : std_logic :='1';
  signal avs_s1_write           : std_logic :='0';
  signal avs_s1_read            : std_logic :='0';
  signal avs_s1_chipselect      : std_logic :='0';
  signal avs_s1_address         : std_logic_vector(3 downto 0);
  signal avs_s1_writedata       : std_logic_vector(7 downto 0);
  signal avs_s1_readdata        : std_logic_vector(7 downto 0);
  signal CodecXClk              : std_logic;
  signal CodecBClk              : std_logic;
  signal CodecAdcLrc            : std_logic;
  signal CodecDacLrc            : std_logic;
  signal CodecAdcDat            : std_logic;
  signal CodecDacDat            : std_logic;
  signal CodecScl               : std_logic;
  signal CodecSda               : std_logic;
  signal GoPrg                  : std_logic := '0';

  -- clock
  signal Clk : std_logic := '1';
  constant period : time := 20 ns;
  signal Clk12MHz : std_logic := '1';
  constant period12MHz : time := 83 ns;
  signal Clk48KHz : std_logic := '1';
  constant period48KHz : time := 10 us;

begin  -- wave

  -- component instantiation
  DUT: entity work.CodecInterface
    port map (
      AudioClk12MHz          => AudioClk12MHz,
      AudioReset             => AudioReset,
      AudioOut               => AudioOut,
      Audioin                => Audioin,
      AudioSync              => AudioSync,
      csi_clockreset_clk     => csi_clockreset_clk,
      csi_clockreset_reset_n => csi_clockreset_reset_n,
      avs_s1_write           => avs_s1_write,
      avs_s1_read            => avs_s1_read,
      avs_s1_chipselect      => avs_s1_chipselect,
      avs_s1_address         => avs_s1_address,
      avs_s1_writedata       => avs_s1_writedata,
      avs_s1_readdata        => avs_s1_readdata,
      CodecXClk              => CodecXClk,
      CodecBClk              => CodecBClk,
      CodecAdcLrc            => CodecAdcLrc,
      CodecDacLrc            => CodecDacLrc,
      CodecAdcDat            => CodecAdcDat,
      CodecDacDat            => CodecDacDat,
      CodecScl               => CodecScl,
      CodecSda               => CodecSda);

  -- clock generation
  Clk <= not Clk after period/2;
  Clk48KHz <= not Clk48KHZ after period48KHz/2;
  Clk12MHz <= not Clk12MHZ after period12MHz/2;
  csi_clockreset_reset_n <= '0', '1' after 1 us;

  -- Codec Master Mode
  CodecAdcLrc <= Clk48KHZ;
  CodecDacLrc <= Clk48KHZ;

  AudioReset <= csi_clockreset_reset_n;
  AudioClk12MHz <= Clk12MHZ;
  
  -- waveform generation
  WaveGen_Proc: process
  begin
    
    wait until csi_clockreset_reset_n = '1';
    wait until Clk = '1';

    -- Start Codec Initialization
    avs_s1_address <= X"0";
    avs_s1_writedata <= X"01";
    wait for period;
    avs_s1_chipselect <= '1';
    avs_s1_write <= '1';
    wait for 2 * period;
    avs_s1_chipselect <= '0';
    avs_s1_write <= '0';

    -- Do something else
    
  end process WaveGen_Proc;

  csi_clockreset_clk <= Clk;
  

end wave;

-------------------------------------------------------------------------------

