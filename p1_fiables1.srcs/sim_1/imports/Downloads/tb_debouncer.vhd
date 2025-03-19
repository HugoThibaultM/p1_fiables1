library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_debouncer is
end tb_debouncer;

architecture testBench of tb_debouncer is
  component debouncer is
    generic(
        g_timeout          : integer   := 5; 
        g_clock_freq_KHZ   : integer   := 100_000 
    );   
    port (  
        rst_n       : in    std_logic;
        clk         : in    std_logic;
        ena         : in    std_logic;
        sig_in      : in    std_logic;
        debounced   : out   std_logic
    ); 
  end component;
  
  constant timer_debounce : integer := 10;
  constant freq : integer := 100_000;
  constant clk_period : time := (1 ms/ freq);
  -- Inputs 
  signal  rst_n       :   std_logic := '0';
  signal  clk         :   std_logic := '0';
  signal  ena         :   std_logic := '1';
  signal  BTN_sync      :   std_logic := '0';
  signal  debounced   :   std_logic;
   
begin
  UUT: debouncer
    generic map (
      g_timeout        => timer_debounce,
      g_clock_freq_KHZ => freq
    )
    port map (
      rst_n     => rst_n,
      clk       => clk,
      ena       => ena,
      sig_in    => BTN_sync,
      debounced => debounced
    );
  clk <= not clk after clk_period/2;
  process is 
  begin
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    rst_n <= '1';
    
    wait for 50 ns;
    wait until rising_edge(clk);
    BTN_sync <='1';
    wait for 100 ns;
    wait until rising_edge(clk);
    BTN_sync <= '0';
    wait for 100 ns;
    wait until rising_edge(clk);
    BTN_sync <='1';
    wait for 20 ms;
    wait until rising_edge(clk);
    BTN_sync <='0';
  end process;
end testBench;
