library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.ALL;

entity VGA_top_level is
	port(
			CLOCK_50 										: in std_logic;
			RESET_N											: in std_logic;
			keyboard_clk, keyboard_data : in std_logic;
			--VGA 
			VGA_RED, VGA_GREEN, VGA_BLUE 					: out std_logic_vector(9 downto 0); 
			HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic;
			LCD_RS, LCD_E, LCD_ON : out std_logic;
			LCD_RW : buffer std_logic;
			DATA_BUS : INOUT std_logic_vector(7 downto 0);
			segments_out1 : out std_logic_Vector (6 downto 0);
			segments_out2 : out std_logic_vector(6 downto 0)

		);
end entity VGA_top_level;

architecture structural of VGA_top_level is

component de2lcd IS
	PORT(reset, clk_50Mhz				: IN	STD_LOGIC;
	    score1, score2 : in integer;
		 LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED		: OUT	STD_LOGIC;
		 LCD_RW						: BUFFER STD_LOGIC;
		 DATA_BUS				: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0));
end component de2lcd;

component leddcd is
	port(
		 data_in : in std_logic_vector(3 downto 0);
		 segments_out : out std_logic_vector(6 downto 0)
		);
end component leddcd;

component ps2 is
	port( 	keyboard_clk, keyboard_data, clock_50MHz ,
			reset : in std_logic;--, read : in std_logic;
			scan_code : out std_logic_vector( 7 downto 0 );
			scan_readyo : out std_logic;
			hist3 : out std_logic_vector(7 downto 0);
			hist2 : out std_logic_vector(7 downto 0);
			hist1 : out std_logic_vector(7 downto 0);
			hist0 : out std_logic_vector(7 downto 0)
		);
end component ps2;

component Tank_top_position is
	port( 
	hist0 : in std_logic_vector(7 downto 0);
	clk : in std_logic;
	rst_n : in std_logic;
	--tank outputs
	tank_topx : out integer
	--score : out std_logic_vector(3 downto 0)
	);
end component Tank_top_position;

component Tank_bottom_position is
	port( 
	hist0 : in std_logic_vector(7 downto 0);
	clk : in std_logic;
	rst_n : in std_logic;
	--tank outputs
	tank_bottomx : out integer
	);
end component Tank_bottom_position;

component bottom_bullet is
	port( 
	hist0 : in std_logic_vector(7 downto 0);
	hist1 : in std_logic_vector(7 downto 0);
	clk : in std_logic;
	rst_n : in std_logic;
	-- tank stuff goes here --
	tank_bottomx : in integer;
	--bullet stuff
	bottom_bulletx : out integer;
	bottom_bullety : out integer
	);
end component bottom_bullet;

component top_bullet is
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
end component top_bullet;

component impactBottom is
	port(
	clk: in std_logic;
	rst_n: in std_logic;
	top_bulletx : in integer;
	top_bullety : in integer;
	tank_bottomx : in integer;
	topScore: out integer 
	);
end component impactBottom;

component impactTop is
	port(
	clk: in std_logic;
	rst_n: in std_logic;
	bottom_bulletx : in integer;
	bottom_bullety : in integer;
	tank_topx : in integer;
	bottomScore: out integer 
	);
end component impactTop;

component pixelGenerator is
	port(
			clk, ROM_clk, rst_n, video_on, eof 				: in std_logic;
			pixel_row, pixel_column						    : in std_logic_vector(9 downto 0);
			tank_topx											: in integer;
			tank_bottomx											: in integer;
			bottom_bulletx										 : in integer;
			bottom_bullety 										: in integer;
			top_bulletx                                         : in integer;
			top_bullety 										: in integer;
			bottomScore											: in integer;
			topScore												: in integer;
			red_out, green_out, blue_out					: out std_logic_vector(9 downto 0)
		);
end component pixelGenerator;

