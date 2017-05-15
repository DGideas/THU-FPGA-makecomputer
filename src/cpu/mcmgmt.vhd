library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity mcmgmt is
	port
	(
		mcmgmt_port_clk: in std_logic;
		mcmgmt_port_mem1_oe: out std_logic;
		mcmgmt_port_mem1_we: out std_logic;
		mcmgmt_port_mem1_en: out std_logic;
		mcmgmt_port_mem1_addr: out std_logic_vector(17 downto 0);
		mcmgmt_port_mem1_data: inout std_logic_vector(15 downto 0);
		mcmgmt_addr: in std_logic_vector(19 downto 0);
		mcmgmt_idata: in std_logic_vector(15 downto 0);
		mcmgmt_odata: out std_logic_vector(15 downto 0);
		mcmgmt_rw: in std_logic;
		mcmgmt_by_byte: in std_logic;
		mcmgmt_byte_select: in std_logic;
		mcmgmt_free: out std_logic
	);
end mcmgmt;

architecture Behavioral of mcmgmt is

signal mcmgmt_status: std_logic_vector(4 downto 0) := "00000";

begin

process (mcmgmt_port_clk)
begin
	mcmgmt_status <= "00000";
end process;

end Behavioral;

