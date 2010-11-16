library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CodecInterface is
  
  port (
    -- Audio Interface
    csi_AudioClk12MHz_clk          : in    std_logic;   -- 12MHz Clk
    csi_AudioClk12MHz_reset_n             : in    std_logic;   -- 12MHz Clk
    coe_AudioOut_export               : out   std_logic_vector(23 downto 0);  -- From Codec
    coe_Audioin_export                : in    std_logic_vector(23 downto 0);  -- To Codec
    coe_AudioSync_export              : out   std_logic;   -- 48KHz Sync
    -- Avalon Interface
    csi_clockreset_clk     : in    std_logic;   -- Avalon Clk
    csi_clockreset_reset_n : in    std_logic;   -- Avalon Reset
    avs_s1_write           : in    std_logic;   -- Avalon wr
    avs_s1_read            : in    std_logic;   -- Avalon rd
    avs_s1_chipselect      : in    std_logic;   -- Avalon Chip Select
    avs_s1_address         : in    std_logic_vector(3 downto 0);  -- Avalon address
    avs_s1_writedata       : in    std_logic_vector(7 downto 0);  -- Avalon wr data
    avs_s1_readdata        : out   std_logic_vector(7 downto 0);  -- Avalon rd data
    -- Codec Interface
    coe_CodecXClk_export              : out   std_logic;   -- Codec I2S XCLK
    coe_CodecBClk_export              : in    std_logic;   -- Codec I2S BCLK
    coe_CodecAdcLrc_export            : in    std_logic;   -- Codec I2S ADCLRC
    coe_CodecDacLrc_export            : in    std_logic;   -- Codec I2S DACLRC
    coe_CodecAdcDat_export            : in    std_logic;   -- Codec I2S Audio in
    coe_CodecDacDat_export            : out   std_logic;   -- Codec I2S Audio out
    coe_CodecScl_export               : out   std_logic;   -- Codec I2C Clock
    coe_CodecSda_export               : inout std_logic);  -- Codec I2C Data

end CodecInterface;

architecture behaviour of CodecInterface is

  -- Constant Declarations
  constant CI_ADDR        : std_logic_vector(3 downto 0) := X"0";
  constant CI_PRG_DEFAULT : std_logic                    := '0';

  -- Type Declarations
  type ShiftDataState_type is (IdleR, ShiftDataR, IdleL, ShiftDataL);

  -- Signal Declarations
  signal ShiftDacDataState : ShiftDataState_type;
  signal CI_PRG            : std_logic;
  signal DacSrOut          : std_logic;
  signal DacSrCnt          : integer range 0 to 23;
  signal DacLrc_last       : std_logic;
  signal DacSrIn           : std_logic_vector(23 downto 0);

  signal AdcSrOut    : std_logic;
  signal AdcSrCnt    : integer range 0 to 23;
  signal AdcLrc_last : std_logic;
  signal AdcSrIn     : std_logic_vector(23 downto 0);

  signal Cnt48KHz     : integer range 0 to 255;
  signal sAudioSync   : std_logic := '1';
  signal sCodecDacLrc : std_logic;

begin  -- behaviour

  -- Component Instantiations
  InitWF8731_1 : entity work.InitWF8731
    port map (
      csi_clockreset_clk     => csi_clockreset_clk,
      csi_clockreset_reset_n => csi_clockreset_reset_n,
      CodecScl               => coe_CodecScl_export,
      CodecSda               => coe_CodecSda_export,
      GoPrg                  => CI_PRG);

  -- purpose: Register with Avalon Bus interface
  -- type   : sequential
  -- inputs : csi_clockreset_clk, csi_clockreset_reset_n, avalonbus
  -- outputs: GoPrg
  accessMem : process (csi_clockreset_clk, csi_clockreset_reset_n)
    variable wrData : std_logic_vector(avs_s1_writedata'high downto 0);
  begin  -- process accessMem
    if csi_clockreset_reset_n = '0' then  -- asynchronous reset (active low)
      CI_PRG <= CI_PRG_DEFAULT;
    elsif csi_clockreset_clk'event and csi_clockreset_clk = '1' then  -- rising clock edge
      CI_PRG <= CI_PRG_DEFAULT;         -- CI_PRG is only set for one clk cycle
      if avs_s1_chipselect = '1' then
        if avs_s1_write = '1' then
          case avs_s1_address is
            when CI_ADDR => CI_PRG <= avs_s1_writedata(0);  -- CI_PRG = bit 0 if CI Register
            when others  => null;
          end case;
        end if;
      end if;
    end if;
  end process accessMem;

  -- purpose: Shift DAC data out
  -- type   : sequential
  -- inputs : csi_AudioClk12MHz_clk, csi_AudioClk12MHz_reset_n
  -- outputs: 
  ShiftDacData : process (csi_AudioClk12MHz_clk, csi_AudioClk12MHz_reset_n)
  begin  -- process ShiftDacData
    if csi_AudioClk12MHz_reset_n = '0' then            -- asynchronous reset (active low)
      DacSrOut    <= '0';
      DacSrCnt    <= 23;
      DacLrc_last <= '0';
    elsif csi_AudioClk12MHz_clk'event and csi_AudioClk12MHz_clk = '1' then  -- rising clock edge
      DacLrc_last <= sCodecDacLrc;
      case ShiftDacDataState is
        when IdleR =>
          coe_AudioOut_export <= AdcSrIn;
          DacSrCnt <= 23;
          if (sCodecDacLrc = '1' and DacLrc_last = '0') then
            DacSrIn           <= coe_Audioin_export;
            ShiftDacDataState <= ShiftDataR;
          end if;
        when ShiftDataR =>
          DacSrOut          <= DacSrIn(DacSrCnt);
          AdcSrIn(DacSrCnt) <= coe_CodecAdcDat_export;
          if DacSrCnt = 0 then
            DacSrCnt          <= 23;
            ShiftDacDataState <= idleL;
          else
            DacSrCnt <= DacSrCnt - 1;
          end if;
        when IdleL =>
          coe_AudioOut_export <= AdcSrIn;
          DacSrCnt <= 23;
          if (sCodecDacLrc = '0' and DacLrc_last = '1') then
            DacSrIn           <= coe_Audioin_export;
            ShiftDacDataState <= ShiftDataL;
          end if;
        when ShiftDataL =>
          DacSrOut          <= DacSrIn(DacSrCnt);
          AdcSrIn(DacSrCnt) <= coe_CodecAdcDat_export;
          if DacSrCnt = 0 then
            DacSrCnt          <= 23;
            ShiftDacDataState <= idleR;
          else
            DacSrCnt <= DacSrCnt - 1;
          end if;
        when others =>
          ShiftDacDataState <= idleR;
      end case;
    end if;
  end process ShiftDacData;

  -- Concurrent Statements

  coe_CodecDacDat_export     <= DacSrOut;          -- WfmGen
  avs_s1_readdata <= (others => 'Z');
  coe_CodecXClk_export       <= csi_AudioClk12MHz_clk;     -- Codec Clock Source

  -- Master Mode Codec I/F
  coe_AudioSync_export    <= coe_CodecDacLrc_export;          -- Sync = I2S Frame Sync
  sCodecDacLrc <= coe_CodecDacLrc_export;          -- Slave Mode

end behaviour;
