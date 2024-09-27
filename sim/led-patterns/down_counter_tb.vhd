-- Lab 4 7-bit down counter testbench
-- Dirk Kaiser 2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity down_counter_tb is
end entity down_counter_tb;

architecture testbench of down_counter_tb is

	constant CLK_PERIOD : time := 20 ns;

	component down_counter is
		port (
			clk			: in std_ulogic;
			rst			: in std_ulogic;
			count_out	: out std_ulogic_vector(6 downto 0)
		);
	end component down_counter;
	
	signal clk_tb : std_ulogic := '0';
	signal rst_tb : std_ulogic := '0';
	signal count_out_tb : std_ulogic_vector(6 downto 0);


begin

	DUT: component down_counter
		port map(
			clk	=> clk_tb,
			rst	=> rst_tb,
			count_out => count_out_tb
		);
		
	  clk_gen : process is
	  begin

		clk_tb <= not clk_tb;
		wait for CLK_PERIOD / 2;

	  end process clk_gen;

	STIM : process is
	begin
		rst_tb <= '1';
		wait for 2*CLK_PERIOD;
		rst_tb <= '0';
		wait;

	end process STIM;
		
end architecture testbench;
