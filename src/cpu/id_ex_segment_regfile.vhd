library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity id_ex_segment_regfile is
    port
	(
		id_ex_segment_regfile_clk : in  std_logic;
		id_ex_segment_regfile_write_in : in  std_logic;
		id_ex_segment_regfile_rdata1_in : in  std_logic_vector (15 downto 0);
		id_ex_segment_regfile_rdata2_in : in  std_logic_vector (15 downto 0);
		id_ex_segment_regfile_rdata1_out : out  std_logic_vector (15 downto 0);
		id_ex_segment_regfile_rdata2_out : out  std_logic_vector (15 downto 0);
		id_ex_segment_regfile_pc_in : in  std_logic_vector (15 downto 0);
		id_ex_segment_regfile_pc_out : out  std_logic_vector (15 downto 0);
		id_ex_segment_regfile_alu_op_in : in  std_logic_vector (2 downto 0);
		id_ex_segment_regfile_alu_op_out : out  std_logic_vector (2 downto 0);
		id_ex_segment_regfile_reg_rx_in : in  std_logic_vector (15 downto 0);
		id_ex_segment_regfile_reg_rx_out : out  std_logic_vector (15 downto 0);
		id_ex_segment_regfile_mem_we_in : in  std_logic;
		id_ex_segment_regfile_mem_we_out : out  std_logic;
		id_ex_segment_regfile_pc_src_in : in   std_logic_vector (2 downto 0);
		id_ex_segment_regfile_pC_src_out : out  std_logic_vector (2 downto 0);
		id_ex_segment_regfile_reg_ry_in : in  std_logic_vector (15 downto 0);
		id_ex_segment_regfile_reg_ry_out : out  std_logic_vector (15 downto 0);
		id_ex_segment_regfile_src_result_in : in   std_logic_vector (1 downto 0);
		id_ex_segment_regfile_src_result_out : out  std_logic_vector (1 downto 0);
		id_ex_segment_regfile_reg_we_in : in  std_logic;
		id_ex_segment_regfile_reg_we_out : out  std_logic;
		id_ex_segment_regfile_we_result_in:  in std_logic_vector (1 downto 0);
   	id_ex_segment_regfile_we_result_out: out  std_logic_vector (1 downto 0);
		id_ex_segment_regfile_imm_in : in  std_logic_vector (15 downto 0);
		id_ex_segment_regfile_imm_out : out  std_logic_vector (15 downto 0));
end id_ex_segment_regfile;

architecture Behavioral of id_ex_segment_regfile is

begin
process (id_ex_segment_regfile_clk, id_ex_segment_regfile_write_in)
begin	
	if (id_ex_segment_regfile_write_in = '1') then
		id_ex_segment_regfile_rdata1_out <= id_ex_segment_regfile_rdata1_in;
		id_ex_segment_regfile_rdata2_out <= id_ex_segment_regfile_rdata2_in;
		id_ex_segment_regfile_pc_out <= id_ex_segment_regfile_pc_in;
		id_ex_segment_regfile_alu_op_out <= id_ex_segment_regfile_alu_op_in;
		id_ex_segment_regfile_reg_rx_out <= id_ex_segment_regfile_reg_rx_in;
		id_ex_segment_regfile_reg_ry_out <= id_ex_segment_regfile_reg_ry_in;
		id_ex_segment_regfile_mem_we_out <= id_ex_segment_regfile_mem_we_in;
		id_ex_segment_regfile_pC_src_out <= id_ex_segment_regfile_pc_src_in;
		id_ex_segment_regfile_src_result_out <= id_ex_segment_regfile_src_result_in;
		id_ex_segment_regfile_reg_we_out <= id_ex_segment_regfile_reg_we_in;
		id_ex_segment_regfile_imm_out <= id_ex_segment_regfile_imm_in;
	end if;
end process;

end Behavioral;