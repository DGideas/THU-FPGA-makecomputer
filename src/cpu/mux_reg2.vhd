----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:25:11 05/06/2017 
-- Design Name: 
-- Module Name:    Mux_reg2 - Behavioral 
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

entity mux_reg2 is
    Port ( alusrcb : in  STD_LOGIC_VECTOR (1 downto 0);
           muxreg2 : in  STD_LOGIC_VECTOR (15 downto 0);
           mux_imm : in STD_LOGIC_VECTOR (15 downto 0);
           mux_dataB : out  STD_LOGIC_VECTOR (15 downto 0));
end mux_reg2;

architecture Behavioral of mux_reg2 is

begin
process(alusrcb)
begin
 case alusrcb is
    when "00"=>
	   mux_dataB<=muxreg2;
	 when "01"=>
	   mux_dataB<=mux_imm;
	 when others=>null;
	end case;
end process;


end Behavioral;

