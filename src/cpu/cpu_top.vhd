library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cpu_top is
	Port
	(
		port_clk_50: in std_logic;
		port_clk_key: in std_logic;
		port_switch: in std_logic_vector(15 downto 0);
		port_rst: in std_logic;
		port_mem1_oe: out std_logic;
		port_mem1_we: out std_logic;
		port_mem1_en: out std_logic;
		port_mem1_addr: out std_logic_vector(17 downto 0);
		port_mem1_data: inout std_logic_vector(15 downto 0);
		port_led: out std_logic_vector(0 to 15)
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
signal internal_rst: std_logic;

component clkkey is
	port
	(
		clkkey_port_clk: in std_logic;
		clkkey_clk: out std_logic
	);
end component;
signal internal_debug_clk: std_logic;

component switch is
	port
	(
		switch_port_switch: in std_logic_vector(15 downto 0);
		switch_switch: out std_logic_vector(15 downto 0)
	);
end component;
signal internal_switch: std_logic_vector(15 downto 0);

component led is
	port
	(
		led_port_led: out std_logic_vector(0 to 15);
		led_data: in std_logic_vector(15 downto 0)
	);
end component;
signal internal_debug: std_logic_vector(15 downto 0) := "0000000000000000";

component mcmgmt is
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
end component;
signal internal_mcmgmt_data: std_logic_vector(15 downto 0);
signal internal_mcmgmt_free: std_logic;
signal internal_mcmgmt_debug_status: std_logic_vector(4 downto 0);

begin

clk1: clk port map
(
	port_clk_50, internal_clk
);

rst1: rstkey port map
(
	port_rst, internal_rst
);

clkkey1: clkkey port map
(
	port_clk_key, internal_debug_clk
);

switch1: switch port map
(
	port_switch, internal_switch
);

led1: led port map
(
	port_led, internal_debug
);

mcmgmt1: mcmgmt port map
(
	internal_debug_clk, internal_rst, port_mem1_oe, port_mem1_we, port_mem1_en, port_mem1_addr, port_mem1_data,
	"00000000000000000000", "1111111111111111",  internal_debug, '1', '1', '1', internal_mcmgmt_free, open, internal_mcmgmt_debug_status
);


end Behavioral;

