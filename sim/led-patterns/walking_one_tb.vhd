-- Lab 4 walking one testbench
-- Dirk Kaiser 2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity	walking_one_tb is
end entity walking_one_tb;

architecture testbench of walking_one_tb is

	constant CLK_PERIOD : time := 20 ns;

	component walking_one is
		port (
			clk			: in std_ulogic;
			rst			: in std_ulogic;
			walking_out	: out std_ulogic_vector(6 downto 0)
		);
	end component walking_one;
	
	signal clk_tb : std_ulogic := '0';
	signal rst_tb : std_ulogic := '0';
	signal walking_out_tb : std_ulogic_vector(6 downto 0);


begin

	DUT: component walking_one
		port map(
			clk	=> clk_tb,
			rst	=> rst_tb,
			walking_out => walking_out_tb
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
