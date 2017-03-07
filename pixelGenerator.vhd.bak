library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.ALL;

entity pixelGenerator is
	port(
			clk, ROM_clk, rst_n, video_on, eof 				: in std_logic;
			pixel_row, pixel_column						    : in std_logic_vector(9 downto 0);
			hist0                                      : in std_logic_vector(7 downto 0);
			red_out, green_out, blue_out					: out std_logic_vector(9 downto 0)
		);
end entity pixelGenerator;

architecture behavioral of pixelGenerator is

constant color_red 	 	 : std_logic_vector(2 downto 0) := "000";
constant color_green	 : std_logic_vector(2 downto 0) := "001";
constant color_blue 	 : std_logic_vector(2 downto 0) := "010";
constant color_yellow 	 : std_logic_vector(2 downto 0) := "011";
constant color_magenta 	 : std_logic_vector(2 downto 0) := "100";
constant color_cyan 	 : std_logic_vector(2 downto 0) := "101";
constant color_black 	 : std_logic_vector(2 downto 0) := "110";
constant color_white	 : std_logic_vector(2 downto 0) := "111";
	
component colorROM is
	port
	(
		address		: in std_logic_vector (2 downto 0);
		clock		: in std_logic  := '1';
		q			: out std_logic_vector (29 downto 0)
	);
end component colorROM;


component tank1 is
	port(clk : in std_logic;
		  xin, din, clock_counter, clock_divide : in integer;
		  xout, dout : out integer);
end component tank1;

signal colorAddress : std_logic_vector (2 downto 0);
signal color        : std_logic_vector (29 downto 0);

signal pixel_row_int, pixel_column_int : natural;
signal clock_counter : integer := 0;
signal clock_divide : integer;-- := 500000; -- need 3
signal clock_divide_bottom, clock_divide_top : integer := 500000;
signal clock_divide_bullet : integer := 250000;
signal direction : integer := 1; -- 1 to the right, 0 to the left;
signal direction_bottom, direction_top : integer := 1;
signal tank_bottomx, tank_topx : integer := 320;
signal tank_offset : integer := 50;

signal bullet_offsetx : integer := 10;
signal bullet_offsety : integer := 10;
signal bulletx : integer := 320;
signal bullety : integer := 395;
signal bullet_fired : integer := 0;
signal bullet_counter : integer := 5;

signal his0 : std_logic_vector(7 downto 0);
signal keyboard_clk_temp, keyboard_data_temp, clock_50MHz_temp, reset_temp : std_logic;
signal scan_code_temp : std_logic_vector (7 downto 0);
signal scan_readyo_temp : std_logic;
signal his3, his2, his1 : std_logic_vector (7 downto 0);

begin

--------------------------------------------------------------------------------------------
	
	red_out <= color(29 downto 20);
	green_out <= color(19 downto 10);
	blue_out <= color(9 downto 0);

	pixel_row_int <= to_integer(unsigned(pixel_row));
	pixel_column_int <= to_integer(unsigned(pixel_column));
	
--------------------------------------------------------------------------------------------	
	
	colors : colorROM
		port map(colorAddress, ROM_clk, color);
		
	--keyboard : ps2
		--port map(keyboard_clk_temp, keyboard_data_temp, clk, reset_temp, scan_code_temp,
			--		scan_readyo_temp, his3, his2, his1, his0);
	--tank_bottom : tank
		--port map(clk, tank_bottomx, direction_bottom, clock_counter, clock_divide_bottom,
			--		tank_bottomx, direction_bottom);
		
	--tank_top : tank
		--port map(clk, tank_topx, direction_top, clock_counter, clock_divide_top,
					  --tank_topx, direction_top);

--------------------------------------------------------------------------------------------	

	pixelDraw : process(clk, rst_n) is
	
	begin
			
		if (rising_edge(clk)) then
		--479 by 639
		   if (pixel_column_int < tank_bottomx+tank_offset and pixel_column_int > tank_bottomx-tank_offset and pixel_row_int >= 405) then
				colorAddress <= color_blue;
			elsif (pixel_column_int < tank_topx+tank_offset and pixel_column_int > tank_topx-tank_offset and pixel_row_int < 75) then
				colorAddress <= color_red;
			elsif (pixel_column_int < bulletx+bullet_offsetx and 
				    pixel_column_int > bulletx-bullet_offsetx and 
					 pixel_row_int > bullety-bullet_offsety and 
					 pixel_row_int < bullety+bullet_offsety) then
				colorAddress <= color_green;
			else
				colorAddress <= color_black;
			end if;
			if (clock_counter < 50000000) then
				clock_counter <= clock_counter + 1;
			else
				clock_counter <= 0;
				--bullet_counter <= bullet_counter + 1;
				--if (bullet_counter > 4) then
					--bullet_fired <= 1;
					--bullet_counter <= 0;
				--end if;
			end if;
			
			if (clock_counter mod clock_divide_bottom = 0) then
				if (tank_bottomx+tank_offset < 639 and direction_bottom = 1) then
					tank_bottomx <= tank_bottomx + 1;
					--tank_topx <= tank_topx + 1;
					if (tank_bottomx+tank_offset = 637) then  --could be higher?
						direction_bottom <= 0;
					end if;
				--elsif (right_tank = 639) then
					--direction <= 0;
				elsif (tank_bottomx-tank_offset > 0 and direction_bottom = 0) then
					tank_bottomx <= tank_bottomx - 1;
					--tank_topx <= tank_topx - 1;
				elsif (tank_bottomx-tank_offset = 0) then
					direction_bottom <= 1;
				end if;
				if (direction = 1 and bullet_fired = 0) then
					bulletx <= bulletx + 1;
				elsif (direction = 0 and bullet_fired = 0) then
					bulletx <= bulletx - 1;
				end if;
			elsif (clock_counter mod clock_divide_top = 0) then
				if (tank_topx+tank_offset < 639 and direction_top = 1) then
					tank_topx <= tank_topx + 1;
					if (tank_topx+tank_offset = 637) then
						direction_top <= 0;
					end if;
				elsif (tank_topx-tank_offset > 0 and direction_top = 0) then
					tank_topx <= tank_topx - 1;
				elsif (tank_topx-tank_offset = 0) then
					direction_top <= 1;
				end if;
			elsif (clock_counter mod clock_divide_bullet = 0) then
				--if (direction = 1 and bullet_fired = 0) then
					--bulletx <= bulletx + 1;
				--elsif (direction = 0 and bullet_fired = 0) then
					--bulletx <= bulletx - 1;
				if (bullet_fired = 1) then
					if (bullety-bullet_offsety > 0) then
						bullety <= bullety - 1;
					else
						bullet_fired <= 0;
						bullety <= 395;
						bulletx <= tank_bottomx;
					end if;
				end if;
			end if;
		
		end if;
		
	end process pixelDraw;
	
	tankTopSpeed : process( hist0 ) 
	begin  
		case( hist0 ) is 
			when x"1C" => 
				clock_divide_bottom <= 750000;
				--bullet_fired <= 1;
			when others => clock_divide_bottom <= 250000;
								--bullet_fired <= 0;
			end case ;
	end process ; 
	--his0 <= hist0;

--------------------------------------------------------------------------------------------
	
end architecture behavioral;		