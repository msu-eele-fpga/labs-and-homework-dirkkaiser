-- hw-10 HPS pwm wrappers
-- Dirk Kaiser 2024
-- altera vhdl_input_version vhdl_2008

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity rgb_controller_avalon is
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
red_output : out std_logic;
green_output : out std_logic;
blue_output : out std_logic
);
end entity rgb_controller_avalon;

architecture rgb_controller_avalon_arch of rgb_controller_avalon is 


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

-- creating registers
signal period_reg : std_ulogic_vector(31 downto 0) := (others => '0');
signal red_reg : std_ulogic_vector(31 downto 0) := (others => '0');
signal green_reg : std_ulogic_vector(31 downto 0) := (others => '0');
signal blue_reg : std_ulogic_vector(31 downto 0) := (others => '0');


begin


RED: component pwm_controller
	port map(
		clk	=> clk,
		rst	=> rst,
		period => unsigned(period_reg(23 downto 0)),
		duty_cycle => unsigned(red_reg(29 downto 0)),
		output => red_output
	);

GREEN: component pwm_controller
	port map(
		clk	=> clk,
		rst	=> rst,
		period => unsigned(period_reg(23 downto 0)),
		duty_cycle => unsigned(green_reg(29 downto 0)),
		output => green_output
	);
	
BLUE: component pwm_controller
	port map(
		clk	=> clk,
		rst	=> rst,
		period => unsigned(period_reg(23 downto 0)),
		duty_cycle => unsigned(blue_reg(29 downto 0)),
		output => blue_output
	);

avalon_register_read : process(clk)
	begin
		if rising_edge(clk) and avs_read = '1' then
			case avs_address is
				when "00" => avs_readdata <= red_reg;
				when "01" => avs_readdata <= green_reg;
				when "10" => avs_readdata <= blue_reg;
				when "11" => avs_readdata <= period_reg;
				when others => avs_readdata <= (others => '0');
			end case;
		end if;
	end process;
	
avalon_register_write : process(clk, rst)
	begin
		if rst = '1' then
			red_reg <= (others => '0');			
			green_reg <= (others => '0');
			blue_reg <= (others => '0');
			period_reg <= (others => '0');
		elsif rising_edge(clk) and avs_write = '1' then
			case avs_address is
				when "00" => red_reg <= avs_writedata(31 downto 0);
				when "01" => green_reg <= avs_writedata(31 downto 0);
				when "10" => blue_reg <= avs_writedata(31 downto 0);
				when "11" => period_reg <= avs_writedata(31 downto 0);
				when others => null; -- ignore writes to unused registers
			end case;
		end if;
	end process;
	
	
end architecture;