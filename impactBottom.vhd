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

type state_type is (safe, A, B, C, D, E);
signal state: state_type := safe;
signal next_state: state_type := safe;



begin 

impactBottomClocked : Process(clk, rst_n)

begin
	if rst_n = '0' then 
		topScore <= 0;
		state <= safe;
	elsif (rising_edge(clk)) then
		topScore <= topScore_c;
		state <= next_state;
	end if;
end process impactBottomClocked;





topImpactTracker : Process(state, top_bulletx, tank_bottomx, top_bullety )
begin
	case( state ) is 
	when safe =>  
		if top_bullety > 405 and top_bullety < 480 and abs(top_bulletx - tank_bottomx) < 35 then 
			next_state <= A;
		else 
			next_state <= safe; 
		end if ;
		topScore_c <= 0;
	when A =>
		if top_bullety < 405 then 
			next_state <= B;
		else 
			next_state <= A; 
		end if ;
		topScore_c <= 1;
	when B =>
		if top_bullety > 405 and top_bullety < 480 and abs(top_bulletx - tank_bottomx) < 35 then 
			next_state <= C;
		else 
			next_state <= B; 
		end if ;
		topScore_c <= 1;
	when C =>
		if top_bullety < 405 then 
			next_state <= D;
		else 
			next_state <= C; 
		end if ;
		topScore_c <= 2;
		
	when D =>
		if top_bullety > 405 and top_bullety < 480 and abs(top_bulletx - tank_bottomx) < 35 then 
			next_state <= E;
		else 
			next_state <= D; 
		end if ;
		topScore_c <= 2;
	when E =>
		next_state <= E; 

		topScore_c <= 3;
		
	end case ;
end process topImpactTracker;

end architecture behavioral;