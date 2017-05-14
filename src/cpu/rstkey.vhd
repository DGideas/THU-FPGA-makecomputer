library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rstkey is
	port
	(
		rstkey_port_rst: in std_logic;
		rstkey_rst: out std_logic
	);
end rstkey;

architecture Behavioral of rstkey is

begin

rstkey_rst <= rstkey_port_rst;

end Behavioral;

