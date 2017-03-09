library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.ALL;

entity bottom_bullet is
	port( 
	hist0 : in std_logic_vector(7 downto 0);
	clk 	: in std_logic;
	-- tank stuff goes here --
	tank_bottomx : in integer;
	--bullet stuff
	bottom_bulletx : out integer;
	bottom_bullety : out integer
	);
end entity bottom_bullet;


architecture behavioral of bottom_bullet  is


signal bottom_bulletx_c : integer := 320;
signal bottom_bullety_c : integer := 395;
signal bottom_bullet_fired_c : integer := 0;
signal bottom_bullet_counter_c : integer := 5;
signal bullet_offsetx : integer := 10;
signal bullet_offsety : integer := 10;

begin


	bottom_bulletClocked : process(clk, rst_n) is
	
	begin
			
		if (rising_edge(clk)) then
			

			
				if (bottom_bullet_fired_c = 1) then
					if (bottom_bullety_c-bullet_offsety > 0) then
						bottom_bullety_c <= bottom_bullety_c - 1;
					else
						bottom_bullet_fired_c <= 0;
						bottom_bullety_c <= 395;
						bottom_bulletx_c <= tank_bottomx;
					end if;
				end if;
		end if;
		
	end process bottom_bulletClocked;


	tankTopSpeed : process( hist0 ) 
	begin  
		if (hist0 = x"1D") then  
			bottom_bullet_counter_c <= bottom_bullet_counter_c + 1;
			if (bottom_bullet_counter_c > 4) then
				bottom_bullet_fired_c <= 1;
				bottom_bullet_counter_c <= 0;
			end if;
		end if ;
	end process ; 

	bottom_bulletx <= bottom_bulletx_c;
	bottom_bullety <= bottom_bullety_c;

end architecture behavioral;	