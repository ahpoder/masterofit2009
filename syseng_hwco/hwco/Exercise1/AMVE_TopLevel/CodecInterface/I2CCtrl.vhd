library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity I2CCtrl is
  
  port (
    -- Clock & Reset
    Clk           : in    std_logic;    -- Clk
    Reset         : in    std_logic;    -- Reset
    -- Control Signal
    I2CWriteReq   : in    std_logic;    -- Request Codec Init
    I2CWriteAck   : out   std_logic;    -- Ack when init completed
    I2CDeviceAddr : in    std_logic_vector(6 downto 0);
    I2CData       : in    std_logic_vector(15 downto 0);
    -- Codec Control Interface
    I2C_SCL       : out   std_logic;    -- Codec I2C Clock
    I2C_SDA       : inout std_logic);   -- Codec I2C Data

end I2CCtrl;

architecture behaviour of I2CCtrl is

  signal I2CDir   : std_logic;          -- I2C Data direction signal 0=Wr/1=Rd
  signal I2CClkEn : std_logic;

  signal SDA     : std_logic;
  signal SCL     : std_logic;
  signal SDA_in  : std_logic := '0';
  signal SDA_out : std_logic;
  signal SDA_dir : std_logic;
--  signal AckError : std_logic;            -- I2C Data direction signal 0=Wr/1=Rd

  signal DoneWriting : std_logic;

  signal BitCount  : integer range 0 to 11;  -- Counter for Clk divider
  signal ByteCount : integer range 0 to 11;  -- Counter for Clk divider

  signal BaudRateClkCnt   : integer range 0 to 511;  -- Counter for Clk divider
  constant BaudRateClkDiv : integer := 511;          -- Baudrate Clk Divider
                                                     -- Fiic = 50Mhz / div

  constant I2CWrConst : std_logic := '0';
  constant I2CRdConst : std_logic := '1';

  type I2CCtrlState_type is (Idle, StartWrite, Writing, StopWrite, Ack);
  signal I2CCtrlPresentState, I2CCtrlNextState : I2CCtrlState_type;

  type I2CData_type is array (0 to 2) of std_logic_vector(7 downto 0);
  signal I2CTxData : I2CData_type;

  signal I2CWriteReq2 : std_logic;

  
