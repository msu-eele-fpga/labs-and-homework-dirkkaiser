-- Lab-6 HPS led pattern wrappers
-- Dirk Kaiser 2024
-- altera vhdl_input_version vhdl_2008

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity led_patterns_avalon is
port (
clk : in std_ulogic;
rst : in std_ulogic;
-- avalon memory-mapped slave interface
avs_read : in std_ulogic;
avs_write : in std_ulogic;
avs_address : in std_ulogic_vector(1 downto 0);
avs_readdata : out std_ulogic_vector(31 downto 0);
avs_writedata : in std_ulogic_vector(31 downto 0);
-- external I/O; export to top-level
push_button : in std_ulogic;
switches : in std_ulogic_vector(3 downto 0);
led : out std_ulogic_vector(7 downto 0)
);
end entity led_patterns_avalon;

architecture led_patterns_avalon_arch of led_patterns_avalon is 


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

-- creating registers
signal hps_led_control_reg : std_ulogic_vector(31 downto 0) := (others => '0');
signal base_period_reg : std_ulogic_vector(31 downto 0) := (others => '0');
signal led_reg : std_ulogic_vector(31 downto 0) := x"00000004"; -- initialize base period to 1/4 sec
signal hps_control_bool : boolean;

begin

boolean_conv : process (hps_led_control_reg)
	begin
		if  hps_led_control_reg(0) = '1' then
			hps_control_bool <= true;
		elsif hps_led_control_reg(0) = '0' then
			hps_control_bool <= false;
		end if;
	end process boolean_conv;

led_pattern : component led_patterns
	port map (
	clk => clk,
	rst => rst,
	push_button => push_button,
	switches => switches,
	hps_led_control => hps_control_bool,
	base_period => unsigned(base_period_reg(7 downto 0)),
	led_reg => led_reg(7 downto 0),
	led => led
	);


avalon_register_read : process(clk)
	begin
		if rising_edge(clk) and avs_read = '1' then
			case avs_address is
				when "00" => avs_readdata <= hps_led_control_reg;
				when "01" => avs_readdata <= base_period_reg;
				when "10" => avs_readdata <= led_reg;
				when others => avs_readdata <= (others => '0');
			end case;
		end if;
	end process;
	
avalon_register_write : process(clk, rst)
	begin
		if rst = '1' then
			hps_led_control_reg <= (others => '0');
			base_period_reg <= x"00000004";
			led_reg <= (others => '0');
		elsif rising_edge(clk) and avs_write = '1' then
			case avs_address is
				when "00" => hps_led_control_reg <= avs_writedata(31 downto 0);
				when "01" => base_period_reg <= avs_writedata(31 downto 0);
				when "10" => led_reg <= avs_writedata(31 downto 0);
				when others => null; -- ignore writes to unused registers
			end case;
		end if;
	end process;
	
	
end architecture;