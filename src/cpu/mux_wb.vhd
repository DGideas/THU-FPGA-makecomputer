
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:26:52 05/21/2017 
-- Design Name: 
-- Module Name:    mux_pc1 - Behavioral 
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

entity mux_wb is
Port(
		regsrc : in  STD_LOGIC_VECTOR(1 downto 0);
		input1 : in  STD_LOGIC_VECTOR (15 downto 0);
		input2 : in  STD_LOGIC_VECTOR (15 downto 0);
		output : out  STD_LOGIC_VECTOR (15 downto 0)
	);
end mux_wb;

architecture Behavioral of mux_wb is

begin
process(regsrc)
	begin 
	   case regsrc is
		  when "00"=>output<=input1;
		  when "01"=>output<=input2;

		  when others => null;
		end case;
	end process;

end Behavioral;
