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

type state_type is (idle, A, B);
signal state: state_type := idle;
signal next_state: state_type := idle;


signal bottom_bulletx_c : integer := 320;
signal bottom_bullety_c : integer := 395;
signal bottom_bullet_fired_c : integer := 0;
signal bottom_bullet_fired_temp : integer := 0;
signal bullet_offsetx : integer := 10;
signal bullet_offsety : integer := 10;
signal clock_divide_bullet : integer := 250000;
signal clock_counter : integer := 0;
signal clock_counter_c : integer := 0;
begin

	bottom_bulletClocked : process(clk, rst_n) is
	
	begin
		if (rising_edge(clk)) then
			state <= next_state;
			if state = A then 
				bottom_bulletx_temp <= tank_bottomx;
			end if;
			bottom_bullety <= bottom_bullety_c;
			clock_counter <= clock_counter + 1;
		end if;
		
	end process bottom_bulletClocked;


	bulletFire : process(state, clock_counter) 
	begin
		clock_counter_c <= clock_counter;
		case( state ) is 
			when idle =>
				next_state <= A;
			when A =>  
				bottom_bullety_c <= 395;
				
				
				if (hist0 = x"1D") then
					next_state <= B;
				end if;
			when B =>
				if (clock_counter_c mod clock_divide_bullet = 0) then
					bottom_bullety_c <= bottom_bullety_c - 1;
				end if;
				
				if (bottom_bullety_c-bullet_offsety <= 0) then
					next_state <= A;
				end if;
			when others => null;
			
		end case ;
		
	end process ; 

end architecture behavioral;	