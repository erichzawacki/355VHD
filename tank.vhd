library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.ALL;

entity Tank is
	port( 
	clock_counter : in integer;
	clock_divide : in integer
	--tank outputs
	tank_bottomx, tank_topx : out integer
	);
end entity Tank



architecture behavioral of Tank is
signal direction_c : integer := 1; -- 1 to the right, 0 to the left;
signal direction_bottom_c, direction_top_c : integer := 1;
signal tank_bottomx_c, tank_topx_c : integer := 320;
signal tank_offset_c : integer := 50;

begin


	tankClocked : process(clk, rst_n, clock_counter, clock_divide) is
	
	begin
		if (clock_counter mod clock_divide = 0) then
			if (tank_bottomx_c+tank_offset_c < 639 and direction_c = 1) then
				tank_bottomx_c <= tank_bottomx_c + 1;
				tank_topx_c <= tank_topx_c + 1;
				if (tank_bottomx_c+tank_offset_c = 637) then  --could be higher?
					direction_c <= 0;
				end if;
			--elsif (right_tank = 639) then
				--direction <= 0;
			elsif (tank_bottomx_c-tank_offset_c > 0 and direction_c = 0) then
				tank_bottomx_c <= tank_bottomx_c - 1;
				tank_topx_c <= tank_topx_c - 1;
			elsif (tank_bottomx_c-tank_offset_c = 0) then
				direction_c <= 1;
			end if;
		
	end process tankClocked;

	tank_bottomx_c <= tank_bottomx;
	tank_topx_c <= tank_topx;
	
end architecture behavioral;	