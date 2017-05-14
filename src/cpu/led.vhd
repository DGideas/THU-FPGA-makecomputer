library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity led is
	Port
	(
		led_port_led: out std_logic_vector(15 downto 0);
		led_data: in std_logic_vector(15 downto 0)
	);
end led;

architecture Behavioral of led is
begin

led_port_led <= led_data;

end Behavioral;

