library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity add_pc is
	Port(
		input1 : in  STD_LOGIC_VECTOR(15 downto 0);
		input2 : in  STD_LOGIC_VECTOR(15 downto 0);
		output : out STD_LOGIC_VECTOR(15 downto 0)
	);
end add_pc;

architecture Behavioral of add_pc is
begin
process(input1)
begin
	output <= input1 + input2;
	end process;
end Behavioral;
