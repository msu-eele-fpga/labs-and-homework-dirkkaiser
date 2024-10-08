-- Lab-4 led pattern generator
-- Dirk Kaiser 2024
-- altera vhdl_input_version vhdl_2008

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_patterns is
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
end entity led_patterns;

architecture led_patterns_arch of led_patterns is

type State_Type is (S0, S1, S2, S3, S4, disp);
signal state, prev_state : State_Type;

constant clk_freq : unsigned(25 downto 0) := to_unsigned(1 sec / system_clock_period, 26); -- delay 1 sec counter number thing

-- Component Declarations --
component async_conditioner is
	port (
		clk		: in std_ulogic;
		rst		: in std_ulogic;
		async	: in std_ulogic;
		sync	: out std_ulogic
		);
end component async_conditioner;

component clock_gen is
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
end component clock_gen;
	
component up_counter is
	port (
		clk, rst	: in std_ulogic;
		count_out		: out std_ulogic_vector(6 downto 0)
	);
end component up_counter;

component down_counter is
	port (
		clk, rst	: in std_ulogic;
		count_out		: out std_ulogic_vector(6 downto 0)
	);
end component down_counter;

component walking_one is
	port (
		clk, rst	: in std_ulogic;
		walking_out		: out std_ulogic_vector(6 downto 0)
	);
end component walking_one;

component walking_two is
	port (
		clk, rst	: in std_ulogic;
		walking_out		: out std_ulogic_vector(6 downto 0)
	);
end component walking_two;

component flash is
	port (
		clk, rst	: in std_ulogic;
		flash_out		: out std_ulogic_vector(6 downto 0)
	);
end component flash;


-- Signal Declearations --
-- pushbutton signal
signal pb : std_ulogic;

-- signal for output of clk gen
signal base_clk : std_ulogic;
signal pat_0_clk : std_ulogic;
signal pat_1_clk : std_ulogic;
signal pat_2_clk : std_ulogic;
signal pat_3_clk : std_ulogic;
signal pat_4_clk : std_ulogic;

-- signal for output of pattern gen
signal pat_0 : std_ulogic_vector(6 downto 0);
signal pat_1 : std_ulogic_vector(6 downto 0);
signal pat_2 : std_ulogic_vector(6 downto 0);
signal pat_3 : std_ulogic_vector(6 downto 0);
signal pat_4 : std_ulogic_vector(6 downto 0);

-- signal for state machine output
signal sm_out : std_ulogic_vector(6 downto 0);
-- count signal
signal count_int : integer := 0;

begin

CONDITIONER : component async_conditioner
	port map (
		clk => clk,
		rst => rst,
		async => push_button,
		sync => pb
		);
	
CLK_GEN : component clock_gen
	generic map (
		system_clock_period => system_clock_period
		)
	port map (
		clk => clk,
		rst => rst,
		base_period => base_period,
		base_clk => base_clk,
		div2 => pat_0_clk,
		div4 => pat_1_clk,
		mult2 => pat_2_clk,
		div8 => pat_3_clk,
		choice => pat_4_clk
		);		
	
PATTERN0 : component walking_one
	port map (
		clk => pat_0_clk,
		rst => rst,
		walking_out => pat_0
		);
		
PATTERN1 : component walking_two
	port map (
		clk => pat_1_clk,
		rst => rst,
		walking_out => pat_1
		);
		
PATTERN2 : component up_counter
	port map (
		clk => pat_2_clk,
		rst => rst,
		count_out => pat_2
		);

PATTERN3 : component down_counter
	port map (
		clk => pat_3_clk,
		rst => rst,
		count_out => pat_3
		);
		
PATTERN4 : component flash
	port map (
		clk => pat_4_clk,
		rst => rst,
		flash_out => pat_4
		);

--------------------------------- Pattern State Machine ---------------------------------------
  -- combinational
  state_logic : process(clk, rst)
  begin
    if rst = '1' then
      state <= S0;
    elsif rising_edge(clk) then
      case state is
        when S0 =>
		  prev_state <= S0;
		  if pb = '1' then
          state <= disp;
		  else
          state <= S0;
		  end if;
        when S1 =>
		  prev_state <= S1;
		  if pb = '1' then
          state <= disp;
		  else
          state <= S1;
		  end if;
         when S2 =>
		  prev_state <= S2;
		  if pb = '1' then
          state <= disp;
		  else
          state <= S2;
		  end if;
        when S3 =>
		  prev_state <= S3;
		  if pb = '1' then
          state <= disp;
		  else
          state <= S3;
		  end if;
        when S4 =>
		  prev_state <= S4;
		  if pb = '1' then
          state <= disp;
		  else
          state <= S4;
		  end if;
		when disp =>
			if (count_int < to_integer(clk_freq)) then
				count_int <= count_int + 1;
			else
				case switches is
				when "0000" => state <= S0;
				when "0001" => state <= S1;
				when "0010" => state <= S2;
				when "0011" => state <= S3;
				when "0100" => state <= S4;
				when others => state <= prev_state ;
				end case;
				count_int <= 0;
			end if;
        when others =>
          state <= S0;
      end case;
    end if;
  end process state_logic;
		
output_logic : process (all)
begin
	case(state) is
		when disp =>
			sm_out <= "000" & switches;
		when S0 =>
			sm_out <= pat_0;
		when S1 =>
			sm_out <= pat_1;
		when S2 =>
			sm_out <= pat_2;
		when S3 =>
			sm_out <= pat_3;
		when S4 =>
			sm_out <= pat_4;
		when others =>
			sm_out <= "0000000";
	end case;
end process output_logic;
----------------------------------------------------------------

led(7) <= base_clk;
led(6 downto 0) <= led_reg(6 downto 0) when hps_led_control else sm_out;

end architecture;