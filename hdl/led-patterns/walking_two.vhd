-- Lab 4 7-bit walking two
-- Dirk Kaiser 2024

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity walking_two is
	port (
		clk, rst	: in std_ulogic;
		walking_out		: out std_ulogic_vector(6 downto 0)
	);
end entity;

architecture walking_two_arch of walking_two is

type State_Type is (S0, S1, S2, S3, S4, S5, S6, S7);
signal current_state, next_state	: State_Type;

begin

STATE_MEMORY: process(clk, rst)
	begin
		if (rst = '1') then
			current_state <= S0;
		elsif(rising_edge(clk)) then
			current_state <= next_state;
		end if;
	end process;

NEXT_STATE_LOGIC: process(current_state)
	begin
		case(current_state) is
			when S0 => next_state <= S1;
			when S1 => next_state <= S2;
			when S2 => next_state <= S3;
			when S3 => next_state <= S4;
			when S4 => next_state <= S5;
			when S5 => next_state <= S6;
			when S6 => next_state <= S0;
			when others => next_state <= S0;
		end case;
	end process;
	

OUTPUT_LOGIC: process(current_state)
begin
	case(current_state) is
		when S0 => walking_out <= "1100000";
		when S1 => walking_out <= "0110000";
		when S2 => walking_out <= "0011000";
		when S3 => walking_out <= "0001100";
		when S4 => walking_out <= "0000110";
		when S5 => walking_out <= "0000011";
		when S6 => walking_out <= "1000001";
		when others => walking_out <= "0000000";
	end case;
end process;

end architecture;