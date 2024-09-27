-- SPDX-License-Identifier: MIT
-- Copyright (c) 2024 Ross K. Snider, Trevor Vannoy.  All rights reserved.
----------------------------------------------------------------------------
-- Description:  Top level VHDL file for the DE10-Nano
----------------------------------------------------------------------------
-- Author:       Ross K. Snider, Trevor Vannoy
-- Company:      Montana State University
-- Create Date:  September 1, 2017
-- Revision:     1.0
-- License: MIT  (opensource.org/licenses/MIT)
----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library altera;
use altera.altera_primitives_components.all;

-----------------------------------------------------------
-- Signal Names are defined in the DE10-Nano User Manual
-- http://de10-nano.terasic.com
-----------------------------------------------------------
entity de10nano_top is
  port (
    ----------------------------------------
    --  Clock inputs
    --  See DE10 Nano User Manual page 23
    ----------------------------------------
    --! 50 MHz clock input #1
    fpga_clk1_50 : in    std_logic;
    --! 50 MHz clock input #2
    fpga_clk2_50 : in    std_logic;
    --! 50 MHz clock input #3
    fpga_clk3_50 : in    std_logic;

    ----------------------------------------
    --  Push button inputs (KEY)
    --  See DE10 Nano User Manual page 24
    --  The KEY push button inputs produce a '0'
    --  when pressed (asserted)
    --  and produce a '1' in the rest (non-pushed) state
    ----------------------------------------
    push_button_n : in    std_ulogic_vector(1 downto 0);

    ----------------------------------------
    --  Slide switch inputs (SW)
    --  See DE10 Nano User Manual page 25
    --  The slide switches produce a '0' when
    --  in the down position
    --  (towards the edge of the board)
    ----------------------------------------
    sw : in    std_ulogic_vector(3 downto 0);

    ----------------------------------------
    --  LED outputs
    --  See DE10 Nano User Manual page 26
    --  Setting LED to 1 will turn it on
    ----------------------------------------
    led : out   std_ulogic_vector(7 downto 0);

    ----------------------------------------
    --  GPIO expansion headers (40-pin)
    --  See DE10 Nano User Manual page 27
    --  Pin 11 = 5V supply (1A max)
    --  Pin 29 - 3.3 supply (1.5A max)
    --  Pins 12, 30 GND
    ----------------------------------------
    gpio_0 : inout std_logic_vector(35 downto 0);
    gpio_1 : inout std_logic_vector(35 downto 0);

    ----------------------------------------
    --  Arudino headers
    --  See DE10 Nano User Manual page 30
    ----------------------------------------
    arduino_io      : inout std_logic_vector(15 downto 0);
    arduino_reset_n : inout std_logic
  );
end entity de10nano_top;

architecture de10nano_arch of de10nano_top is

component led_patterns is
	generic (
		system_clock_period : time := 20 ns
	);
	port (
		clk				: in std_ulogic;
		rst				: in std_ulogic;
		push_button		: in std_ulogic;
		switches		: in std_ulogic_vector(3 downto 0);
		hps_led_control	: in boolean;
		base_period		: in unsigned(7 downto 0);
		led_reg			: in std_ulogic_vector(7 downto 0);
		led				: out std_ulogic_vector(7 downto 0)
	);
end component led_patterns;

constant system_clock_period : time := 20 ns;

begin

  -- Add VDHL code to connect the four switches (SW) to four LEDs
  --led(3 downto 0) <= sw(3 downto 0);
  --led(7 downto 4) <= "0000";
  
LED_PATTERN : component led_patterns
	generic map (
		system_clock_period => system_clock_period
		)
	port map (
		clk => fpga_clk1_50,
		rst => not push_button_n(1),
		push_button => not push_button_n(0),
		switches => sw,
		hps_led_control => false,
		base_period => "00000010",
		led_reg => "00000000",
		led => led
		);
	

end architecture de10nano_arch;
