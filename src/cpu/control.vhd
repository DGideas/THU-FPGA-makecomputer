----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:57:16 05/15/2017 
-- Design Name: 
-- Module Name:    control - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           PCwrite : out  STD_LOGIC;
           IDwrite : out  STD_LOGIC;
           EXwrite : out  STD_LOGIC;
           MEMwrite : out  STD_LOGIC;
           WBwrite : out  STD_LOGIC);

end control;

architecture Behavioral of control is
signal cnt:std_logic_vector(2 downto 0):="000";
begin
process(clk,rst)
  begin
     if rst = '0' then
	        cnt<="000";
	        PCwrite  <= '0';
           IDwrite <= '0';
           EXwrite  <= '0';
           MEMwrite  <= '0';
           WBwrite  <= '0';
	  else
	  --这里应该有个变化条件 我不知道写什么  CLK或者什么其他的？
         if(cnt="000")then
			  PCwrite  <= '1';
           IDwrite <= '0';
           EXwrite  <= '0';
           MEMwrite  <= '0';
           WBwrite  <= '0';
			  cnt<="001";
			elsif(cnt="001")then  
			 PCwrite  <= '0';
           IDwrite <= '1';
           EXwrite  <= '0';
           MEMwrite  <= '0';
           WBwrite  <= '0';
			  cnt<="010";
			 elsif(cnt="010")then   
			  PCwrite  <= '0';
           IDwrite <= '0';
           EXwrite  <= '1';
           MEMwrite  <= '0';
           WBwrite  <= '0';
			  cnt<="011";
			 elsif(cnt="011")then   
			  PCwrite  <= '0';
           IDwrite <= '0';
           EXwrite  <= '0';
           MEMwrite  <= '1';
           WBwrite  <= '0';
			  cnt<="100";
			 elsif(cnt="100")then   
			  PCwrite  <= '0';
           IDwrite <= '0';
           EXwrite  <= '0';
           MEMwrite  <= '0';
           WBwrite  <= '1';
			  cnt<="000";  
			  end if;
		end if;	 
end process;		
end Behavioral;
