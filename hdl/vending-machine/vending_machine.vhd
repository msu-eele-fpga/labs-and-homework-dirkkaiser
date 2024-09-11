library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vending_machine is
port (
clk : in std_ulogic;
rst : in std_ulogic;
nickel : in std_ulogic;
dime : in std_ulogic;
dispense : out std_ulogic;
amount : out natural range 0 to 15
);
end entity vending_machine;

architecture vending_machine_arch of vending_machine is

    type State_Type is (c0, c5, c10, c15);
    signal current_state, next_state : State_Type;

    begin

	STATE_MEMORY : process (clk, rst)
	    begin
		if (rst = '1') then
			current_state <= c0;
		elsif (rising_edge(clk)) then
			current_state <= next_state;
		end if;
	end process STATE_MEMORY;
-------------------------------------------------------------------
	
	NEXT_STATE_LOGIC : process (nickel, dime, current_state)
	    begin
		case (current_state) is
		    when c0 =>  if  (dime = '1') then
				    next_state <= c10;
				elsif (nickel = '1') then
				    next_state <= c5;
				else
					next_state <= current_state;
				end if;
		    when c5 =>  if  (dime = '1') then
				    next_state <= c15;
				elsif (nickel = '1') then
				    next_state <= c10;
				else
					next_state <= current_state;
				end if;
		    when c10 =>  if  (dime = '1') then
				    next_state <= c15; -- machine does not give change
				elsif (nickel = '1') then
				    next_state <= c15;
				else
					next_state <= current_state;
				end if;
		    when c15 => 
				    next_state <= c0;
		    when others => next_state <= c0;
		end case;
	end process NEXT_STATE_LOGIC;
-------------------------------------------------------------

	OUTPUT_LOGIC : process(current_state)
	    begin
		case (current_state) is
		    when c0 =>  
				dispense <= '0';
				amount <= 0;
		    when c5 =>  
				dispense <= '0';
				amount <= 5;
		    when c10 =>  
				dispense <= '0';
				amount <= 10;
		    when c15 =>  
				dispense <= '1';
				amount <= 15;
		    when others => 
				dispense <= '0';
				amount <= 0;
		end case;
	end process OUTPUT_LOGIC;
	
end architecture vending_machine_arch;
