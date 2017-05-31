library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity regfile is
	port
	(
		regfile_clk: in std_logic;
		regfile_rst: in std_logic;
		regfile_we: in std_logic;
		regfile_waddr: in std_logic_vector(3 downto 0);
		regfile_wdata: in std_logic_vector(15 downto 0);
		regfile_raddr1: in std_logic_vector(3 downto 0);
		regfile_rdata1: out std_logic_vector(15 downto 0);
		regfile_raddr2: in std_logic_vector(3 downto 0);
		regfile_rdata2: out std_logic_vector(15 downto 0)
	);
end regfile;

architecture Behavioral of regfile is
signal r0, r2, r3, r4, r5, r6, r7, r8, r9: std_logic_vector(15 downto 0) := "0000000000000001";
signal r1: std_logic_vector(15 downto 0) := "0000000000000010";
signal r10: std_logic_vector(15 downto 0);
begin

process(regfile_clk, regfile_rst, regfile_we)
begin
	if (regfile_rst = '0') then
		regfile_rdata1 <= "0000000000000000";
		regfile_rdata2 <= "0000000000000000";
	else
				case regfile_raddr1 is
					when "0000" =>
						regfile_rdata1 <= r0;
					when "0001" =>
						regfile_rdata1 <= r1;
					when "0010" =>
						regfile_rdata1 <= r2;
					when "0011" =>
						regfile_rdata1 <= r3;
					when "0100" =>
						regfile_rdata1 <= r4;
					when "0101" =>
						regfile_rdata1 <= r5;
					when "0110" =>
						regfile_rdata1 <= r6;
					when "0111" =>
						regfile_rdata1 <= r7;
					when "1000" =>
						regfile_rdata1 <= r8;--sp
					when "1001" =>
						regfile_rdata1 <= r9;--ih
					when "1010" =>
						regfile_rdata1 <= r10;--t
					when others =>
						null;
				end case;
				case regfile_raddr2 is
					when "0000" =>
						regfile_rdata2 <= r0;
					when "0001" =>
						regfile_rdata2 <= r1;
					when "0010" =>
						regfile_rdata2 <= r2;
					when "0011" =>
						regfile_rdata2 <= r3;
					when "0100" =>
						regfile_rdata2 <= r4;
					when "0101" =>
						regfile_rdata2 <= r5;
					when "0110" =>
						regfile_rdata2 <= r6;
					when "0111" =>
						regfile_rdata2 <= r7;
					when "1000" =>
						regfile_rdata2 <= r8;--sp
					when "1001" =>
						regfile_rdata2 <= r9;--ih
					when "1010" =>
						regfile_rdata2 <= r10;--t
					when others =>
						null;
				end case;
			if(regfile_we='1')then
				if (regfile_clk'event and regfile_clk='0') then
					case regfile_waddr is
						when "0000" =>
							r0 <= regfile_wdata;
						when "0001" =>
							r1 <= regfile_wdata;
						when "0010" =>
							r2 <= regfile_wdata;
						when "0011" =>
							r3 <= regfile_wdata;
						when "0100" =>
							r4 <= regfile_wdata;
						when "0101" =>
							r5 <= regfile_wdata;
						when "0110" =>
							r6 <= regfile_wdata;
						when "0111" =>
							r7 <= regfile_wdata;
						when "1000" =>
							r8 <= regfile_wdata;--sp
						when "1001" =>
							r9 <= regfile_wdata;--ih
						when "1010" =>
							r10 <= regfile_wdata;--t
						when others =>
							null;
					end case;
				end if;
			end if;
	end if;
end process;

end Behavioral;