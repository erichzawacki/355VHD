library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.ALL;

entity tank is
	port(clk : in std_logic;
		  xin, din, clock_counter, clock_divide : in integer;
		  xout, dout : out integer);
end entity tank;

architecture state of tank is

signal offset : integer := 50;

begin

xout <= xin + 1 when xin+offset<639 and din = 1 and clock_counter mod clock_divide = 0 else
		  xin - 1 when xin-offset>0 and din = 0 and clock_counter mod clock_divide = 0 else
		  xin;
dout <= 0 when xin+offset = 637 else--and clock_counter mod clock_divide = 0 else
		  1 when xin-offset = 0 else--and clock_counter mod clock_divide = 0 else
		  din;

end architecture state;
--if (tank_bottomx+tank_offset < 639 and direction = 1) then
	--				tank_bottomx <= tank_bottomx + 1;
		--			tank_topx <= tank_topx + 1;
			--		if (tank_bottomx+tank_offset = 637) then  --could be higher?
				--		direction <= 0;
					--end if;
				--elsif (right_tank = 639) then
					--direction <= 0;
				--elsif (tank_bottomx-tank_offset > 0 and direction = 0) then
					--tank_bottomx <= tank_bottomx - 1;
					--tank_topx <= tank_topx - 1;
				--elsif (tank_bottomx-tank_offset = 0) then
					--direction <= 1;
				--end if;