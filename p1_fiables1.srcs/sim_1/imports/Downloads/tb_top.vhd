library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_top is 
end tb_top;

architecture testBench of tb_top is
  component top_practica1 is
  port (
      rst_n         : in std_logic;
      clk100Mhz     : in std_logic;
      BTNC           : in std_logic;
      LED           : out std_logic
  );
end component;

  constant timer_debounce : integer := 10;
  constant freq : integer := 100_000;
  constant clk_period : time := (1 ms/ freq);

  signal  rst_n       :   std_logic := '0';
  signal  clk         :   std_logic := '0';
  signal  BTN     :   std_logic := '0';
  signal  LED   :   std_logic;

begin
  UUT: top_practica1
    port map (
      rst_n     => rst_n,
      clk100Mhz => clk,
      BTNC       => BTN,
      LED       => LED
    );
    clk <= not clk after clk_period/2;
  process is 
  begin
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    rst_n <= '1';
    
    wait for 13 ns;
    
    BTN <='1';
    wait for 235 ns;
    
    BTN <= '0';
    wait for 166 ns;
    
    BTN <='1';
    wait for 20 ms;
    
    BTN <='0';
  end process;
end testBench;