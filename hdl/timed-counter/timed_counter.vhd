library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity timed_counter is
generic (
clk_period : time;
count_time : time
);
port (
clk : in std_ulogic;
enable : in boolean;
done : out boolean
);
end entity timed_counter;

architecture timed_counter_arch of timed_counter is

constant COUNTER_LIMIT : integer := (count_time/clk_period); -- constant for max number of counts
signal count : natural := 0; -- count signal

begin

COUNTER : process(clk) -- clk sensitivity list
begin
	if(rising_edge(clk)) then -- on clock edge
		if(enable) then
				if count < COUNTER_LIMIT - 1 then
					count <= count + 1; -- count up if not at max and enable is true
					done <= false;
				else
					count <= 0;
					done <= true;
				end if;
		else
			count <= 0;
			done <= false;
		end if;
	end if;
end process COUNTER;
			

end architecture;