library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clkkey is
	port
	(
		clkkey_port_clk: in std_logic;
		clkkey_clk: out std_logic
	);
end clkkey;

architecture Behavioral of clkkey is
begin

clkkey_clk <= clkkey_port_clk;

end Behavioral;

