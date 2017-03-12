library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.ALL;

entity pixelGenerator is
	port(
			clk, ROM_clk, rst_n, video_on, eof 				: in std_logic;
			pixel_row, pixel_column						    : in std_logic_vector(9 downto 0);
			tank_topx                                      : in integer;
			tank_bottomx                                      : in integer;
			bottom_bulletx 										: in integer;
			bottom_bullety 										: in integer;
			top_bulletx                                         : in integer;
			top_bullety 										: in integer;
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

signal colorAddress : std_logic_vector (2 downto 0);
signal color        : std_logic_vector (29 downto 0);

signal pixel_row_int, pixel_column_int : natural;
signal tank_offset : integer := 50;
signal bullet_offsetx : integer := 10;
signal bullet_offsety : integer := 10;


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

			if (pixel_column_int < tank_topx+tank_offset and pixel_column_int > tank_topx-tank_offset and pixel_row_int < 75) then
				colorAddress <= color_red;
			elsif (pixel_column_int < tank_bottomx+tank_offset and pixel_column_int > tank_bottomx-tank_offset and pixel_row_int >= 405) then
				colorAddress <= color_blue;
			elsif (pixel_column_int < bottom_bulletx+bullet_offsetx and 
				    pixel_column_int >  bottom_bulletx-bullet_offsetx and 
					 pixel_row_int >  bottom_bullety-bullet_offsety and 
					 pixel_row_int <  bottom_bullety+bullet_offsety) then
				colorAddress <= color_green;
			elsif (pixel_column_int < top_bulletx+bullet_offsetx and 
				    pixel_column_int >  top_bulletx-bullet_offsetx and 
					 pixel_row_int >  top_bullety-bullet_offsety and 
					 pixel_row_int <  top_bullety+bullet_offsety) then
				colorAddress <= color_green;
			else
				colorAddress <= color_black;
			end if;
		
		end if;
		
	end process pixelDraw;
	

	--his0 <= hist0;

--------------------------------------------------------------------------------------------
	
end architecture behavioral;		