library ieee;
use ieee.std_logic_1164.all;

entity synchronizer is
  generic (
    RESET_VALUE    : std_logic := '0';
    NUM_FLIP_FLOPS : natural := 2
  );
  port(
    rst      : in std_logic;
    clk      : in std_logic;
    data_in  : in std_logic;
    data_out : out std_logic
  );
end synchronizer;

architecture arch of synchronizer is

  --synchronizer chain of flip-flops
  signal sync_chain : std_logic_vector(NUM_FLIP_FLOPS-1 downto 0) := (others => RESET_VALUE);

  -- Xilinx XST: disable shift-register LUT (SRL) extraction
  attribute shreg_extract : string;
  attribute shreg_extract of sync_chain : signal is "no";

  -- Vivado: set ASYNC_REG to specify registers receive asynchronous data
  -- also acts as DONT_TOUCH
  attribute ASYNC_REG : string;
  attribute ASYNC_REG of sync_chain : signal is "TRUE";

begin

  main : process(clk, rst)
  begin
    if rst = '0' then
      sync_chain <= (others => RESET_VALUE);
    elsif rising_edge(clk) then
      sync_chain <= sync_chain(sync_chain'high-1 downto 0) & data_in;
    end if;
  end process;

  data_out <= sync_chain(sync_chain'high);

end architecture;