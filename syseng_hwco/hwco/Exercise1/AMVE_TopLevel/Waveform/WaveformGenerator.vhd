

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WaveformGenerator is
  
  port (
    -- Audio Interface
    csi_AudioClk12MHz_clk          : in  std_logic;  -- 12MHz Clk
    coe_AudioData_export              : out std_logic_vector(23 downto 0);
    -- Avalon Interface
    csi_clockreset_clk     : in  std_logic;  -- Avalon Clk
    csi_clockreset_reset_n : in  std_logic;  -- Avalon Reset
    avs_s1_write           : in  std_logic;  -- Avalon wr
    avs_s1_read            : in  std_logic;  -- Avalon rd
    avs_s1_chipselect      : in  std_logic;
    avs_s1_address         : in  std_logic_vector(3 downto 0);  -- Avalon address
    avs_s1_writedata       : in  std_logic_vector(7 downto 0);  -- Avalon wr data
    avs_s1_readdata        : out std_logic_vector(7 downto 0));  -- Avalon rd data

end WaveformGenerator;

architecture behaviour of WaveformGenerator is

  -- Registers
  constant WA_ATT_ADDR  : integer := 0;
  constant WF_FREQ_ADDR : integer := 1;
  constant WA_ATT_DEFAULT : std_logic_vector(7 downto 0) := X"01";
  constant WF_FREQ_DEFAULT : std_logic_vector(7 downto 0) := X"10";

  signal WF_FREQ     : std_logic_vector(7 downto 0);
  signal WA_ATT      : std_logic_vector(7 downto 0);
  signal WF_FREQ_avs : std_logic_vector(7 downto 0);
  signal WA_ATT_avs  : std_logic_vector(7 downto 0);

  -- Address Counter Signals
  constant Prescaler : integer range 0 to 7         := 4;
  constant RomLength : std_logic_vector(7 downto 0) := X"B4";  -- 180
  signal AudioClkCnt : integer range 0 to 1023;
  signal AudioClkCntReset : std_logic;
  signal AudioReset1 : std_logic;
  signal AudioReset2 : std_logic;
  signal AudioReset  : std_logic;
  signal CountEn     : std_logic;
  signal RomAddress  : std_logic_vector(7 downto 0);
  signal Waveform    : std_logic_vector(23 downto 0);

  signal avs_s1_write1 : std_logic;
  signal avs_s1_write2 : std_logic;
  signal avs_s1_write3 : std_logic;

