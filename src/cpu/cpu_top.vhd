library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cpu_top is
	Port
	(
		port_clk_50: in std_logic; --50MHz clock
		port_clk_key: in std_logic; --One-Step clk key
		port_switch: in std_logic_vector(15 downto 0); --On-board switch
		port_rst: in std_logic; --Reset key
		port_mem1_oe: out std_logic; --Memory#1 signal
		port_mem1_we: out std_logic;
		port_mem1_en: out std_logic;
		port_mem1_addr: out std_logic_vector(17 downto 0);
		port_mem1_data: inout std_logic_vector(15 downto 0);
		port_mem2_oe: out std_logic; --Memory#1 signal
		port_mem2_we: out std_logic;
		port_mem2_en: out std_logic;
		port_mem2_addr: out std_logic_vector(17 downto 0);
		port_mem2_data: inout std_logic_vector(15 downto 0);
		port_com_data_ready: in std_logic; --COM signal
		port_com_rdn: out std_logic;
		port_com_tbre: inout std_logic;
		port_com_tsre: inout std_logic;
		port_com_wrn: out std_logic;
		port_led: out std_logic_vector(0 to 15) --On-board LED
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
		mcmgmt_port_mem2_oe: out std_logic;
		mcmgmt_port_mem2_we: out std_logic;
		mcmgmt_port_mem2_en: out std_logic;
		mcmgmt_port_mem2_addr: out std_logic_vector(17 downto 0);
		mcmgmt_port_mem2_data: inout std_logic_vector(15 downto 0);
		mcmgmt_port_com_data_ready: in std_logic;
		mcmgmt_port_com_rdn: out std_logic;
		mcmgmt_port_com_tbre: inout std_logic;
		mcmgmt_port_com_tsre: inout std_logic;
		mcmgmt_port_com_wrn: out std_logic;
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

component alu is
	port
	(
		alu_input1: in std_logic_vector(15 downto 0);
		alu_input2: in std_logic_vector(15 downto 0);
		alu_output: out std_logic_vector(15 downto 0);
		alu_operator: in std_logic_vector(2 downto 0)
	);
end component;

begin

clk1: clk port map
(
	clk_port_clk => port_clk_50,
	clk_clk => internal_clk
);

rst1: rstkey port map
(
	rstkey_port_rst => port_rst,
	rstkey_rst => internal_rst
);

clkkey1: clkkey port map
(
	clkkey_port_clk => port_clk_key,
	clkkey_clk => internal_debug_clk
);

switch1: switch port map
(
	switch_port_switch => port_switch,
	switch_switch => internal_switch
);

led1: led port map
(
	led_port_led => port_led,
	led_data => internal_debug
);

mcmgmt1: mcmgmt port map
(
	mcmgmt_clk => internal_clk,
	mcmgmt_rst => internal_rst,
	mcmgmt_port_mem1_oe => port_mem1_oe,
	mcmgmt_port_mem1_we => port_mem1_we,
	mcmgmt_port_mem1_en => port_mem1_en,
	mcmgmt_port_mem1_addr => port_mem1_addr,
	mcmgmt_port_mem1_data => port_mem1_data,
	mcmgmt_port_mem2_oe => port_mem2_oe,
	mcmgmt_port_mem2_we => port_mem2_we,
	mcmgmt_port_mem2_en => port_mem2_en,
	mcmgmt_port_mem2_addr => port_mem2_addr,
	mcmgmt_port_mem2_data => port_mem2_data,
	mcmgmt_port_com_data_ready => port_com_data_ready,
	mcmgmt_port_com_rdn => port_com_rdn,
	mcmgmt_port_com_tbre => port_com_tbre,
	mcmgmt_port_com_tsre => port_com_tsre,
	mcmgmt_port_com_wrn => port_com_wrn,
	mcmgmt_addr => "00000000000000000000",
	mcmgmt_idata => "1111111111111111",
	mcmgmt_odata => open,
	mcmgmt_rw => '1',
	mcmgmt_by_byte => '1',
	mcmgmt_byte_select => '1',
	mcmgmt_free => internal_mcmgmt_free,
	mcmgmt_int => open,
	mcmgmt_debug_status => internal_mcmgmt_debug_status
);

internal_debug <= internal_mcmgmt_debug_status & "01010101011";

end Behavioral;

