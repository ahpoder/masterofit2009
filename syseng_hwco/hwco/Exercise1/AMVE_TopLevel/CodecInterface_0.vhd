-- CodecInterface_0.vhd

-- This file was auto-generated as part of a SOPC Builder generate operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CodecInterface_0 is
	port (
		csi_AudioClk12MHz_clk     : in    std_logic                     := '0';             -- AudioClk12MHz.clk
		csi_AudioClk12MHz_reset_n : in    std_logic                     := '0';             --              .reset_n
		coe_AudioOut_export       : out   std_logic_vector(23 downto 0);                    --      AudioOut.export
		coe_Audioin_export        : in    std_logic_vector(23 downto 0) := (others => '0'); --       Audioin.export
		coe_AudioSync_export      : out   std_logic;                                        --     AudioSync.export
		csi_clockreset_clk        : in    std_logic                     := '0';             --    clockreset.clk
		csi_clockreset_reset_n    : in    std_logic                     := '0';             --              .reset_n
		avs_s1_write              : in    std_logic                     := '0';             --            s1.write
		avs_s1_read               : in    std_logic                     := '0';             --              .read
		avs_s1_chipselect         : in    std_logic                     := '0';             --              .chipselect
		avs_s1_address            : in    std_logic_vector(3 downto 0)  := (others => '0'); --              .address
		avs_s1_writedata          : in    std_logic_vector(7 downto 0)  := (others => '0'); --              .writedata
		avs_s1_readdata           : out   std_logic_vector(7 downto 0);                     --              .readdata
		coe_CodecXClk_export      : out   std_logic;                                        --     CodecXClk.export
		coe_CodecBClk_export      : in    std_logic                     := '0';             --     CodecBClk.export
		coe_CodecAdcLrc_export    : in    std_logic                     := '0';             --   CodecAdcLrc.export
		coe_CodecDacLrc_export    : in    std_logic                     := '0';             --   CodecDacLrc.export
		coe_CodecAdcDat_export    : in    std_logic                     := '0';             --   CodecAdcDat.export
		coe_CodecDacDat_export    : out   std_logic;                                        --   CodecDacDat.export
		coe_CodecScl_export       : out   std_logic;                                        --      CodecScl.export
		coe_CodecSda_export       : inout std_logic                     := '0'              --      CodecSda.export
	);
end entity CodecInterface_0;

architecture rtl of CodecInterface_0 is
	component CodecInterface is
		port (
			csi_AudioClk12MHz_clk     : in    std_logic                     := 'X';             -- AudioClk12MHz.clk
			csi_AudioClk12MHz_reset_n : in    std_logic                     := 'X';             --              .reset_n
			coe_AudioOut_export       : out   std_logic_vector(23 downto 0);                    --      AudioOut.export
			coe_Audioin_export        : in    std_logic_vector(23 downto 0) := (others => 'X'); --       Audioin.export
			coe_AudioSync_export      : out   std_logic;                                        --     AudioSync.export
			csi_clockreset_clk        : in    std_logic                     := 'X';             --    clockreset.clk
			csi_clockreset_reset_n    : in    std_logic                     := 'X';             --              .reset_n
			avs_s1_write              : in    std_logic                     := 'X';             --            s1.write
			avs_s1_read               : in    std_logic                     := 'X';             --              .read
			avs_s1_chipselect         : in    std_logic                     := 'X';             --              .chipselect
			avs_s1_address            : in    std_logic_vector(3 downto 0)  := (others => 'X'); --              .address
			avs_s1_writedata          : in    std_logic_vector(7 downto 0)  := (others => 'X'); --              .writedata
			avs_s1_readdata           : out   std_logic_vector(7 downto 0);                     --              .readdata
			coe_CodecXClk_export      : out   std_logic;                                        --     CodecXClk.export
			coe_CodecBClk_export      : in    std_logic                     := 'X';             --     CodecBClk.export
			coe_CodecAdcLrc_export    : in    std_logic                     := 'X';             --   CodecAdcLrc.export
			coe_CodecDacLrc_export    : in    std_logic                     := 'X';             --   CodecDacLrc.export
			coe_CodecAdcDat_export    : in    std_logic                     := 'X';             --   CodecAdcDat.export
			coe_CodecDacDat_export    : out   std_logic;                                        --   CodecDacDat.export
			coe_CodecScl_export       : out   std_logic;                                        --      CodecScl.export
			coe_CodecSda_export       : inout std_logic                     := 'X'              --      CodecSda.export
		);
	end component CodecInterface;

begin

	codecinterface_0 : component CodecInterface
		port map (
			csi_AudioClk12MHz_clk     => csi_AudioClk12MHz_clk,     -- AudioClk12MHz.clk
			csi_AudioClk12MHz_reset_n => csi_AudioClk12MHz_reset_n, --              .reset_n
			coe_AudioOut_export       => coe_AudioOut_export,       --      AudioOut.export
			coe_Audioin_export        => coe_Audioin_export,        --       Audioin.export
			coe_AudioSync_export      => coe_AudioSync_export,      --     AudioSync.export
			csi_clockreset_clk        => csi_clockreset_clk,        --    clockreset.clk
			csi_clockreset_reset_n    => csi_clockreset_reset_n,    --              .reset_n
			avs_s1_write              => avs_s1_write,              --            s1.write
			avs_s1_read               => avs_s1_read,               --              .read
			avs_s1_chipselect         => avs_s1_chipselect,         --              .chipselect
			avs_s1_address            => avs_s1_address,            --              .address
			avs_s1_writedata          => avs_s1_writedata,          --              .writedata
			avs_s1_readdata           => avs_s1_readdata,           --              .readdata
			coe_CodecXClk_export      => coe_CodecXClk_export,      --     CodecXClk.export
			coe_CodecBClk_export      => coe_CodecBClk_export,      --     CodecBClk.export
			coe_CodecAdcLrc_export    => coe_CodecAdcLrc_export,    --   CodecAdcLrc.export
			coe_CodecDacLrc_export    => coe_CodecDacLrc_export,    --   CodecDacLrc.export
			coe_CodecAdcDat_export    => coe_CodecAdcDat_export,    --   CodecAdcDat.export
			coe_CodecDacDat_export    => coe_CodecDacDat_export,    --   CodecDacDat.export
			coe_CodecScl_export       => coe_CodecScl_export,       --      CodecScl.export
			coe_CodecSda_export       => coe_CodecSda_export        --      CodecSda.export
		);

end architecture rtl; -- of CodecInterface_0
