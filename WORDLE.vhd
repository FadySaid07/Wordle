----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2025 03:32:08 PM
-- Design Name: 
-- Module Name: WORDLE - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity WORDLE is
  Port (
    clk : in std_logic;
    ps2_clk    : in std_logic;
    ps2_data   : in std_logic;
    vga_hs     : out std_logic;
    vga_vs     : out std_logic;
    vga_r      : out std_logic_vector(2 downto 0);
    vga_g      : out std_logic_vector(2 downto 0);
    vga_b      : out std_logic_vector(1 downto 0)
  );
end WORDLE;

architecture Behavioral of WORDLE is
  signal clk_25MHz   : std_logic;
  signal ascii_code  : std_logic_vector(6 downto 0);
  signal ascii_new   : std_logic;
  signal hcount, vcount : std_logic_vector(9 downto 0);
  signal vid         : std_logic;
  signal rgb         : std_logic_vector(2 downto 0);

  component clock_div
    port (
      clk : in std_logic;
      div : out std_logic
    );
  end component;

  component vga_ctrl
    port (
      clk     : in std_logic;
      clk_en  : in std_logic;
      hcount  : out std_logic_vector(9 downto 0);
      vcount  : out std_logic_vector(9 downto 0);
      vid     : out std_logic;
      hs      : out std_logic;
      vs      : out std_logic
    );
  end component;

  component ps2_keyboard_to_ascii
    generic (
      clk_freq : integer := 125000000;
      ps2_debounce_counter_size : integer := 9
    );
    port (
      clk        : in std_logic;
      ps2_clk    : in std_logic;
      ps2_data   : in std_logic;
      ascii_new  : out std_logic;
      ascii_code : out std_logic_vector(6 downto 0)
    );
  end component;

  component text_display
    port (
      clk_25MHz  : in std_logic;
      clk : in std_logic;
      ascii_code : in std_logic_vector(6 downto 0);
      ascii_new  : in std_logic;
      hcount     : in std_logic_vector(9 downto 0);
      vcount     : in std_logic_vector(9 downto 0);
      vid        : in std_logic;
      rgb_out    : out std_logic_vector(2 downto 0)
    );
  end component;

begin
  -- Clock divider to get 25MHz from 125MHz
  clkdiv_inst : clock_div
    port map (
      clk => clk,
      div => clk_25MHz
    );

  -- VGA timing
  vga_ctrl_inst : vga_ctrl
    port map (
      clk     => clk_25MHz,
      clk_en  => '1',
      hcount  => hcount,
      vcount  => vcount,
      vid     => vid,
      hs      => vga_hs,
      vs      => vga_vs
    );

  -- PS/2 to ASCII
  ps2_inst : ps2_keyboard_to_ascii
    port map (
      clk        => clk,
      ps2_clk    => ps2_clk,
      ps2_data   => ps2_data,
      ascii_new  => ascii_new,
      ascii_code => ascii_code
    );

  -- VGA text rendering
  display_inst : text_display
    port map (
      clk_25MHz  => clk_25MHz,
      clk => clk,
      ascii_code => ascii_code,
      ascii_new  => ascii_new,
      hcount     => hcount,
      vcount     => vcount,
      vid        => vid,
      rgb_out    => rgb
    );

  -- Output RGB
  vga_r <= rgb;
  vga_g <= rgb;
  vga_b <= rgb(1 downto 0);

end Behavioral;
