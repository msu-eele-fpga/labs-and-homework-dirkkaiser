-- Lab 4 clock gen for led patterns
-- Dirk Kaiser 2024

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_gen is
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
end entity;
	
architecture clock_gen_arch of clock_gen is

constant clk_freq : unsigned(25 downto 0) := to_unsigned(0.5 sec / system_clock_period, 26); -- I want my clk to toggle at half the period
--constant clk_freq : unsigned(25 downto 0) := "00000000000000000000001000";
signal count_limit : unsigned(29 downto 0); -- 8 bits from base_period 26 from clock freq
signal count_limit_int : integer;
signal count_int : integer;

signal div2_limit_int : integer;
signal div2_int : integer;

signal div4_limit_int : integer;
signal div4_int : integer;

signal mult2_limit_int : integer;
signal mult2_int : integer;

signal div8_limit_int : integer;
signal div8_int : integer;

signal choice_limit_int : integer;
signal choice_int : integer;

signal internal_base : std_ulogic := '0';
signal internal_div2 : std_ulogic := '0';
signal internal_div4 : std_ulogic := '0';
signal internal_mult2 : std_ulogic := '0';
signal internal_div8 : std_ulogic := '0';
signal internal_choice : std_ulogic := '0';

begin

	count_limit <= clk_freq(25 downto 4) * base_period;
	count_limit_int <= to_integer(count_limit);

	BASE_CLOCK : process (clk, rst)
		begin
			if (rst = '1') then
			count_int <= 0;
			internal_base <= '0';
		elsif (rising_edge(clk)) then
			if (count_int < count_limit_int) then
				count_int <= count_int + 1;
			else
				internal_base <= not internal_base;
				count_int <= 0;
			end if;
		end if;
	end process;
	
	div2_limit_int <= to_integer(shift_right(count_limit, 1));

	DIVIDE_BY_2 : process (clk, rst)
		begin
			if (rst = '1') then
			div2_int <= 0;
			internal_div2 <= '0';
		elsif (rising_edge(clk)) then
			if (div2_int < div2_limit_int) then
				div2_int <= div2_int + 1;
			else
				internal_div2 <= not internal_div2;
				div2_int <= 0;
			end if;
		end if;
	end process;

	div4_limit_int <= to_integer(shift_right(count_limit, 2));

	DIVIDE_BY_4 : process (clk, rst)
		begin
			if (rst = '1') then
			div4_int <= 0;
			internal_div4 <= '0';
		elsif (rising_edge(clk)) then
			if (div4_int < div4_limit_int) then
				div4_int <= div4_int + 1;
			else
				internal_div4 <= not internal_div4;
				div4_int <= 0;
			end if;
		end if;
	end process;
	
	mult2_limit_int <= to_integer(shift_left(count_limit, 1));

	MULTIPY_BY_2 : process (clk, rst)
		begin
			if (rst = '1') then
			mult2_int <= 0;
			internal_mult2 <= '0';
		elsif (rising_edge(clk)) then
			if (mult2_int < mult2_limit_int) then
				mult2_int <= mult2_int + 1;
			else
				internal_mult2 <= not internal_mult2;
				mult2_int <= 0;
			end if;
		end if;
	end process;

	div8_limit_int <= to_integer(shift_right(count_limit, 3));

	DIVIDE_BY_8 : process (clk, rst)
		begin
			if (rst = '1') then
			div8_int <= 0;
			internal_div8 <= '0';
		elsif (rising_edge(clk)) then
			if (div8_int < div8_limit_int) then
				div8_int <= div8_int + 1;
			else
				internal_div8 <= not internal_div8;
				div8_int <= 0;
			end if;
		end if;
	end process;

	choice_limit_int <= to_integer(shift_left(count_limit, 2));
	-- for my choice clock division I am choosing a multiply by 4

	CHOICE_BY_4 : process (clk, rst)
		begin
			if (rst = '1') then
			choice_int <= 0;
			internal_choice <= '0';
		elsif (rising_edge(clk)) then
			if (choice_int < choice_limit_int) then
				choice_int <= choice_int + 1;
			else
				internal_choice <= not internal_choice;
				choice_int <= 0;
			end if;
		end if;
	end process;
	
	base_clk <= internal_base;
	div2 <= internal_div2;
	div4 <= internal_div4;
	mult2 <= internal_mult2;
	div8 <= internal_div8;
	choice <= internal_choice;
	
end architecture;

