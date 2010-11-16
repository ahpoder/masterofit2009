-------------------------------------------------------------------------------
-- Title      : Testbench for design "WaveformGenerator"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : WaveformGenerator_tb.vhd
-- Author     :   <phm@E4300-004>
-- Company    : 
-- Created    : 2009-09-30
-- Last update: 2009-10-05
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2009 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2009-09-30  1.0      phm     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity WaveformGenerator_tb is

end WaveformGenerator_tb;

-------------------------------------------------------------------------------

architecture wave of WaveformGenerator_tb is

  component WaveformGenerator
    port (
      AudioClk12MHz          : in  std_logic;
      AudioData              : out std_logic_vector(23 downto 0);
      csi_clockreset_clk     : in  std_logic;
      csi_clockreset_reset_n : in  std_logic;
      avs_s1_write           : in  std_logic;
      avs_s1_read            : in  std_logic;
      avs_s1_chipselect      : in  std_logic;
      avs_s1_address         : in  std_logic_vector(3 downto 0);
      avs_s1_writedata       : in  std_logic_vector(7 downto 0);
      avs_s1_readdata        : out std_logic_vector(7 downto 0));
  end component;

  -- component generics
  constant abc : integer := 1;

  -- component ports
  signal AudioData              : std_logic_vector(23 downto 0);
  signal csi_clockreset_clk     : std_logic                    := '1';
  signal csi_clockreset_reset_n : std_logic                    := '1';
  signal avs_s1_write           : std_logic                    := '0';
  signal avs_s1_read            : std_logic                    := '0';
  signal avs_s1_chipselect      : std_logic                    := '0';
  signal avs_s1_address         : std_logic_vector(3 downto 0) := "0000";
  signal avs_s1_writedata       : std_logic_vector(7 downto 0) := "00000000";
  signal avs_s1_readdata        : std_logic_vector(7 downto 0);

  -- clock
  signal Clk50MHz      : std_logic := '1';
  signal Clk12MHz      : std_logic := '1';
  constant period50MHz : time      := 20 ns;
  constant period12MHz : time      := 83.333 ns;
  
begin  -- wave

  -- component instantiation
  DUT : WaveformGenerator
    port map (
      AudioClk12MHz          => Clk12MHz,
      AudioData              => AudioData,
      csi_clockreset_clk     => Clk50MHz,
      csi_clockreset_reset_n => csi_clockreset_reset_n,
      avs_s1_write           => avs_s1_write,
      avs_s1_read            => avs_s1_read,
      avs_s1_chipselect      => avs_s1_chipselect,
      avs_s1_address         => avs_s1_address,
      avs_s1_writedata       => avs_s1_writedata,
      avs_s1_readdata        => avs_s1_readdata);

  -- clock generation
  Clk12MHz <= not Clk12MHz after period12MHz/2;
  Clk50MHz <= not Clk50MHz after period50MHz/2;

  csi_clockreset_reset_n <= '0', '1' after 125 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    
    wait until csi_clockreset_reset_n = '1';
    wait until Clk50MHz = '1';

    -- Do whatever

    wait;
  end process WaveGen_Proc;


end wave;