begin  -- behaviour


  SinusoidROM_1 : entity work.SinusoidROM
    port map (
      address => RomAddress,
      clock   => csi_AudioClk12MHz_clk,
      q       => Waveform);


  SyncReset_proc: process (csi_AudioClk12MHz_clk)
  begin  -- process SyncReset_proc
    if csi_AudioClk12MHz_clk'event and csi_AudioClk12MHz_clk = '1' then  -- rising clock edge
      AudioReset1 <= csi_clockreset_reset_n;
      AudioReset2 <= AudioReset1;
      AudioReset <= AudioReset1 and AudioReset2 and csi_clockreset_reset_n;
    end if;
  end process SyncReset_proc;

  accessMem : process (csi_clockreset_clk, csi_clockreset_reset_n)
    variable wrData : std_logic_vector(avs_s1_writedata'high downto 0);
  begin  -- process accessMem
    if csi_clockreset_reset_n = '0' then  -- asynchronous reset (active low)
      WA_ATT_avs <= WA_ATT_DEFAULT;
      WF_FREQ_avs <= WF_FREQ_DEFAULT;
      avs_s1_readdata <= (others => 'Z');
    elsif csi_clockreset_clk'event and csi_clockreset_clk = '1' then  -- rising clock edge
      avs_s1_readdata <= (others => 'Z');
      if avs_s1_chipselect = '1' then
        if avs_s1_read = '1' then
          case avs_s1_address is
            when X"0" => avs_s1_readdata <= WA_ATT_avs;
            when X"1" => avs_s1_readdata <= WF_FREQ_avs;
            when others => avs_s1_readdata <= (others => '0');
          end case;
        elsif avs_s1_write = '1' then
          if avs_s1_writedata = "00000000" then
            wrData := "00000001";
          else
            wrData := avs_s1_writedata;
          end if;
          case avs_s1_address is
            when X"0" => WA_ATT_avs <= wrData;
            when X"1" => WF_FREQ_avs <= wrData;
            when others => null;
          end case;
        end if;
      end if;
    end if;
  end process accessMem;

  -- purpose: Sets the register values to the content of the RAM
  -- type   : sequential
  -- inputs : csi_AudioClk12MHz_clk, AudioReset, memArray
  -- outputs: WF_FREQ, WA_ATT
  SetParameters: process (csi_AudioClk12MHz_clk, AudioReset)
  begin  -- process SetParameters
    if AudioReset = '0' then  -- asynchronous reset (active low)
      WF_FREQ <= WF_FREQ_DEFAULT;
      WA_ATT <= WA_ATT_DEFAULT;
      avs_s1_write1 <= '0';
      avs_s1_write2 <= '0';
      avs_s1_write3 <= '0';
      AudioClkCntReset <= '1'; 
    elsif csi_AudioClk12MHz_clk'event and csi_AudioClk12MHz_clk = '1' then  -- rising clock edge
      -- It is assumed that _avs signal are stable for long periods
      -- except when written from the host. We can accept minor glitches
      -- during this.
      -- Multicycle = 2 between local and avs data

      WF_FREQ <= WF_FREQ_avs;
      WA_ATT  <= WA_ATT_avs;

      avs_s1_write1 <= avs_s1_write;
      avs_s1_write2 <= avs_s1_write1;
      avs_s1_write3 <= avs_s1_write2;
      AudioClkCntReset <= '0'; 

      if avs_s1_write3 = '0' and avs_s1_write2 = '1' then
        AudioClkCntReset <= '1'; 
      end if;
      
    end if;
  end process SetParameters;
  
  -- purpose: Generates the Counter enable signal for the ROM addr counter
  -- type   : sequential
  -- inputs : csi_AudioClk12MHz_clk, AudioReset
  -- outputs: CountEn
  CounterEnb_proc : process (csi_AudioClk12MHz_clk, AudioReset)
  begin  -- process CounterEnb_proc
    if AudioReset = '0' then  -- asynchronous reset (active low)
      CountEn     <= '0';
      AudioClkCnt <= 0;
    elsif csi_AudioClk12MHz_clk'event and csi_AudioClk12MHz_clk = '1' then  -- rising clock edge
      CountEn <= '0';                   -- default value
      if AudioClkCntReset = '1' then
        AudioClkCnt <= 0;
      elsif AudioClkCnt = to_integer(unsigned(shift_left(unsigned(WF_FREQ), 2))) -1  then
        CountEn     <= '1';
        AudioClkCnt <= 0;
      else
        AudioClkCnt <= AudioClkCnt + 1;
      end if;
    end if;
  end process CounterEnb_proc;

  -- purpose: ROM address Counter
  -- type   : sequential
  -- inputs : csi_AudioClk12MHz_clk, AudioReset, CountEn
  -- outputs: RomAddress
  AddressCounter_proc : process (csi_AudioClk12MHz_clk, AudioReset)
  begin  -- process AddressCounter_proc
    if AudioReset = '0' then  -- asynchronous reset (active low)
      RomAddress <= (others => '0');
    elsif csi_AudioClk12MHz_clk'event and csi_AudioClk12MHz_clk = '1' then  -- rising clock edge
      if CountEn = '1' then
        if unsigned(RomAddress) = unsigned(RomLength) - 1 then
          RomAddress <= (others => '0');
        else
          RomAddress <= std_logic_vector(unsigned(RomAddress) + 1);
        end if;
      end if;
    end if;
  end process AddressCounter_proc;

  coe_AudioData_export <= std_logic_vector(shift_right(signed(Waveform), (to_integer(unsigned(WA_ATT)) -1)));

--  AudioReset <= AudioReset1 and AudioReset2 and csi_clockreset_reset_n;

end behaviour;
