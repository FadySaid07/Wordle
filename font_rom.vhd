library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity font_rom is
  Port (
    char_code : in std_logic_vector(6 downto 0); -- ASCII
    row       : in std_logic_vector(3 downto 0); -- 0-15
    pixels    : out std_logic_vector(7 downto 0)
  );
end font_rom;

architecture Behavioral of font_rom is
  type font_t is array(0 to 127, 0 to 15) of std_logic_vector(7 downto 0);
  signal font : font_t := (
    65 => (x"18", x"24", x"42", x"7E", x"42", x"42", x"42", x"00", others => x"00"), -- A
    66 => (x"7C", x"42", x"42", x"7C", x"42", x"42", x"7C", x"00", others => x"00"), -- B
    67 => (x"3C", x"42", x"40", x"40", x"40", x"42", x"3C", x"00", others => x"00"), -- C
    others => (others => x"00")
  );
begin
  pixels <= font(to_integer(unsigned(char_code)), to_integer(unsigned(row)));
end Behavioral;