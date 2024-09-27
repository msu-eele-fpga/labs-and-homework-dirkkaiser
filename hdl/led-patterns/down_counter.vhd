-- Lab 4 7-bit down counter
-- Dirk Kaiser 2024

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity down_counter is
	port (
		clk, rst	: in std_ulogic;
		count_out		: out std_ulogic_vector(6 downto 0)
	);
end entity;

architecture down_counter_arch of down_counter is

	signal count_int : integer; 

begin

	DOWN_COUNT : process (clk, rst)
	begin
		if (rst = '1') then
			count_int <= 0;
		elsif (rising_edge(clk)) then
			count_int <= count_int - 1;
		end if;
	end process;

	count_out <= std_ulogic_vector(to_signed(count_int, 7));

end architecture;