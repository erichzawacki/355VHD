library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.ALL;

entity clockDivideTank is
	port( 
	clk : in std_logic;
	rst_n : in std_logic;
	keyboard : in std_logic;
	clock_counter : out integer;
	clock_divide : out integer
	);
end entity clockDivideTank



architecture behavioral of clockDivideTank is

begin


	clockChange : process(clk, rst_n) is
	
	begin
			
		if (rising_edge(clk)) then
			if (clock_counter < 50000000) then
				clock_counter <= clock_counter + 1;
			else
				clock_counter <= 0;
			end if;

		
	end process clockChange;

	tankTopSpeed : process( keyboard ) 
	begin  
		case( keyboard ) is 
			when x"1C" => 
				clock_divide <= 750000;
				bullet_fired <= 1;
			when others => clock_divide <= 250000;
								bullet_fired <= 0;
			end case ;
	end process ; 
	
end architecture behavioral;	