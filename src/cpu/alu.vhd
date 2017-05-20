library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu is
	Port(
		Input1 : in  STD_LOGIC_VECTOR (15 downto 0);
		Input2 : in  STD_LOGIC_VECTOR (15 downto 0);
		Output : out  STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";
		ALUop : in  STD_LOGIC_VECTOR (2 downto 0)
	);
end alu;

architecture Behavioral of alu is

begin

	process(ALUop, Input1, Input2)
	begin
		case ALUop is
			when "000" =>output <= input1 + input2;
			when "001" =>output <= input1 - input2;
			when "010" =>output <= input1 and input2;
			when "011" =>output <= input1 or input2;
                        when "100" =>output <= input1 xor input2;
			when "101" =>output <= TO_STDLOGICVECTOR(TO_BITVECTOR(input1) sll CONV_INTEGER(input2));
			when "110" =>output <= TO_STDLOGICVECTOR(TO_BITVECTOR(input1) sra CONV_INTEGER(input2));
			when others =>output<="0000000000000000";
		end case;
	end process;

end Behavioral;

