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

type state_type is (safe, A, B, C, D, E);
signal state: state_type := safe;
signal next_state: state_type := safe;



begin 

impactTopClocked : Process(clk, rst_n)

begin
	if rst_n = '0' then 
		bottomScore <= 0;
		state <= safe;
	elsif (rising_edge(clk)) then
		bottomScore <= bottomScore_c;
		state <= next_state;
	end if;
end process impactTopClocked;





topImpactTracker : Process(state, bottom_bulletx, tank_topx, bottom_bullety )
begin
	case( state ) is 
	when safe =>  
		if bottom_bullety < 75 and bottom_bullety > 0 and abs(bottom_bulletx - tank_topx) < 35 then 
			next_state <= A;
		else 
			next_state <= safe; 
		end if ;
		bottomScore_c <= 0;
	when A =>
		if bottom_bullety > 75 then 
			next_state <= B;
		else 
			next_state <= A; 
		end if ;
		bottomScore_c <= 1;
	when B =>
		if bottom_bullety < 75 and bottom_bullety > 0 and abs(bottom_bulletx - tank_topx) < 35 then 
			next_state <= C;
		else 
			next_state <= B; 
		end if ;
		bottomScore_c <= 1;
	when C =>
		if bottom_bullety > 75 then 
			next_state <= D;
		else 
			next_state <= C; 
		end if ;
		bottomScore_c <= 2;
		
	when D =>
		if bottom_bullety < 75 and bottom_bullety > 0 and abs(bottom_bulletx - tank_topx) < 35 then 
			next_state <= E;
		else 
			next_state <= D; 
		end if ;
		bottomScore_c <= 2;
	when E =>
		next_state <= E; 

		bottomScore_c <= 3;
		
	end case ;
end process topImpactTracker;

end architecture behavioral;