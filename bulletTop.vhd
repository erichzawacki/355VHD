library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.ALL;

entity top_bullet is
	port( 
	hist0 : in std_logic_vector(7 downto 0);
	hist1 : in std_logic_vector(7 downto 0);
	clk 	: in std_logic;
	rst_n : in std_logic;
	-- tank stuff goes here --
	tank_topx : in integer;
	--bullet stuff
	top_bulletx : out integer;
	top_bullety : out integer
	);
end entity top_bullet;


architecture behavioral of top_bullet  is


signal top_bulletx_c : integer := 320;
signal top_bullety_c : integer := 75;
signal top_bullet_fired_c : integer := 0;
signal top_bullet_fired_temp : integer := 0;
signal bullet_offsetx : integer := 10;
signal bullet_offsety : integer := 10;
signal clock_divide_bullet : integer := 250000;
signal clock_counter : integer := 0;
begin

	top_bulletClocked : process(clk, rst_n) is
	
	begin
			
		if (rising_edge(clk)) then
				if (clock_counter < 50000000) then
					clock_counter <= clock_counter + 1;
				else
					clock_counter <= 0;
				end if;
				if (clock_counter mod clock_divide_bullet = 0) then
					if (top_bullet_fired_c = 1) then
						if (top_bullety_c-bullet_offsety < 459) then
							top_bullety_c <= top_bullety_c + 1;
							top_bullet_fired_temp <= 1;
						else
							top_bullety_c <= 75;
							top_bulletx_c <= tank_topx;
							top_bullet_fired_temp <= 0;
						end if;
					else 
						top_bulletx_c <= tank_topx;
					end if;
				end if;
		end if;
		
		
	end process top_bulletClocked;


	bulletFire : process( top_bullety_c, hist0 ) 
	begin
		
	top_bullet_fired_c <= top_bullet_fired_temp;	
		case( hist0 ) is 
			when x"F0" =>
					if (hist1 = x"43") then 
						top_bullet_fired_c <= 1;
					else
						top_bullet_fired_c <= 0;
					end if;
			when others =>
				if(top_bullet_fired_temp = 1) then 
					top_bullet_fired_c <= 1;
				else
					top_bullet_fired_c <= 0;
				end if;
			end case ;
		
	end process ; 

	top_bulletx <= top_bulletx_c;
	top_bullety <= top_bullety_c;

end architecture behavioral;	