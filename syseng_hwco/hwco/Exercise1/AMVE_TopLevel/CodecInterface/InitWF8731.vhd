library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InitWF8731 is
  
  port (
    -- Avalon Interface
    csi_clockreset_clk     : in    std_logic;   -- Avalon Clk
    csi_clockreset_reset_n : in    std_logic;   -- Avalon Reset
    -- Codec Interface
    CodecScl               : out   std_logic;   -- Codec I2C Clock
    CodecSda               : inout std_logic;   -- Codec I2C Data
    -- Start Programming
    GoPrg                  : in    std_logic);  -- Start I2C programming

end InitWF8731;

architecture behaviour of InitWF8731 is

  -- Alias Declarations
  alias Clk is csi_clockreset_clk;
  alias Reset is csi_clockreset_reset_n;

  -- Type Delarations
  type InitData_type is record
    addr  : std_logic_vector(7 downto 0);  -- Register Addr
    value : std_logic_vector(7 downto 0);  -- Value
  end record;
  type InitDataArray_type is array (natural range <>) of InitData_type;

  type CodecPrgState_type is (Idle, StartWrite, Writing);
  signal CodecPrgState : CodecPrgState_type;

  signal i : integer range 0 to 15;

  -- WF8731 Configuration
  constant InitData : InitDataArray_type := (
    -- address, value              WM8731 Configuration
    (X"00", X"17"),                     -- Left line-in 0dB attn, Mute disable 
    (X"02", X"17"),                     -- Right line-in 0dB attn, Mute disable
    (X"04", X"79"),                     -- 
    (X"06", X"79"),                     -- 
    (X"08", X"12"),   -- By-pass disable, DAC enb, Line-in to ADC
    (X"0A", X"00"),                     -- 
    (X"0C", X"00"),                     -- 
    (X"0E", X"4A"),                     -- I2S, 24-bit, Master Mode
--    (X"0E", X"CA"),             -- I2S, 24-bit, Master Mode, BCLK Inv
--    (X"0E", X"0A"),             -- I2S, 24-bit, Slave Mode
    (X"10", X"01"),   -- USB Mode, 250fs over-sampling, 48KHz sampling rate 
    (X"12", X"01"));                    -- Activate

  constant WF8731I2CAddr : std_logic_vector(6 downto 0) := "0011010";

  signal I2CWriteAck_last : std_logic;
  signal GoPrg_last       : std_logic;
  signal I2CWriteReq      : std_logic;
  signal I2CWriteAck      : std_logic;
  signal I2CData          : std_logic_vector(15 downto 0);
  
begin  -- behaviour

  I2CCtrl_1 : entity work.I2CCtrl
    port map (
      Clk           => Clk,
      Reset         => Reset,
      I2CWriteReq   => I2CWriteReq,
      I2CWriteAck   => I2CWriteAck,
      I2CDeviceAddr => WF8731I2CAddr,
      I2CData       => I2CData,
      I2C_SCL       => CodecScl,
      I2C_SDA       => CodecSda);


  -- purpose: Initialize WF8731
  -- type   : sequential
  -- inputs : Clk, Reset
  -- outputs: 
  InitWF8731 : process (Clk, Reset)
  begin  -- process InitWF8731
    if Reset = '0' then                 -- asynchronous reset (active low)
      I2CWriteReq      <= '0';
      I2CData          <= (others => '0');
      GoPrg_last       <= '0';
      I2CWriteAck_last <= '0';
    elsif Clk'event and Clk = '1' then  -- rising clock edge
      I2CWriteAck_last <= I2CWriteAck;
      GoPrg_last       <= GoPrg;
      case CodecPrgState is
        when Idle =>
          i <= 0;
          if GoPrg = '1' and GoPrg_last = '0' then
            CodecPrgState <= StartWrite;
          end if;
        when StartWrite =>
          I2CData       <= InitData(i).addr & InitData(i).value;
          I2CWriteReq   <= '1';
          CodecPrgState <= Writing;
        when Writing =>
          I2CWriteReq <= '0';
          if I2CWriteAck = '0' and I2CWriteAck_last = '1' then
            if i = InitData'high then
              CodecPrgState <= Idle;
            else
              i             <= i + 1;
              CodecPrgState <= StartWrite;
            end if;
          end if;
        when others =>
          CodecPrgState <= Idle;
      end case;
    end if;
  end process InitWF8731;

end behaviour;
