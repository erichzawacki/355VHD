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

type state_type is (idle, fired);
signal state: state_type := idle;
signal next_state: state_type := idle;


signal top_bulletx_c : integer := 320;
signal top_bullety_c : integer := 85;
signal bullet_offsety : integer := 10;
signal clock_divide_bullet : integer := 250000;
signal clock_counter : integer := 0;
signal top_bulletx_temp : integer := 85;
signal top_bulletx_temp_temp : integer := 85;
begin

	top_bulletClocked : process(clk, rst_n) is
	
	begin
		if (rising_edge(clk)) then
			if (clock_counter < 50000000) then
				clock_counter <= clock_counter + 1;
			else
				clock_counter <= 0;
			end if;
			state <= next_state;
			if (clock_counter mod clock_divide_bullet = 0) then 
				if (state = fired) then
					top_bullety_c <= top_bullety_c + 1;
				else 
					top_bullety_c <= 85;
				end if;
			else 
				top_bullety_c <= top_bullety_c;
			end if;
			
			top_bulletx <= top_bulletx_c;
			
		end if;
		
	end process top_bulletClocked;


	bulletFire : process(state, clock_counter, tank_topx, top_bulletx_temp, top_bullety_c) 
	begin

		case( state ) is 
			when idle =>  
				
				top_bulletx_c <= tank_topx;
				top_bulletx_temp_temp <= tank_topx;
				
				if (hist1 = x"43" and hist0 = x"F0") then
					next_state <= fired;
				else 
					next_state <= idle;
				end if;
			when fired =>
				top_bulletx_c <= top_bulletx_temp;
				top_bulletx_temp_temp <= top_bulletx_temp;
				if (top_bullety_c-bullet_offsety > 479) then
					next_state <= idle;
				else 
					next_state <= fired;
				end if;
		end case ;
		
	end process ; 
top_bullety <= top_bullety_c;
top_bulletx_temp <= top_bulletx_temp_temp;
end architecture behavioral;	