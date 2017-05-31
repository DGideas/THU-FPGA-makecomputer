library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity mem_we_segment_regfile is
	port
	(
		mem_we_segment_regfile_clk: in std_logic;
		mem_we_segment_regfile_write_in: in std_logic;
		mem_we_segment_regfile_result_in: in std_logic_vector(15 downto 0);
		mem_we_segment_regfile_result_out: out std_logic_vector(15 downto 0);
		mem_we_segment_regfile_reg_we_in: in std_logic;
		mem_we_segment_regfile_reg_we_out: out std_logic;
		mem_we_segment_regfile_we_result_in:  in std_logic_vector (1 downto 0);
   	mem_we_segment_regfile_we_result_out: out  std_logic_vector (1 downto 0);
		mem_we_segment_regfile_imm_in: in std_logic_vector(15 downto 0);
		mem_we_segment_regfile_imm_out: out std_logic_vector(15 downto 0)
	);
end mem_we_segment_regfile;

architecture Behavioral of mem_we_segment_regfile is

begin

process (mem_we_segment_regfile_clk, mem_we_segment_regfile_write_in)
begin
	if (mem_we_segment_regfile_write_in = '1') then
		mem_we_segment_regfile_result_out <= mem_we_segment_regfile_result_in;
		mem_we_segment_regfile_reg_we_out <= mem_we_segment_regfile_reg_we_in;
		mem_we_segment_regfile_imm_out <= mem_we_segment_regfile_imm_in;
	end if;

end process;

end Behavioral;