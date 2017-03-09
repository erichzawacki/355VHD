library IEEE;

use IEEE.std_logic_1164.all;

entity VGA_top_level is
	port(
			CLOCK_50 										: in std_logic;
			RESET_N											: in std_logic;
			keyboard_clk, keyboard_data : in std_logic;
			--VGA 
			VGA_RED, VGA_GREEN, VGA_BLUE 					: out std_logic_vector(9 downto 0); 
			HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic

		);
end entity VGA_top_level;

architecture structural of VGA_top_level is

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
	clk : in std_logic;
	rst_n : in std_logic;
	-- tank stuff goes here --
	tank_bottomx : in integer;
	--bullet stuff
	bottom_bulletx : out integer;
	bottom_bullety : out integer
	);
end component bottom_bullet;

component pixelGenerator is
	port(
			clk, ROM_clk, rst_n, video_on, eof 				: in std_logic;
			pixel_row, pixel_column						    : in std_logic_vector(9 downto 0);
			tank_topx											: in integer;
			tank_bottomx											: in integer;
			bottom_bulletx										 : in integer;
			bottom_bullety 										: in integer;

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
signal scan_code_temp, his3, his2, his1, his0 : std_logic_vector(7 downto 0);
signal scan_readyo_temp : std_logic;

begin



keyboard : ps2
		port map(keyboard_clk, keyboard_data, CLOCK_50, RESET_N, scan_code_temp,
					scan_readyo_temp, his3, his2, his1, his0);
--------------------------------------------------------------------------------------------
tank_top : Tank_top_position
		port map(his0, CLOCK_50, RESET_N,tank_topx_temp);
		
tank_bottom : Tank_bottom_position
		port map(his0, CLOCK_50, RESET_N,tank_bottomx_temp);
		
bullet_bottom : bottom_bullet
		port map(his0, CLOCK_50, RESET_N, bottom_bulletx_temp, bottom_bullety_temp);
		
	videoGen : pixelGenerator
		port map(CLOCK_50, VGA_clk_int, RESET_N, video_on_int, eof, pixel_row_int, pixel_column_int, 
		tank_topx_temp, tank_bottomx_temp, bottom_bulletx_temp, bottom_bullety_temp, VGA_RED, VGA_GREEN, VGA_BLUE);

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