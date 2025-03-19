library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_practica1 is
  generic (
      g_sys_clock_freq_KHZ  : integer := 100e3;
      g_debounce_time 		: integer := 20;
      g_reset_value 		: std_logic := '0';
      g_number_flip_flps 	: natural := 2	
  );
  port (
      rst_n         : in std_logic;
      clk100Mhz     : in std_logic;
      BTNC          : in std_logic;
      LED           : out std_logic
  );
end top_practica1;

architecture behavioural of top_practica1 is
  component debouncer is
    generic(
        g_timeout         : integer  := 5;
        g_clock_freq_KHZ  : integer  := 100_000
    );   
    port (  
        rst_n       : in    std_logic;
        clk         : in    std_logic;
        ena         : in    std_logic;
        sig_in      : in    std_logic;
        debounced   : out   std_logic
    ); 
  end component;

  component synchronizer is
  generic (
    RESET_VALUE    : std_logic 	:= '0';
    NUM_FLIP_FLOPS : natural 	:= 2    
  );
  port(
    rst      : in std_logic;
    clk      : in std_logic;
    data_in  : in std_logic;
    data_out : out std_logic 
  );
  end component;

  -- Internal signals
  signal BTN_sync      : std_logic;
  signal Toggle_LED    : std_logic;
  signal LED_register  : std_logic;
  signal state_LED     : std_logic;

begin
  -- **Debouncer instance**
  debouncer_inst: debouncer
    generic map (
      g_timeout        => g_debounce_time, 
      g_clock_freq_KHZ => g_sys_clock_freq_KHZ
    )
    port map (
      rst_n     => rst_n,
      clk       => clk100Mhz,
      ena       => '1',
      sig_in    => BTN_sync,
      debounced => Toggle_LED
    );

  synchronizer_inst: synchronizer
    generic map (
      RESET_VALUE    => g_reset_value,
      NUM_FLIP_FLOPS => g_number_flip_flps
    )
    port map (
      rst      => rst_n,
      clk      => clk100Mhz,
      data_in  => BTNC,
      data_out => BTN_sync
    );

  registerLED: process(clk100Mhz, rst_n)
  begin
    if (rst_n = '0') then
      LED_register <= '0'; 
    elsif rising_edge(clk100Mhz) then
      LED_register <= state_LED;
    end if;
  end process;

  toggleLED: process(LED_register, Toggle_LED)
  begin 
    if Toggle_LED = '1' then
      state_LED <= LED_register xor '1';
    else
      state_LED <= LED_register;
    end if;
  end process;

  LED <= LED_register;

end behavioural;