begin  -- behaviour

  I2CTxData(0) <= I2CDeviceAddr & I2CWrConst;
  I2CTxData(1) <= I2CData(15 downto 8);
  I2CTxData(2) <= I2CData(7 downto 0);

  -- purpose: Generate I2C Clock
  -- type   : sequential
  -- inputs : Clk, Reset
  -- outputs: I2CClkEn
  BaudRateGen_proc : process (Clk, Reset)
  begin  -- process GenI2CClk_proc
    if Reset = '0' then                 -- asynchronous reset (active low)
      I2CClkEn       <= '0';
      BaudRateClkCnt <= 0;
    elsif Clk'event and Clk = '1' then  -- rising clock edge
      I2CClkEn <= '0';
      if BaudRateClkCnt = BaudRateClkDiv then
        I2CClkEn       <= '1';
        BaudRateClkCnt <= 0;
      else
        BaudRateClkCnt <= BaudRateClkCnt + 1;
      end if;
      if BaudRateClkCnt = 100 then
        SCL <= '1';
      elsif BaudRateClkCnt = (BaudRateClkDiv / 2) + 100 then
        SCL <= '0';
      end if;
    end if;
  end process BaudRateGen_proc;

  -- purpose: Catch a single cycle WrReq
  -- type   : sequential
  -- inputs : Clk, Reset, I2CWriteReq
  -- outputs: I2CWriteReq2
  CatchWrReq : process (Clk, Reset)
  begin  -- process CatchWrReq
    if Reset = '0' then                 -- asynchronous reset (active low)
      I2CWriteReq2 <= '0';
    elsif Clk'event and Clk = '1' then  -- rising clock edge
      if I2CWriteReq = '1' then         -- Catch a single 50MHz Req pulse
        I2CWriteReq2 <= '1';
      elsif I2CClkEn = '1' then         -- Value is used on ClkEn edge
        I2CWriteReq2 <= '0';            -- And the cleared
      end if;
    end if;
  end process CatchWrReq;


  -- purpose: FSM State Process
  -- type   : sequential
  -- inputs : clk, Reset
  -- outputs: 
  I2CCtrlStateReg : process (Clk, Reset)
  begin  -- process state_reg
    if Reset = '0' then                 -- Asynchronous reset (active low)
      I2CCtrlPresentState <= Idle;
    elsif Clk'event and Clk = '1' then  -- rising clock edge

      if I2CClkEn = '1' then            -- Run FSM at I2C Clk Speed
        I2CCtrlPresentState <= I2CCtrlNextState;
        if I2CCtrlnextState = Writing then
          BitCount <= BitCount - 1;
        else
          BitCount <= 8;
        end if;

        if I2CCtrlNextState = Ack or I2CCtrlNextState = StopWrite then
          if ByteCount = 3 then
            ByteCount <= 0;
          else
            ByteCount <= ByteCount + 1;
          end if;
        end if;

      end if;
    end if;
  end process I2CCtrlStateReg;


  I2CCtrlStateOutput_proc : process (I2CCtrlPresentState, BitCount, ByteCount, I2CTxData)
  begin  -- process AvaWrSmNxtState
    I2CWriteAck <= '0';                 -- Default Value
    SDA_out     <= '1';                 -- Default Value
    case I2CCtrlPresentState is
      when Idle =>
        SDA_dir <= '0';
        SDA_out <= '1';
--        AckError <= '0';
      when StartWrite =>
        SDA_dir <= '0';
        SDA_out <= '0';
      when Writing =>
        SDA_dir <= '0';
        SDA_out <= I2CTxData(ByteCount)(BitCount);
      when Ack =>
        SDA_dir <= '1';
--        if SDA_in = '1' then            -- Giver intet fornuftigt da den
      -- checker på den forrige værdi af SDA_in
--          AckError <= '1';
      --end if;
      when StopWrite =>
        SDA_dir     <= '0';
        SDA_out     <= '0';
        I2CWriteAck <= '1';
      when others =>
        SDA_dir <= '0';
        SDA_out <= '1';

    end case;
  end process I2CCtrlStateOutput_proc;

  I2C_SCL <= SCl when I2CCtrlPresentState = Writing or
             I2CCtrlPresentState = Ack else '1';

  I2C_SDA <= SDA_out when SDA_dir = '0' else 'Z';

  SDA_in <= I2C_SDA when SDA_dir = '1' else '1';

  -- purpose: Avalon Write Next State Process
  -- type   : combinational
  -- inputs : AvaWrState
  -- outputs: 
  I2CCtrlNxtState_proc : process (I2CCtrlPresentState, I2CWriteReq, BitCount)
  begin  -- process AvaWrSmNxtState
    case I2CCtrlPresentState is
      when Idle =>
        if I2CWriteReq2 = '1' then
          I2CCtrlNextState <= StartWrite;
        else
          I2CCtrlNextState <= Idle;
        end if;
      when StartWrite =>
        I2CCtrlNextState <= Writing;
      when Writing =>
        if BitCount = 0 then
          I2CCtrlNextState <= Ack;
        else
          I2CCtrlNextState <= Writing;
        end if;
      when Ack =>
        if ByteCount = 3 then
          I2CCtrlNextState <= StopWrite;
        else
          I2CCtrlNextState <= Writing;
        end if;
      when StopWrite =>
        I2CCtrlNextState <= Idle;
      when others =>
        I2CCtrlNextState <= Idle;
    end case;
  end process I2CCtrlNxtState_proc;
  
  
end behaviour;
