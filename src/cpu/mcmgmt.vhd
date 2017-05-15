library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity mcmgmt is
	port
	(
		mcmgmt_clk: in std_logic;
		mcmgmt_rst: in std_logic;
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
		mcmgmt_free: out std_logic;
		mcmgmt_int: out std_logic;
		mcmgmt_debug_status: out std_logic_vector(4 downto 0)
	);
end mcmgmt;

architecture Behavioral of mcmgmt is

signal mcmgmt_status: std_logic_vector(4 downto 0) := "00001";
signal mcmgmt_rst_cache: std_logic := '1';

begin

mcmgmt_debug_status <= mcmgmt_status;

process (mcmgmt_clk)
begin
	mcmgmt_rst_cache <= mcmgmt_rst;
	if (mcmgmt_rst = '0' and mcmgmt_rst_cache = '1') then
		--mcmgmt_status <= "00000";
		mcmgmt_status <= "00001";
		mcmgmt_free <= '1';
		mcmgmt_int <= '0';
		mcmgmt_odata <= "0000000000000000";
	else
		if (rising_edge(mcmgmt_clk)) then
			if (mcmgmt_status = "00000") then
				mcmgmt_free <= '1';
				mcmgmt_int <= '0';
			else
				case mcmgmt_status is
					when "00001" =>
						mcmgmt_port_mem1_oe <= '1';
						mcmgmt_port_mem1_en <= '1';
						mcmgmt_port_mem1_we <= '0';
						mcmgmt_port_mem1_addr <= "000000000000000000";
						mcmgmt_port_mem1_data <= "0000000000000010";
						mcmgmt_status <= "00010";
					when "00010" =>
						mcmgmt_status <= "00011";
					when "00011" =>
						mcmgmt_port_mem1_oe <= '0';
						mcmgmt_port_mem1_en <= '1';
						mcmgmt_port_mem1_we <= '1';
						mcmgmt_port_mem1_addr <= "000000000000000000";
						mcmgmt_port_mem1_data <= "ZZZZZZZZZZZZZZZZ";
						mcmgmt_status <= "00100";
					when "00100" =>
						mcmgmt_status <= "00000";
						mcmgmt_odata <= mcmgmt_port_mem1_data;
					when others =>
						null;
				end case;
			end if;
		end if;
	end if;
end process;

end Behavioral;

