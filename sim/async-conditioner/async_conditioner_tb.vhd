-- HW 6 Async Signal Conditioner Test Bench
-- Dirk Kaiser 2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity async_conditioner_tb is
end entity;

architecture testbench of async_conditioner_tb is


-- Constant Declaration ----------------------------------------------------

constant BOUNCE_PERIOD : time := 1000 ns;
constant DEBOUNCE_TIME : time := 100 ns; -- hard coded in async_conditioner make same here
-- just bringing over for Trevor's bounce stimuli
constant CLK_PERIOD : time := 20 ns; -- again I'm hard coding this cause I don't think it's worth the effort to do all the generics
constant DEBOUNCE_CYCLES     : natural := DEBOUNCE_TIME / BOUNCE_PERIOD;
constant DEBOUNCE_CLK_CYCLES : natural := DEBOUNCE_TIME / CLK_PERIOD;

----------------------------------------------------------------------------
-- Trevor's bounce signal generator
  procedure bounce_signal (
    signal bounce          : out std_ulogic;
    constant BOUNCE_PERIOD : time;
    constant BOUNCE_CYCLES : natural;
    constant FINAL_VALUE   : std_ulogic
  ) is

    -- If BOUNCE_CYCLES is not an integer multiple of 4, the division
    -- operation will only return the integer part (i.e., perform a floor
    -- operation). Thus, we need to calculate how many cycles are remaining
    -- after waiting for 3 * BOUNCE_CYCLES_BY_4 BOUNCE_PERIODs. If BOUNCE_CYCLES
    -- is an integer multiple of 4, then REMAINING_CYCLES will be equal to
    -- BOUNCE_CYCLES_BY_4.
    constant BOUNCE_CYCLES_BY_4 : natural := BOUNCE_CYCLES / 4;
    constant REMAINING_CYCLES   : natural := BOUNCE_CYCLES - (3 * BOUNCE_CYCLES_BY_4);

  begin

    -- Toggle the bouncing input quickly for ~1/4 of the debounce time
    for i in 1 to BOUNCE_CYCLES_BY_4 loop
      bounce <= not bounce;
      wait for BOUNCE_PERIOD;
    end loop;

    -- Toggle the bouncing input slowly for ~1/2 of the debounce time
    for i in 1 to BOUNCE_CYCLES_BY_4 loop
      bounce <= not bounce;
      wait for 2 * BOUNCE_PERIOD;
    end loop;

    -- Settle at the final value for the rest of the debounce time
    bounce <= FINAL_VALUE;
    wait for REMAINING_CYCLES * BOUNCE_PERIOD;

  end procedure bounce_signal;

--Signal Declaration--------------------------------------------------------

  signal clk_tb     : std_ulogic := '0';
  signal rst_tb     : std_ulogic := '0';
  signal bouncer_tb : std_ulogic := '0';
  signal output_tb 	: std_ulogic := '0';
  signal expected	: std_ulogic;

begin

	DUT : entity work.async_conditioner
		port map (
		clk	=> clk_tb,
		rst	=> rst_tb,
		async => bouncer_tb,
		sync => output_tb
		);

	clk_gen : process is
	begin

		clk_tb <= not clk_tb;
		wait for CLK_PERIOD / 2;

	end process clk_gen;
  
	-- Stimuli Generator based off of Trevor's debouncer_tb stimuli
	stimuli_generator : process is
	begin
		wait for CLK_PERIOD;
		-- Reset at the beginning of the test
		rst_tb <= '1', '0' after 50 ns;

		-- Let the input sit low for a while
		wait_for_clock_edges(clk_tb, 20);

		-- Transition the bouncing signal on the falling edges of the clock
		wait for CLK_PERIOD / 2;

		-- Press the button
		bounce_signal(bouncer_tb, BOUNCE_PERIOD, DEBOUNCE_CYCLES, '1');

		-- Hold the button for an extra debounce time
		wait_for_clock_edges(clk_tb, DEBOUNCE_CLK_CYCLES);

		-- Transition the bouncing signal on the falling edges of the clock
		wait for CLK_PERIOD / 2;

		-- Release the button
		bounce_signal(bouncer_tb, BOUNCE_PERIOD, DEBOUNCE_CYCLES, '0');

		-- Keep the button unpressed for an extra debounce time
		wait_for_clock_edges(clk_tb, DEBOUNCE_CLK_CYCLES);

		-- Transition the bouncing signal on the falling edges of the clock
		wait for CLK_PERIOD / 2;

		-- Press the button again, but release it right after the deboucne time
		-- is up; this makes sure the debouncer is not debouncing for longer than
		-- it is supposed to.
		bounce_signal(bouncer_tb, BOUNCE_PERIOD, DEBOUNCE_CYCLES, '1');
		bounce_signal(bouncer_tb, BOUNCE_PERIOD, DEBOUNCE_CYCLES, '0');

		-- Wait a few clock cycles to allow for the release debounce time to be done
		wait_for_clock_edges(clk_tb, 10);


	end process stimuli_generator;
	
	EXPECTED_OUTPUT : process is
	begin
	expected <= 'U';
	wait for CLK_PERIOD;
	expected <= '0';
	wait for 23 * CLK_PERIOD;
	
	expected <= '1';
	wait for CLK_PERIOD;
	
	expected <= '0';
		
	wait;
		
	end process;
	
	check_output : process is

    variable failed : boolean := false;

	begin

    for i in 0 to 30 loop

      assert expected = output_tb
        report "Error for clock cycle " & to_string(i) & ":" & LF & "output_tb = " & to_string(output_tb) & " expected  = " & to_string(expected)
        severity warning;

      if expected /= output_tb then
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

end testbench;