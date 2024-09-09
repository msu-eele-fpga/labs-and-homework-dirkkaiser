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
constant COUNTER_LIMIT : integer := (count_time/clk_period);
signal count : natural := 0;

begin

	if enable then
			if count_iter < COUNTER_LIMIT - 1 then
				assert_false(done, "counter not done");
				count <= count + 1;
			else
				assert_true(done, "counter is done");
				count <= 0;
			end if;
		else
			assert_false(done, "counter not enabled");
			count <= 0;
		end if;

end architecture;