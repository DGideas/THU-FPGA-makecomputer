library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu is
	port
	(
		alu_input1: in std_logic_vector(15 downto 0);
		alu_input2: in std_logic_vector(15 downto 0);
		alu_output: out std_logic_vector(15 downto 0);
		alu_operator: in std_logic_vector(2 downto 0)
	);
end alu;

architecture Behavioral of alu is

begin

process(alu_operator, alu_input1, alu_input2)
variable a :std_logic_vector(15 downto 0);
begin
	case alu_operator is
		when "000" =>
			alu_output <= alu_input1 + alu_input2;
		when "001" =>
			alu_output <= alu_input1 - alu_input2;
		when "010" =>
			alu_output <= alu_input1 and alu_input2;
		when "011" =>
			alu_output <= alu_input1 or alu_input2;
		when "100" =>
			a := alu_input1 xor alu_input2;
			if(a="0000000000000000")then
			alu_output<="0000000000000000";
			else
			alu_output<="0000000000000001";
         end if;			
		when "101" =>
			alu_output <= to_stdlogicvector(to_bitvector(alu_input1) sll conv_integer(alu_input2));
		when "110" =>
			alu_output <= to_stdlogicvector(to_bitvector(alu_input1) sra conv_integer(alu_input2));
		when others =>
			alu_output <= "0000000000000000";
	end case;
end process;

end Behavioral;

