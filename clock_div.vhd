----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2025 12:54:34 PM
-- Design Name:  
-- Module Name: clock_divider - Behavioral
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
use ieee.numeric_std.all;

entity clock_div is
port(
    clk: in std_logic;  -- 125 MHz clock 
    div: out std_logic  -- divided clock (1 Hz)
  
);
end clock_div;

architecture Behavioral of clock_div is
    signal divider : std_logic ;
    signal counter : std_logic_vector(3 downto 0) := (others => '0');
begin

    process(clk) 
    begin
        if rising_edge(clk) then
            if unsigned(counter) = 4 then
                counter <= (others => '0');  -- Reset divider to 0
                divider <= '1';    -- Toggle counter to generate clock signal
            else
                counter <= std_logic_vector(unsigned(counter) + 1);  -- Increment divider
                divider <= '0'; 
            end if;
        end if;
    end process;

    div <= divider;  -- Output the divided clock signal
   
end Behavioral;