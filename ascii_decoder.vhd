----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- "
-- Create Date: 05/06/2025 09:05:08 PM
-- Design Name: 
-- Module Name: ascii_decoder - Behavioral
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



entity ascii_decoder is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        scancode    : in  STD_LOGIC_VECTOR(7 downto 0);
        key_pressed : in  STD_LOGIC;
        ascii       : out STD_LOGIC_VECTOR(7 downto 0);
        valid       : out STD_LOGIC
    );
end ascii_decoder ;

architecture Behavioral of ascii_decoder  is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                ascii <= (others => '0');
                valid <= '0';
            else
                valid <= '0';
                
                if key_pressed = '1' then
                    case scancode is
                       --LETTERS
                        when x"1C" => ascii <= x"41"; valid <= '1'; -- A
                        when x"32" => ascii <= x"42"; valid <= '1'; -- B
                        when x"21" => ascii <= x"43"; valid <= '1'; -- C
                        when x"23" => ascii <= x"44"; valid <= '1'; -- D
                        when x"24" => ascii <= x"45"; valid <= '1'; -- E
                        when x"2B" => ascii <= x"46"; valid <= '1'; -- F
                        when x"34" => ascii <= x"47"; valid <= '1'; -- G
                        when x"33" => ascii <= x"48"; valid <= '1'; -- H
                        when x"43" => ascii <= x"49"; valid <= '1'; -- I
                        when x"3B" => ascii <= x"4A"; valid <= '1'; -- J
                        when x"42" => ascii <= x"4B"; valid <= '1'; -- K
                        when x"4B" => ascii <= x"4C"; valid <= '1'; -- L
                        when x"3A" => ascii <= x"4D"; valid <= '1'; -- M
                        when x"31" => ascii <= x"4E"; valid <= '1'; -- N
                        when x"44" => ascii <= x"4F"; valid <= '1'; -- O
                        when x"4D" => ascii <= x"50"; valid <= '1'; -- P
                        when x"15" => ascii <= x"51"; valid <= '1'; -- Q
                        when x"2D" => ascii <= x"52"; valid <= '1'; -- R
                        when x"1B" => ascii <= x"53"; valid <= '1'; -- S
                        when x"2C" => ascii <= x"54"; valid <= '1'; -- T
                        when x"3C" => ascii <= x"55"; valid <= '1'; -- U
                        when x"2A" => ascii <= x"56"; valid <= '1'; -- V
                        when x"1D" => ascii <= x"57"; valid <= '1'; -- W
                        when x"22" => ascii <= x"58"; valid <= '1'; -- X
                        when x"35" => ascii <= x"59"; valid <= '1'; -- Y
                        when x"1A" => ascii <= x"5A"; valid <= '1'; -- Z  
                    
                        -- ENTER AND BACKSPACE
                        when x"5A" => ascii <= x"0D"; valid <= '1'; -- Enter
                        when x"66" => ascii <= x"08"; valid <= '1'; -- Backspace
                        
                        -- Others can be added as needed
                        when others => valid <= '0';
                    end case;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
