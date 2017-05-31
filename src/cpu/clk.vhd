library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clk is
	port
	(
		clk_port_clk: in std_logic;
		clk_clk: out std_logic
	);
end clk;

architecture Behavioral of clk is
begin

clk_clk <= clk_port_clk;

end Behavioral;

