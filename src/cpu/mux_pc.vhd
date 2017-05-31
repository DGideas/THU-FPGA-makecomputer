
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

entity mux_pc is
Port(
		pcsrc : in  STD_LOGIC_VECTOR (2 downto 0);
		input1 : in  STD_LOGIC_VECTOR (15 downto 0);--pc+2
		input2 : in  STD_LOGIC_VECTOR (15 downto 0);--¼Ä´æÆ÷
		input3 : in  STD_LOGIC_VECTOR (15 downto 0);--ALU
		output : out  STD_LOGIC_VECTOR (15 downto 0)
	);
end mux_pc;

architecture Behavioral of mux_pc is

begin
process(pcsrc)
	begin 
	   case pcsrc is
		  when "000"=>output<=input1;
		  when "001"=>output<=input2;
		  when "010"=>
		  if input2="0000000000000000"then
		  output<=input3;
		  else
		  output<=input1;
		  end if;
		  when "011"=>
		  if input2="0000000000000000"then
		  output<=input1;
		  else
		  output<=input3;
		  end if;
		  when "100"=>
		  output<=input3;
		  when others => null;
		end case;
	end process;

end Behavioral;