component VGA_SYNC is
	port(
			clock_50Mhz										: in std_logic;
			horiz_sync_out, vert_sync_out, 
			video_on, pixel_clock, eof						: out std_logic;												
			pixel_row, pixel_column						    : out std_logic_vector(9 downto 0)
		);
end component VGA_SYNC;

--Signals for VGA sync
signal pixel_row_int 										: std_logic_vector(9 downto 0);
signal pixel_column_int 									: std_logic_vector(9 downto 0);
signal video_on_int											: std_logic;
signal VGA_clk_int											: std_logic;
signal eof													: std_logic;
signal tank_topx_temp 								: integer;
signal tank_bottomx_temp 								: integer;
signal bottom_bulletx_temp								 :integer;
signal bottom_bullety_temp 							: integer;
signal topx_temp											: integer;
signal topy_temp											: integer;
signal scan_code_temp, his3, his2, his1, his0 : std_logic_vector(7 downto 0);
signal scan_readyo_temp : std_logic;
signal reset_led, sec_led : std_logic;
signal score_top_int : integer := 0;
signal score_bottom_int : integer := 0;
signal score_top : std_logic_vector(3 downto 0) := "0000";
signal score_bottom : std_logic_vector(3 downto 0) := "0000";

begin

score_bottom <= std_logic_vector(to_unsigned(score_bottom_int, 4));

scorebottom : leddcd
		port map(score_bottom , segments_out1);
		
score_top <= std_logic_vector(to_unsigned(score_top_int, 4));

scoretop : leddcd
	   port map(score_top, segments_out2);
	
lcd : de2lcd
		port map(reset_n, clock_50, score_bottom_int, score_top_int, lcd_rs, lcd_e, lcd_on, reset_led, sec_led,
					lcd_rw, data_bus);

keyboard : ps2
		port map(keyboard_clk, keyboard_data, CLOCK_50, RESET_N, scan_code_temp,
					scan_readyo_temp, his3, his2, his1, his0);
--------------------------------------------------------------------------------------------
tank_top : Tank_top_position
		port map(his0, CLOCK_50, RESET_N,tank_topx_temp);--, score_top);
		
tank_bottom : Tank_bottom_position
		port map(his0, CLOCK_50, RESET_N,tank_bottomx_temp);
		
bullet_bottom : bottom_bullet
		port map(his0, his1, CLOCK_50, RESET_N, tank_bottomx_temp, bottom_bulletx_temp, bottom_bullety_temp);

bullet_top : top_bullet
		port map(his0, his1, CLOCK_50, RESET_N, tank_topx_temp, topx_temp, topy_temp);
		
impact_bottom : impactBottom
		port map(CLOCK_50, RESET_N, topx_temp, topy_temp, tank_bottomx_temp, score_top_int);
		
impact_top : impactTop
		port map(CLOCK_50, RESET_N, bottom_bulletx_temp, bottom_bullety_temp, tank_topx_temp, score_bottom_int);
	
	videoGen : pixelGenerator
		port map(CLOCK_50, VGA_clk_int, RESET_N, video_on_int, eof, pixel_row_int, pixel_column_int, 
		tank_topx_temp, tank_bottomx_temp, bottom_bulletx_temp, bottom_bullety_temp, topx_temp, topy_temp, score_top_int, score_bottom_int, 
		VGA_RED, VGA_GREEN, VGA_BLUE);

--------------------------------------------------------------------------------------------
--This section should not be modified in your design.  This section handles the VGA timing signals
--and outputs the current row and column.  You will need to redesign the pixelGenerator to choose
--the color value to output based on the current position.

	videoSync : VGA_SYNC
		port map(CLOCK_50, HORIZ_SYNC, VERT_SYNC, video_on_int, VGA_clk_int, eof, pixel_row_int, pixel_column_int);

	VGA_BLANK <= video_on_int;

	VGA_CLK <= VGA_clk_int;

--------------------------------------------------------------------------------------------	

end architecture structural;