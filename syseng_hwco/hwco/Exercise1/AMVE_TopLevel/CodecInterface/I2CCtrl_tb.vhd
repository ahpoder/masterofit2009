-------------------------------------------------------------------------------
-- Title      : Testbench for design "I2CCtrl"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : I2CCtrl_tb.vhd
-- Author     :   <phm@E4300-004>
-- Company    : 
-- Created    : 2009-10-08
-- Last update: 2009-10-08
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

entity I2CCtrl_tb is

end I2CCtrl_tb;

-------------------------------------------------------------------------------

architecture wave of I2CCtrl_tb is

  component I2CCtrl
    port (
      Clk           : in    std_logic;
      Reset         : in    std_logic;
      I2CWriteReq   : in    std_logic;
      I2CWriteAck   : out   std_logic;
      I2CDeviceAddr : in    std_logic_vector(6 downto 0);
      I2CData       : in    std_logic_vector(15 downto 0);
      I2C_SCL       : out   std_logic;
      I2C_SDA       : inout std_logic);
  end component;

  -- component ports
  signal Reset         : std_logic;
  signal I2CWriteReq   : std_logic;
  signal I2CWriteAck   : std_logic;
  signal I2CDeviceAddr : std_logic_vector(6 downto 0);
  signal I2CData       : std_logic_vector(15 downto 0);
  signal I2C_SCL       : std_logic;
  signal I2C_SDA       : std_logic;

  -- clock
  signal Clk : std_logic := '1';
  constant period : time := 20 ns;

  type InitData_type is record
    cmd   : std_logic_vector(7 downto 0);  -- I2C Command
    addr  : std_logic_vector(7 downto 0);  -- Register Addr
    value : std_logic_vector(7 downto 0);  -- Value
  end record;
  type InitDataArray_type is array (natural range <>) of InitData_type;

  constant InitData : InitDataArray_type := (
    -- address, value                      WM8731 Configuration
    (X"34", X"00", X"17"),                     -- Left line-in 0dB attn, Mute disable 
    (X"34", X"01", X"17"),                     -- Right line-in 0dB attn, Mute disable
    (X"34", X"04", X"12"),                     -- By-pass disable, DAC enb, Line-in to ADC
    (X"34", X"07", X"4A"),                     -- I2S, 24-bit, Master Mode
    (X"34", X"08", X"01"));                    -- USB Mode, 250fs over-sampling, 48KHz sampling rate 

  constant I2CDevAddr : std_logic_vector(6 downto 0) := "0011010";
  
begin  -- wave

  -- component instantiation
  DUT: I2CCtrl
    port map (
      Clk           => Clk,
      Reset         => Reset,
      I2CWriteReq   => I2CWriteReq,
      I2CWriteAck   => I2CWriteAck,
      I2CDeviceAddr => I2CDeviceAddr,
      I2CData       => I2CData,
      I2C_SCL       => I2C_SCL,
      I2C_SDA       => I2C_SDA);

  -- clock generation
  Clk <= not Clk after period/2;
  Reset <= '0', '1' after 100 us;
  
  -- waveform generation
  WaveGen_Proc: process
  begin
    I2CWriteReq <= '0';
    wait until Clk = '1';
    wait until Reset = '1';

    I2CDeviceAddr <= I2CDevAddr;

    for i in 0 to InitData'high loop
      I2CData <= InitData(i).addr & InitData(i).value;
      I2CWriteReq <= '1';
      wait for period;
      I2CWriteReq <= '0';
      wait until I2CWriteAck = '1';
      wait until I2CWriteAck = '0';
    end loop;  -- i
    
    
  end process WaveGen_Proc;

  

end wave;

-------------------------------------------------------------------------------

