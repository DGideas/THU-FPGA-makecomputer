----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:10:20 05/21/2017 
-- Design Name: 
-- Module Name:    mux_result - Behavioral 
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

entity mux_result is
 Port (    alusrc : in  STD_LOGIC_VECTOR (1 downto 0);
           mux_alures : in  STD_LOGIC_VECTOR (15 downto 0);
           mux_menres : in STD_LOGIC_VECTOR (15 downto 0);
           mux_dataC : out  STD_LOGIC_VECTOR (15 downto 0));
end mux_result;

architecture Behavioral of mux_result is

begin
process(alusrc)
begin
 case alusrc is
    when "00"=>
	   mux_dataC<=mux_alures;
	 when "01"=>
	   mux_dataC<=mux_menres;
	 when others=>null;
	end case;
end process;

end Behavioral;

