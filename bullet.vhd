library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.ALL;

entity bullet is
	port( 
	hist0 : in std_logic_vector(7 downto 0);
	-- tank stuff goes here --
	tank_bottomx : in integer;
	--bullet stuff
	bulletx : out integer;
	bullety : out integer
	);
end entity bullet;


architecture behavioral of bullet  is


signal bulletx_c : integer := 320;
signal bullety_c : integer := 395;
signal bullet_fired_c : integer := 0;
signal bullet_counter_c : integer := 5;
signal bullet_offsetx : integer := 10;
signal bullet_offsety : integer := 10;

begin


	bulletClocked : process(clk, rst_n) is
	
	begin
			
		if (rising_edge(clk)) then
			

			
				if (bullet_fired_c = 1) then
					if (bullety_c-bullet_offsety > 0) then
						bullety_c <= bullety_c - 1;
					else
						bullet_fired_c <= 0;
						bullety_c <= 395;
						bulletx_c <= tank_bottomx;
					end if;
				end if;
		end if;
		
	end process bulletClocked;


	tankTopSpeed : process( hist0 ) 
	begin  
		if (hist0 = x"1D") then  
			bullet_counter_c <= bullet_counter_c + 1;
			if (bullet_counter_c > 4) then
				bullet_fired_c <= 1;
				bullet_counter_c <= 0;
			end if;
		end if ;
	end process ; 

	bulletx <= bulletx_c;
	bullety <= bullety_c;

end architecture behavioral;	