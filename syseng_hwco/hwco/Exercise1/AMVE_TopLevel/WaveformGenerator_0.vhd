-- WaveformGenerator_0.vhd

-- This file was auto-generated as part of a SOPC Builder generate operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity WaveformGenerator_0 is
	port (
		csi_AudioClk12MHz_clk  : in  std_logic                     := '0';             -- AudioClk12MHz.clk
		coe_AudioData_export   : out std_logic_vector(23 downto 0);                    --     AudioData.export
		csi_clockreset_clk     : in  std_logic                     := '0';             --    clockreset.clk
		csi_clockreset_reset_n : in  std_logic                     := '0';             --              .reset_n
		avs_s1_write           : in  std_logic                     := '0';             --            s1.write
		avs_s1_read            : in  std_logic                     := '0';             --              .read
		avs_s1_chipselect      : in  std_logic                     := '0';             --              .chipselect
		avs_s1_address         : in  std_logic_vector(3 downto 0)  := (others => '0'); --              .address
		avs_s1_writedata       : in  std_logic_vector(7 downto 0)  := (others => '0'); --              .writedata
		avs_s1_readdata        : out std_logic_vector(7 downto 0)                      --              .readdata
	);
end entity WaveformGenerator_0;

architecture rtl of WaveformGenerator_0 is
	component WaveformGenerator is
		port (
			csi_AudioClk12MHz_clk  : in  std_logic                     := 'X';             -- AudioClk12MHz.clk
			coe_AudioData_export   : out std_logic_vector(23 downto 0);                    --     AudioData.export
			csi_clockreset_clk     : in  std_logic                     := 'X';             --    clockreset.clk
			csi_clockreset_reset_n : in  std_logic                     := 'X';             --              .reset_n
			avs_s1_write           : in  std_logic                     := 'X';             --            s1.write
			avs_s1_read            : in  std_logic                     := 'X';             --              .read
			avs_s1_chipselect      : in  std_logic                     := 'X';             --              .chipselect
			avs_s1_address         : in  std_logic_vector(3 downto 0)  := (others => 'X'); --              .address
			avs_s1_writedata       : in  std_logic_vector(7 downto 0)  := (others => 'X'); --              .writedata
			avs_s1_readdata        : out std_logic_vector(7 downto 0)                      --              .readdata
		);
	end component WaveformGenerator;

begin

	waveformgenerator_0 : component WaveformGenerator
		port map (
			csi_AudioClk12MHz_clk  => csi_AudioClk12MHz_clk,  -- AudioClk12MHz.clk
			coe_AudioData_export   => coe_AudioData_export,   --     AudioData.export
			csi_clockreset_clk     => csi_clockreset_clk,     --    clockreset.clk
			csi_clockreset_reset_n => csi_clockreset_reset_n, --              .reset_n
			avs_s1_write           => avs_s1_write,           --            s1.write
			avs_s1_read            => avs_s1_read,            --              .read
			avs_s1_chipselect      => avs_s1_chipselect,      --              .chipselect
			avs_s1_address         => avs_s1_address,         --              .address
			avs_s1_writedata       => avs_s1_writedata,       --              .writedata
			avs_s1_readdata        => avs_s1_readdata         --              .readdata
		);

end architecture rtl; -- of WaveformGenerator_0
