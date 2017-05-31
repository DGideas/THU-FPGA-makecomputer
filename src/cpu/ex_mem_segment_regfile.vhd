library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ex_mem_segment_regfile is
	port
	(
		ex_mem_segment_regfile_clk: in std_logic;
		ex_mem_segment_regfile_write_in: in std_logic;
		ex_mem_segment_regfile_alu_result_in: in std_logic_vector(15 downto 0);
		ex_mem_segment_regfile_alu_result_out: out std_logic_vector(15 downto 0);
		ex_mem_segment_regfile_mem_we_in: in std_logic;
		ex_mem_segment_regfile_mem_we_out: out std_logic;
		ex_mem_segment_regfile_reg_ry_in: in std_logic_vector(15 downto 0);
		ex_mem_segment_regfile_reg_ry_out: out std_logic_vector(15 downto 0);
		ex_mem_segment_regfile_src_result_in: in std_logic_vector(1 downto 0);
		ex_mem_segment_regfile_src_result_out: out std_logic_vector(1 downto 0);
		ex_mem_segment_regfile_reg_we_in: in std_logic;
		ex_mem_segment_regfile_reg_we_out: out std_logic;
		ex_mem_segment_regfile_we_result_in:  in std_logic_vector (1 downto 0);
   	ex_mem_segment_regfile_we_result_out: out  std_logic_vector (1 downto 0);
		ex_mem_segment_regfile_imm_in: in std_logic_vector(15 downto 0);
		ex_mem_segment_regfile_imm_out: out std_logic_vector(15 downto 0)
	);
end ex_mem_segment_regfile;

architecture Behavioral of ex_mem_segment_regfile is

begin
process (ex_mem_segment_regfile_clk, ex_mem_segment_regfile_write_in)
begin
		if (ex_mem_segment_regfile_write_in = '1') then
			ex_mem_segment_regfile_alu_result_out <= ex_mem_segment_regfile_alu_result_in;
			ex_mem_segment_regfile_reg_ry_out <= ex_mem_segment_regfile_reg_ry_in;
			ex_mem_segment_regfile_mem_we_out <= ex_mem_segment_regfile_mem_we_in;
			ex_mem_segment_regfile_src_result_out <= ex_mem_segment_regfile_src_result_in;
			ex_mem_segment_regfile_reg_we_out <= ex_mem_segment_regfile_reg_we_in;
			ex_mem_segment_regfile_imm_out <= ex_mem_segment_regfile_imm_in;
		end if;
end process;

end Behavioral;