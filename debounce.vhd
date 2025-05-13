----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2025 05:27:08 PM
-- Design Name: 
-- Module Name: debounce - Behavioral
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

entity debounce is
port(clk: in std_logic ;
     btn: in std_logic ;
     dbnc: out std_logic );
end debounce;

architecture Behavioral of debounce is
    signal shift_reg : std_logic_vector(1 downto 0) := "00";  -- 2-bit shift register
    signal counter   : std_logic_vector (21 downto 0):= (others=>'0') ; --2500000 ticks
    signal sig_dbnc : std_logic:='0' ; 
begin
    process(clk)
    begin
        if rising_edge(clk) then
            shift_reg(0) <= btn;
            shift_reg(1) <= shift_reg(0);

            if shift_reg(1) = '1' then
                if (unsigned(counter)<1250000)  then
                    counter <= std_logic_vector (unsigned(counter) + 1);  
                   
              
                elsif (unsigned(counter)=1250000)then
                sig_dbnc <= '1';  
             
               
                 end if;
             else 
                 sig_dbnc <='0';
                 counter <= (others => '0');
            end if;
        end if;
    end process;
  
   
  dbnc<=sig_dbnc ;
    
end Behavioral;