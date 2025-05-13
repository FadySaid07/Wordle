----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/12/2025 06:23:23 PM
-- Design Name: 
-- Module Name: game_logic - Behavioral
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
-- arithmetic functions with Signed or Unsigned architecture
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity wordle_logic is
    Port (
        clk         : in  STD_LOGIC;
        ascii_code  : in  STD_LOGIC_VECTOR(6 downto 0);
        ascii_new   : in  STD_LOGIC;
        guess_chars : out STD_LOGIC_VECTOR(7 downto 0);  -- last char entered (for VGA display debug)
        letter_row  : out INTEGER range 0 to 5;
        letter_col  : out INTEGER range 0 to 4;
        flag_color  : out STD_LOGIC_VECTOR(1 downto 0);  -- 10 green, 01 yellow, 00 gray
        finished    : out STD_LOGIC
    );
end wordle_logic;

architecture Behavioral of wordle_logic is
    constant WORD_LEN : integer := 5;
    constant MAX_ATTEMPTS : integer := 6;

    type word_t is array(0 to WORD_LEN-1) of STD_LOGIC_VECTOR(7 downto 0);
    type flag_t is array(0 to WORD_LEN-1) of STD_LOGIC_VECTOR(1 downto 0);

    constant TARGET_WORD : word_t := (x"57", x"4F", x"52", x"44", x"53"); -- W O R D S

  --  signal guess_buffer : array(0 to MAX_ATTEMPTS-1) of word_t := (others => (others => x"20")); -
    --signal flag_buffer  : array(0 to MAX_ATTEMPTS-1) of flag_t := (others => (others => "00"));

    signal current_guess : word_t := (others => x"20");
    signal current_flags : flag_t := (others => "00");

    signal current_row : INTEGER range 0 to 5 := 0;
    signal current_col : INTEGER range 0 to 5 := 0;

    signal state       : INTEGER range 0 to 3 := 0; -- 0=INPUT, 1=CHECK, 2=WAIT, 3=DONE
    signal game_done   : STD_LOGIC := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if game_done = '0' then
                case state is

                -- INPUT LETTERS
                when 0 =>
                    if ascii_new = '1' then
                        if ascii_code >= x"41" and ascii_code <= x"5A" then
                            if current_col < WORD_LEN then
                                current_guess(current_col) <= ascii_code;
                                current_col <= current_col + 1;
                            end if;
                        elsif ascii_code = x"08" then  -- backspace
                            if current_col > 0 then
                                current_col <= current_col - 1;
                                current_guess(current_col - 1) <= x"20";
                            end if;
                        elsif ascii_code = x"0D" then  -- ENTER
                            if current_col = WORD_LEN then
                                state <= 1;
                            end if;
                        end if;
                    end if;

                -- CHECK AGAINST TARGET
                when 1 =>
                    for i in 0 to WORD_LEN-1 loop
                        if current_guess(i) = TARGET_WORD(i) then
                            current_flags(i) <= "10"; -- green
                        elsif current_guess(i) = TARGET_WORD(0) or
                              current_guess(i) = TARGET_WORD(1) or
                              current_guess(i) = TARGET_WORD(2) or
                              current_guess(i) = TARGET_WORD(3) or
                              current_guess(i) = TARGET_WORD(4) then
                            current_flags(i) <= "01"; -- yellow
                        else
                            current_flags(i) <= "00"; -- gray
                        end if;
                    end loop;
                    state <= 2;

                -- STORE GUESS + FEEDBACK
                when 2 =>
                 --   guess_buffer(current_row) <= current_guess;
                  --  flag_buffer(current_row)  <= current_flags;

                    if current_guess = TARGET_WORD or current_row = MAX_ATTEMPTS-1 then
                        game_done <= '1';
                        state <= 3;
                    else
                        current_row <= current_row + 1;
                        current_col <= 0;
                        current_guess <= (others => x"20");
                        current_flags <= (others => "00");
                        state <= 0;
                    end if;

                when others =>
                    -- Game over
                    null;
                end case;
            end if;
        end if;
    end process;

    -- Debugging / External outputs
    guess_chars <= current_guess(current_col - 1) when current_col > 0 else x"20";
    letter_row  <= current_row;
    letter_col  <= current_col;
    flag_color  <= current_flags(current_col - 1) when current_col > 0 else "00";
    finished    <= game_done;

end Behavioral;
