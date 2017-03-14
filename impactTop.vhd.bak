library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.ALL;

entity impactTop is
	port(
	clk: in std_logic;
	rst_n: in std_logic;
	bottom_bulletx : in integer;
	bottom_bullety : in integer;
	tank_topx : in integer;
	bottomScore: out integer 
	);
end entity impactTop;

architecture behavioral of impactTop is

signal bottomScore_c : integer := 0;
signal topWasHit : std_logic := '0';
signal topWasHit_c : std_logic := '0';

begin 

impactTopClocked : Process(clk, rst_n)

begin
	if (rising_edge(clk)) then
		--bottomScore <= bottomScore_c;
		--topWasHit <= topWasHit_c;
		if (topwashit_c = '1' and topwashit = '0') then
			bottomscore_c <= bottomscore_c + 1;
			--topwashit <= '1';
		end if;
		topwashit <= topwashit_c;
		
	end if;
end process impactTopClocked;





topImpactTracker : Process(bottom_bullety, bottom_bulletx, tank_topx)
begin
	if (bottom_bullety < 75) then
		if (abs(bottom_bulletx - tank_topx) < 60) then

			if (topWasHit_c = '0' and topwashit = '0') then 
				--bottomScore_c <= bottomScore_c + 1;
				topWasHit_c <= '1';
			end if ;
		end if;	
	else--if (bottom_bullety > 100) then 
		topWasHit_c <= '0';	
	end if;
end process topImpactTracker;
bottomscore <= bottomscore_c;

end architecture behavioral;