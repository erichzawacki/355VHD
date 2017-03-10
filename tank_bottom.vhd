library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.ALL;

entity Tank_bottom_position is
	port( 
	hist0 : in std_logic_vector(7 downto 0);
	clk : in std_logic;
	rst_n : in std_logic;
	--tank outputs
	tank_bottomx : out integer
	);
end entity Tank_bottom_position;


architecture behavioral of Tank_bottom_position is
signal direction_c : integer := 1; -- 1 to the right, 0 to the left;
signal direction_bottom_c : integer := 1;
signal tank_bottomx_c : integer := 320;
signal tank_offset_c : integer := 50;
signal clock_counter : integer := 0;
signal clock_divide_bottom: integer := 250000;
signal clock_divide_bottom_c: integer := 250000;

begin

	tankBottomSpeed : process( hist0 ) 
	begin  
		case( hist0 ) is 
			when x"1C" => 
				clock_divide_bottom_c <= 750000;
			when x"1B" => 
				clock_divide_bottom_c <= 400000;
			when x"23" => 
				clock_divide_bottom_c <= 150000;
				--bullet_fired <= 1;
			when others => clock_divide_bottom_c <= clock_divide_bottom;
								--bullet_fired <= 0;
			end case ;
	end process ; 

	tankbottomClocked : process(clk, rst_n) is
	
	begin
	clock_divide_bottom <= clock_divide_bottom_c;
	if (rising_edge(clk)) then
		if (clock_counter < 50000000) then
				clock_counter <= clock_counter + 1;
		else
			clock_counter <= 0;
		end if;
		
		if (clock_counter mod clock_divide_bottom = 0) then
			if (tank_bottomx_c+tank_offset_c < 639 and direction_c = 1) then
				tank_bottomx_c <= tank_bottomx_c + 1;
				if (tank_bottomx_c+tank_offset_c = 637) then  --could be higher?
					direction_c <= 0;
				end if;
			--elsif (right_tank = 639) then
				--direction <= 0;
			elsif (tank_bottomx_c-tank_offset_c > 0 and direction_c = 0) then
				tank_bottomx_c <= tank_bottomx_c - 1;

			elsif (tank_bottomx_c-tank_offset_c = 0) then
				direction_c <= 1;
			end if;
		end if;
	end if;
		
	end process tankbottomClocked;

	tank_bottomx <=  tank_bottomx_c ;
	
end architecture behavioral;	