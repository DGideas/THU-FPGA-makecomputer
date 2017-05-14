library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cpu_top is
	Port
	(
		port_clk_50: in std_logic;
		port_clk_key: in std_logic;
		port_rst: in std_logic;
		port_mem1_oe: out std_logic;
		port_mem1_we: out std_logic;
		port_mem1_en: out std_logic;
		port_mem1_addr: out std_logic_vector(17 downto 0);
		port_mem1_data: inout std_logic_vector(15 downto 0);
		port_led: out std_logic_vector(15 downto 0)
	);
end cpu_top;

architecture Behavioral of cpu_top is

component clk is
	Port
	(
		clk_port_clk: in std_logic;
		clk_clk: out std_logic
	);
end component;
signal internal_clk: std_logic;

component rstkey is
	port
	(
		rstkey_port_rst: in std_logic;
		rstkey_rst: out std_logic
	);
end component;
signal internel_rst: std_logic;

component clkkey is
	port
	(
		clkkey_port_clk: in std_logic;
		clkkey_clk: out std_logic
	);
end component;
signal internel_clk_singlestep: std_logic;

component led is
	Port
	(
		led_port_led: out std_logic_vector(15 downto 0);
		led_data: in std_logic_vector(15 downto 0)
	);
end component;

component mcmgmt is
	Port
	(
		mcmgmt_port_clk: in std_logic;
		mcmgmt_port_mem1_oe: out std_logic;
		mcmgmt_port_mem1_we: out std_logic;
		mcmgmt_port_mem1_en: out std_logic;
		mcmgmt_port_mem1_addr: out std_logic_vector(17 downto 0);
		mcmgmt_port_mem1_data: inout std_logic_vector(15 downto 0);
		mcmgmt_addr: in std_logic_vector(19 downto 0);
		mcmgmt_data: inout std_logic_vector(15 downto 0);
		mcmgmt_rw: in std_logic;
		mcmgmt_by_byte: in std_logic;
		mcmgmt_byte_select: in std_logic;
		mcmgmt_free: out std_logic
	);
end component;
signal internel_mcmgmt_data: std_logic_vector(15 downto 0);
signal internel_mcmgmt_free: std_logic;

begin

clk1: clk port map
(
	port_clk_50, internal_clk
);

rst1: rstkey port map
(
	port_rst, internel_rst
);

clkkey1: clkkey port map
(
	port_clk_key, internel_clk_singlestep
);

led1: led port map
(
	port_led, "1111111111111111"
);

mcmgmt1: mcmgmt port map
(
	internal_clk, port_mem1_oe, port_mem1_we, port_mem1_en, port_mem1_addr, port_mem1_data,
	"00000000000000000000", internel_mcmgmt_data, '1', '1', '1', internel_mcmgmt_free
);

end Behavioral;

