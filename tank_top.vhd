library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.ALL;

entity Tank_top_position is
	port( 
	hist0 : in std_logic_vector(7 downto 0);
	clk : in std_logic;
	rst_n : in std_logic;
	--tank outputs
	tank_topx : out integer
	);
end entity Tank_top_position;


architecture behavioral of Tank_top_position is
signal direction_c : integer := 0; -- 1 to the right, 0 to the left;
signal direction_top_c : integer := 0;
signal tank_topx_c : integer := 587;
signal tank_offset_c : integer := 50;
signal clock_counter : integer := 0;
signal clock_divide_top: integer := 250000;
signal clock_divide_top_c: integer := 250000;

begin

	tankTopSpeed : process( hist0, rst_n ) 
	begin  
		case( hist0 ) is 
			when x"3B" => 
				clock_divide_top_c <= 750000;
			when x"42" => 
				clock_divide_top_c <= 400000;
			when x"4B" => 
				clock_divide_top_c <= 150000;
				--bullet_fired <= 1;
			when others => clock_divide_top_c <= clock_divide_top;
								--bullet_fired <= 0;
			end case ;
		if (rst_n = '0') then
			clock_divide_top_c <= 400000;
		end if;
	end process ; 

	tanktopClocked : process(clk, rst_n) is
	
	begin
	
	if (rising_edge(clk)) then
		clock_divide_top <= clock_divide_top_c;
		if (clock_counter < 50000000) then
				clock_counter <= clock_counter + 1;
		else
			clock_counter <= 0;
		end if;
		if (rst_n = '0') then
			tank_topx_c <= 587;
		else
			tank_topx_c <= tank_topx_c;
		end if;
		if (clock_counter mod clock_divide_top = 0) then
			if (tank_topx_c+tank_offset_c < 639 and direction_c = 1) then
				tank_topx_c <= tank_topx_c + 1;
				if (tank_topx_c+tank_offset_c = 637) then  --could be higher?
					direction_c <= 0;
				end if;
			--elsif (right_tank = 639) then
				--direction <= 0;
			elsif (tank_topx_c-tank_offset_c > 0 and direction_c = 0) then
				tank_topx_c <= tank_topx_c - 1;

			elsif (tank_topx_c-tank_offset_c = 0) then
				direction_c <= 1;
			end if;
		end if;
	end if;
		
	end process tanktopClocked;

	tank_topx <=  tank_topx_c ;
	
end architecture behavioral;	