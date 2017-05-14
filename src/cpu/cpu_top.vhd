library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cpu_top is
	Port
	(
		port_clk_50: in std_logic;
		port_mem1_oe: out std_logic;
		port_mem1_we: out std_logic;
		port_mem1_en: out std_logic;
		port_mem1_addr: out std_logic_vector(17 downto 0);
		port_mem1_data: inout std_logic_vector(15 downto 0)
	);
end cpu_top;

architecture Behavioral of cpu_top is

component mcmgmt is
	Port
	(
		mcmgmt_port_clk: in std_logic;
		mcmgmt_port_mem1_oe: out std_logic;
		mcmgmt_port_mem1_we: out std_logic;
		mcmgmt_port_mem1_en: out std_logic;
		mcmgmt_port_mem1_addr: out std_logic_vector(17 downto 0);
		mcmgmt_port_mem1_data: inout std_logic_vector(15 downto 0)
	);
end component;

begin

mcmgmt1: mcmgmt port map
(
	port_clk_50, port_mem1_oe, port_mem1_we, port_mem1_en, port_mem1_addr, port_mem1_data
);

end Behavioral;

