library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity text_display is
  Port (
    clk_25MHz     : in std_logic;
    clk    : in std_logic;
    ascii_code    : in std_logic_vector(6 downto 0);
    ascii_new     : in std_logic;
    hcount        : in std_logic_vector(9 downto 0);
    vcount        : in std_logic_vector(9 downto 0);
    vid           : in std_logic;
    rgb_out       : out std_logic_vector(2 downto 0)
  );
end text_display;

architecture Behavioral of text_display is
  type text_mem_t is array (0 to 29, 0 to 79) of std_logic_vector(6 downto 0);
  signal text_buffer : text_mem_t := (others => (others => "1000000"));  -- ' ' (space)

  signal row, col : integer range 0 to 79 := 0;
  signal char_row, char_col : integer;
  signal pixel_row, pixel_col : integer;
  signal char_code : std_logic_vector(6 downto 0);
  signal font_line : std_logic_vector(7 downto 0);
  signal rgb       : std_logic_vector(2 downto 0);

  component font_rom
    Port (
      char_code : in std_logic_vector(6 downto 0);
      row       : in std_logic_vector(3 downto 0);
      pixels    : out std_logic_vector(7 downto 0)
    );
  end component;

begin
  -- Instantiate font ROM
  font_inst: font_rom
    port map (
      char_code => char_code,
      row       => std_logic_vector(to_unsigned(pixel_row, 4)),
      pixels    => font_line
    );

  -- Write characters from keyboard into buffer
  process(clk)
  begin
    if rising_edge(clk) then
      if ascii_new = '1' then
        case ascii_code is
       when x"41" | x"42" | x"43" | x"44" | x"45" | x"46" | x"47" | x"48" |
       x"49" | x"4A" | x"4B" | x"4C" | x"4D" | x"4E" | x"4F" | x"50" |
       x"51" | x"52" | x"53" | x"54" | x"55" | x"56" | x"57" | x"58" |
       x"59" | x"5A" =>
            text_buffer(row, col) <= ascii_code;
            if col < 79 then col <= col + 1; end if;
          when x"08" =>  -- backspace
            if col > 0 then
              col <= col - 1;
              text_buffer(row, col - 1) <= x"20";
            end if;
          when x"0D" =>  -- enter
            if row < 29 then row <= row + 1; col <= 0; end if;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  -- VGA text rendering
  process(clk_25MHz)
  begin
    if rising_edge(clk_25MHz) then
      if vid = '1' then
        char_row  <= to_integer(unsigned(vcount(9 downto 4)));
        char_col  <= to_integer(unsigned(hcount(9 downto 3)));
        pixel_row <= to_integer(unsigned(vcount(3 downto 0)));
        pixel_col <= to_integer(unsigned(hcount(2 downto 0)));

        char_code <= text_buffer(char_row, char_col);

        if font_line(7 - pixel_col) = '1' then
          rgb <= "111"; -- white
        else
          rgb <= "000"; -- black
        end if;
      else
        rgb <= "000";
      end if;
    end if;
  end process;

  rgb_out <= rgb;
end Behavioral;
