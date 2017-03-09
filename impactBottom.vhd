library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.ALL;

entity impactBottom is
	port(
	clk: in std_logic;
	rst_n: in std_logic;
	top_bulletx : in integer;
	top_bullety : in integer;
	tank_bottomx : in integer;
	topScore: out integer 
	);
end entity impactBottom;

architecture behavioral of impactBottom is

signal topScore_c : integer := 0;
signal topWasHit : std_logic := '0';
signal topWasHit_c : std_logic := '0';

begin 

impactBottomClocked : Process(clk, rst_n)

begin
	if (rising_edge(clk)) then
		topScore <= topScore_c;
		topWasHit <= topWasHit_c;
		
	end if;
end process impactBottomClocked;





topImpactTracker : Process(top_bullety, top_bulletx, tank_bottomx)
begin
	if (top_bullety < 75) then
		if (abs(top_bulletx - tank_bottomx) < 100) then

			if topWasHit = '0' then 
				topScore_c <= topScore_c + 1;
				topWasHit_c <= '1';
			end if ;
		end if;	
	elsif (top_bullety > 100) then 
		topWasHit_c <= '0';	
	end if;
end process topImpactTracker;

end architecture behavioral;