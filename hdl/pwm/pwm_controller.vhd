library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_controller is
	generic (
		CLK_PERIOD : time := 20 ns
	);
	port (
		clk : in std_logic;
		rst : in std_logic;
		-- PWM repetition period in milliseconds;
		-- datatype (W.F) is individually assigned
		-- My assigned data type for period is 24.18
		period : in unsigned(24 - 1 downto 0);
		-- PWM duty cycle between [0 1]; out-of-range values are hard-limited
		-- datatype (W.F) is individually assigned
		-- My assigned data type for duty cycle is 30.29
		duty_cycle : in unsigned(30 - 1 downto 0);
		output : out std_logic
	);
end entity pwm_controller;

architecture pwm_controller_arch of pwm_controller is


constant clk_freq_ms : unsigned(15 downto 0) := to_unsigned(0.001 sec / CLK_PERIOD, 16);
signal period_limit : unsigned(39 downto 0); -- 6 integer bits from period 16 from clock freq
signal period_cnt : integer;

signal duty_limit : unsigned(69 downto 0); -- 1 integer bit from duty 21 from period limitg
signal duty_cnt : integer;

begin

	period_limit <= clk_freq_ms * period;
	
	duty_limit <= period_limit * duty_cycle;
	
	process (clk, rst)
		begin
			if (rst = '1') then
			period_cnt <= 0;
			duty_cnt <= 0;
			output <= '1';
			elsif (rising_edge(clk)) then
			if (period_cnt < period_limit(39 downto 18)) then
				period_cnt <= period_cnt + 1;
				if (duty_cnt < duty_limit(69 downto 47)) then
					duty_cnt <= duty_cnt + 1;
				else
					output <= '0';
				end if;
			else
				period_cnt <= 0;
				duty_cnt <= 0;
				output <= '1';
			end if;
		end if;
	end process;
	
	

end architecture;