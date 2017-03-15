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

type state_type is (idle, fired);
signal state: state_type := idle;
signal next_state: state_type := idle;


signal bottom_bulletx_c : integer := 320;
signal bottom_bullety_c : integer := 395;
signal bullet_offsety : integer := 10;
signal clock_divide_bullet : integer := 125000;
signal clock_counter : integer := 0;
signal bottom_bulletx_temp : integer := 320;
signal bottom_bulletx_temp_temp : integer := 320;
begin

	bottom_bulletClocked : process(clk, rst_n) is
	
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
					bottom_bullety_c <= bottom_bullety_c - 1;
				else 
					bottom_bullety_c <= 395;
				end if;
			else 
				bottom_bullety_c <= bottom_bullety_c;
			end if;
			
			bottom_bulletx <= bottom_bulletx_c;
			
		end if;
		
	end process bottom_bulletClocked;


	bulletFire : process(state, clock_counter, tank_bottomx, bottom_bulletx_temp, bottom_bullety_c) 
	begin

		case( state ) is 
			when idle =>  
				
				bottom_bulletx_c <= tank_bottomx;
				bottom_bulletx_temp_temp <= tank_bottomx;
				
				if (hist1 = x"1D" and hist0 = x"F0") then
					next_state <= fired;
				else 
					next_state <= idle;
				end if;
			when fired =>
				bottom_bulletx_c <= bottom_bulletx_temp;
				bottom_bulletx_temp_temp <= bottom_bulletx_temp;
				if (bottom_bullety_c + bullet_offsety < 0) then
					next_state <= idle;
				else 
					next_state <= fired;
				end if;
		end case ;
		
	end process ; 
bottom_bullety <= bottom_bullety_c;
bottom_bulletx_temp <= bottom_bulletx_temp_temp;
end architecture behavioral;	