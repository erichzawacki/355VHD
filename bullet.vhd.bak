library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.ALL;

entity bottom_bullet is
	port( 
	hist0 : in std_logic_vector(7 downto 0);
	hist1 : in std_logic_vector(7 downto 0);
	clk 	: in std_logic;
	rst_n : in std_logic;
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
signal bottom_bullet_fired_temp : integer := 0;
signal bullet_offsetx : integer := 10;
signal bullet_offsety : integer := 10;
signal clock_divide_bullet : integer := 250000;
signal clock_counter : integer := 0;
begin

	bottom_bulletClocked : process(clk, rst_n) is
	
	begin
			
		if (rising_edge(clk)) then
				if (clock_counter < 50000000) then
					clock_counter <= clock_counter + 1;
				else
					clock_counter <= 0;
				end if;
				if (clock_counter mod clock_divide_bullet = 0) then
					if (bottom_bullet_fired_c = 1) then
						if (bottom_bullety_c-bullet_offsety > 0) then
							bottom_bullety_c <= bottom_bullety_c - 1;
							bottom_bullet_fired_temp <= 1;
						else
							bottom_bullety_c <= 395;
							bottom_bulletx_c <= tank_bottomx;
							bottom_bullet_fired_temp <= 0;
						end if;
					else 
						bottom_bulletx_c <= tank_bottomx;
					end if;
				end if;
		end if;
		
		
	end process bottom_bulletClocked;


	bulletFire : process( bottom_bullety_c, hist0 ) 
	begin
		
	bottom_bullet_fired_c <= bottom_bullet_fired_temp;	
		case( hist0 ) is 
			when x"1D" =>
					bottom_bullet_fired_c <= 1;
			when others =>
				if(bottom_bullet_fired_temp = 1) then 
					bottom_bullet_fired_c <= 1;
				else
					bottom_bullet_fired_c <= 0;
				end if;
			end case ;
		
	end process ; 

	bottom_bulletx <= bottom_bulletx_c;
	bottom_bullety <= bottom_bullety_c;

end architecture behavioral;	