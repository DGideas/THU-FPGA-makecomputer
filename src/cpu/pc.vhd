library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pc is
	port
	(
		pc_in: in std_logic_vector(15 downto 0);
		pc_out: out std_logic_vector(15 downto 0);
		pc_clk: in std_logic;
		pc_rst: in std_logic	
	);
end pc;

architecture Behavioral of pc is

begin

process(pc_clk, pc_rst)
	begin
		if (pc_rst = '0') then
			pc_out <= "0000000000000000";
		elsif (clk'event and clk='1') then
			pc_out <= pc_in ;
		end if;
end process;

end Behavioral;