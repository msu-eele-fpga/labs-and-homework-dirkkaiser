-- Lab 4 flashing pattern
-- Dirk Kaiser 2024

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity flash is
	port (
		clk, rst	: in std_ulogic;
		flash_out		: out std_ulogic_vector(6 downto 0)
	);
end entity;

architecture flash_arch of flash is

signal flash_reg : std_ulogic_vector(6 downto 0);

begin

	process(clk, rst)
	begin
		if (rst = '1') then
			flash_reg <= "0000000";
		elsif (rising_edge(clk)) then
			flash_reg <= not flash_reg;
		end if;
	end process;
	
flash_out <= flash_reg;

end architecture;