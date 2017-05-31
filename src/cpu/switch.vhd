library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity switch is
	port
	(
		switch_port_switch: in std_logic_vector(15 downto 0);
		switch_switch: out std_logic_vector(15 downto 0)
	);
end switch;

architecture Behavioral of switch is
begin

switch_switch <= switch_port_switch;

end Behavioral;

