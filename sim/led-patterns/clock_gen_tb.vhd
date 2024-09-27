-- Lab 4 clock gen testbench
-- Dirk Kaiser 2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_gen_tb is
end entity clock_gen_tb;

architecture testbench of clock_gen_tb is

	constant CLK_PERIOD : time := 20 ns;

	component clock_gen is
		generic (
			system_clock_period : time := 20 ns
		);
		port (
			clk			: in std_ulogic;
			rst			: in std_ulogic;
			base_period	: in unsigned(7 downto 0);
			base_clk	: out std_ulogic;
			div2		: out std_ulogic;
			div4		: out std_ulogic;
			mult2		: out std_ulogic;
			div8		: out std_ulogic;
			choice		: out std_ulogic
		);
	end component clock_gen;
	
	signal clk_tb : std_ulogic := '0';
	signal rst_tb : std_ulogic := '0';
	signal base_period_tb : unsigned(7 downto 0);
	signal base_clk_tb : std_ulogic;
	signal div2_tb	: std_ulogic;
	signal div4_tb	: std_ulogic;
	signal mult2_tb : std_ulogic;
	signal div8_tb	: std_ulogic;
	signal choice_tb : std_ulogic;
	

begin

	DUT: component clock_gen
		generic map (
			system_clock_period => CLK_PERIOD
		)
		port map(
			clk	=> clk_tb,
			rst	=> rst_tb,
			base_period	=> base_period_tb,
			base_clk => base_clk_tb,
			div2 => div2_tb,
			div4 => div4_tb,
			mult2 => mult2_tb,
			div8 => div8_tb,
			choice => choice_tb
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
		
		base_period_tb <= "00010000"; -- asigning base period to 1 second (4 integer 4 fractional)
		wait;
	end process STIM;
		
end architecture testbench;
