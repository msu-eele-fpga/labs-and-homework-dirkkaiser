-- Lab 4 clock gen testbench
-- Dirk Kaiser 2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_controller_tb is
end entity pwm_controller_tb;

architecture testbench of pwm_controller_tb is

	constant CLK_PERIOD : time := 20 ns;

	component pwm_controller is
		generic (
			CLK_PERIOD : time := 20 ns
		);
		port (
			clk			: in std_ulogic;
			rst			: in std_ulogic;
			period		: in unsigned(23 downto 0);
			duty_cycle	: in unsigned(29 downto 0);
			output		: out std_ulogic
		);
	end component pwm_controller;
	
	signal clk_tb : std_ulogic := '0';
	signal rst_tb : std_ulogic := '0';
	signal period_tb : unsigned(23 downto 0);
	signal duty_cycle_tb : unsigned(29 downto 0);
	signal output_tb : std_ulogic;


begin

	DUT: component pwm_controller
		generic map (
			CLK_PERIOD => CLK_PERIOD
		)
		port map(
			clk	=> clk_tb,
			rst	=> rst_tb,
			period => period_tb,
			duty_cycle => duty_cycle_tb,
			output => output_tb
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
		
		period_tb <= "000001000000000000000000"; -- asigning period to 1 ms (6 integer 18 fractional)
		duty_cycle_tb <= "010000000000000000000000000000"; -- asigning duty cycle to 50%
		
		wait for 100000*CLK_PERIOD;
		
		duty_cycle_tb <= "001000000000000000000000000000"; -- asigning duty cycle to 50%
		
		wait for 100000*CLK_PERIOD;
		
		duty_cycle_tb <= "000100000000000000000000000000"; -- asigning duty cycle to 50%
		wait;
	end process STIM;
		
end architecture testbench;
