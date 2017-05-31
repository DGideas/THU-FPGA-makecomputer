----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:09:41 05/06/2017 
-- Design Name: 
-- Module Name:    Mux_reg1 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux_reg1 is
    Port ( alusrca : in  STD_LOGIC_VECTOR (1 downto 0);
           muxreg1 : in  STD_LOGIC_VECTOR (15 downto 0);
           mux_PC : in  STD_LOGIC_VECTOR (15 downto 0);
           mux_dataA : out  STD_LOGIC_VECTOR (15 downto 0));
end mux_reg1;

architecture Behavioral of mux_reg1 is

begin
process(alusrca)
begin
case alusrca is
when "00"=>
 mux_dataA<=muxreg1;
when "01"=>
 mux_dataA<=mux_PC;
when others=>null;
end case;
end process;

end Behavioral;

