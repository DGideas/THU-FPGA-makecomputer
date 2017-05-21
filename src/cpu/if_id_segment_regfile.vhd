library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity if_id_segment_regfile is
	port
	(
		if_id_segment_regfile_clk: in std_logic;
		if_id_segment_regfile_write_in: in std_logic;
		if_id_segment_regfile_instruction_in: in std_logic_vector(15 downto 0);
		if_id_segment_regfile_instruction_out: out std_logic_vector(15 downto 0);
		if_id_segment_regfile_pc_in: in std_logic_vector(15 downto 0);
		if_id_segment_regfile_pc_out: out std_logic_vector(15 downto 0)
	);
end if_id_segment_regfile;

architecture Behavioral of if_id_segment_regfile is
begin

process(if_id_segment_regfile_clk, if_id_segment_regfile_write_in)
begin
	if (if_id_segment_regfile_write_in = '1') then
		if_id_segment_regfile_pc_out <= if_id_segment_regfile_pc_in;
		if_id_segment_regfile_instruction_out <= if_id_segment_regfile_instruction_in;
	end if;
end process;

end Behavioral;