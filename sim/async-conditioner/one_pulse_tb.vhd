-- HW 6 One Pulse Test Bench
-- Dirk Kaiser 2024

library ieee;
use ieee.std_logic_1164.all;

entity one_pulse_tb is
end entity one_pulse_tb;

architecture testbench of one_pulse_tb is

  constant CLK_PERIOD : time := 20 ns;

  component one_pulse is
    port (
		clk		: in std_ulogic;
		rst		: in std_ulogic;
		input	: in std_ulogic;
		pulse 	: out std_ulogic
		);
  end component one_pulse;

  signal clk_tb        	: std_ulogic := '0';
  signal rst_tb      	: std_ulogic := '0';
  signal input_tb       : std_ulogic := '0';
  signal pulse_tb		: std_ulogic := '0';
  signal pulse_expected : std_ulogic;

begin

  dut : component one_pulse
    port map (
      clk   => clk_tb,
      rst => rst_tb,
      input  => input_tb,
	  pulse => pulse_tb
    );

  clk_gen : process is
  begin

    clk_tb <= not clk_tb;
    wait for CLK_PERIOD / 2;

  end process clk_gen;


  input_stim : process is
  begin
	
	input_tb <= '0';
		
	rst_tb <= '1';
	wait for CLK_PERIOD;
	
	rst_tb <= '0';
	wait for 1 * CLK_PERIOD;

	-- Test Case 1: input is one clock cycle
    input_tb <= '1';
    wait for 1 * CLK_PERIOD;

    input_tb <= '0';
    wait for 2 * CLK_PERIOD;
	
	-- Test Case 2: input is held high
	input_tb <= '1';
    wait;

  end process input_stim;
  

-- Create the expected pulsed output waveform
  expected_pulse : process is
  begin


    pulse_expected <= '0';
    wait for 2 * CLK_PERIOD;

    pulse_expected <= '1';
    wait for 1 * CLK_PERIOD;

    pulse_expected <= '0';
    wait for 2 * CLK_PERIOD;

    pulse_expected <= '1';
	wait for 1 * CLK_PERIOD;
	
	pulse_expected <= '0';

    wait;

  end process expected_pulse;

  check_output : process is

    variable failed : boolean := false;

  begin

    for i in 0 to 9 loop

      assert pulse_expected = pulse_tb
        report "Error for clock cycle " & to_string(i) & ":" & LF & "pulse_tb = " & to_string(pulse_tb) & " pulse_expected  = " & to_string(pulse_expected)
        severity warning;

      if pulse_expected /= pulse_tb then
        failed := true;
      end if;

      wait for CLK_PERIOD;

    end loop;

    if failed then
      report "tests failed!"
        severity failure;
    else
      report "all tests passed!";
    end if;

    std.env.finish;

  end process check_output;

end architecture testbench;
