library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity decoder is
    Port ( Reg1 : out  STD_LOGIC_VECTOR (3 downto 0);--读出的寄存器
           Reg2 : out  STD_LOGIC_VECTOR (3 downto 0);--读出的寄存器
           reg3 : out  STD_LOGIC_VECTOR (3 downto 0);--写回的寄存器
           Imm : out  STD_LOGIC_VECTOR (15 downto 0);--扩展后的立即数
           Op : out  STD_LOGIC_VECTOR (4 downto 0);--操作码
			  S : out std_logic_vector(3 downto 0);--左移或者右移的数
			  AluOp : out std_logic_vector(2 downto 0);--alu操作数
           Instruction : in  STD_LOGIC_VECTOR (15 downto 0)--指令
			  );
end decoder;

architecture Behavioral of decoder is
begin
process(Instruction)
begin
Op<=Instruction(15 downto 11);
case Instruction(15 downto 11) is
    when "00001"=> null;--NOP
	 when "11100"=>--ADDU,SUBU
	   case Instruction(1 downto 0) is
	     when "01"=>--ADDU
	       Reg1<='0' & Instruction(10 downto 8);--rx
	       Reg2<='0' & Instruction(7 downto 5);--ry
	       Reg3<='0' & Instruction(4 downto 2);--rz
		    AluOp<="000";--加法运算
		  when "11"=>--SUBU
		    Reg1<='0' & Instruction(10 downto 8);--rx
	       Reg2<='0' & Instruction(7 downto 5);--ry
	       Reg3<='0' & Instruction(4 downto 2);--rz
		    AluOp<="001";--减法运算
		  when others=>null;
		  end case;
	 when "11101"=>--AND,CMP,MFPC,OR,JR
	    case Instruction(4 downto 0) is
		   when "01100"=>--AND
			     Reg1<='0' & Instruction(10 downto 8);--rx
		        Reg2<='0' & Instruction(7 downto 5);--ry
		        Reg3<='0' & Instruction(10 downto 8);--rz
  			     AluOp<="010";--逻辑与
			when "01010"=>--CMP
			     Reg1<='0' & Instruction(10 downto 8);--rx
		        Reg2<='0' & Instruction(7 downto 5);--ry
		        Reg3<="1010";--T寄存器
			     AluOp<="100";--逻辑异或
			when "01101"=>--OR
			    Reg1<='0' & Instruction(10 downto 8);--rx
		       Reg2<='0' &  Instruction(7 downto 5);--ry
		       Reg3<='0' & Instruction(10 downto 8);--rz
			    AluOp<="011";--逻辑或
			when "00000"=>
			    if(Instruction(6)='0')then--MFPC
		         Reg3<='0' & Instruction(10 downto 8);
				 else --JR
				   Reg1<='0' & Instruction(10 downto 8);--rx	
             end if;					
			when others=>null;
			end case;
    when "11110"=>--MFIH,MTIH
	    case Instruction(7 downto 0) is
	       when "00000000"=>--MFIH
	        Reg3<='0' & Instruction(10 downto 8);--rx
		     Reg1<="1001";--IH寄存器
	       when "00000001"=>--MTIH
		     Reg3<="1001";--IH寄存器
		     Reg1<='0' & Instruction(10 downto 8);--rx
		    when others=>null;
		 end case;
	 when "01100"=>--MTSP,BTEQZ,ADDSP
	    case Instruction(10 downto 8) is
	       when "100"=>--MTSP
	        Reg1<='0' & Instruction(7 downto 5);--rx
		     Reg3<="1000";--SP
		    when "000"=>--BTEQZ
		     Reg1<="1010";--T寄存器
			  AluOp<="000";--加法运算
		      IF(Instruction(7)='1')then
		        Imm<="11111111" & Instruction(7 downto 0);
		      else
		        Imm<="00000000" & Instruction(7 downto 0);
			   end if;
		    when "011"=>--ADDSP
		        Reg1<="1000";--SP
	           Reg3<="1000";--SP
			     AluOp<="000";--加法运算
	         IF(Instruction(7)='1')then
		        Imm<="11111111" & Instruction(7 downto 0);
		      else
		        Imm<="00000000" & Instruction(7 downto 0);
				end if;
		    when others=>null;
	     end case;	  
	 when "00110"=>--SLL,SRA
	     case Instruction(1 downto 0) is
	       when "00"=>--SLL
	          Reg3<='0' & Instruction(10 downto 8);--rx
		       Reg2<='0' & Instruction(7 downto 5);
				 AluOp<="101";--逻辑左移
		       if(Instruction(4 downto 2)="000")then
				   S<="1000";--左移8位
				 else
				   S<='0' & Instruction(4 downto 2);
				 end if;
			 when "11"=>--SRA
			    Reg3<='0' & Instruction(10 downto 8);--rx
		       Reg2<='0' & Instruction(7 downto 5);
	          AluOp<="110";--逻辑右移
		       if(Instruction(4 downto 2)="000")then
				   S<="1000";--右移8位
				 else
				   S<='0' & Instruction(4 downto 2);
				 end if;
	       when others=>null;
			 end case;
	 when "01001"=>--ADDIU
	          Reg1<='0' & Instruction(10 downto 8);
		       Reg3<='0' & Instruction(10 downto 8);
		       AluOp<="000";--加法运算
		     IF(Instruction(7)='1')then
		       Imm<="11111111" & Instruction(7 downto 0);
		     else
		       Imm<="00000000" & Instruction(7 downto 0);
		   	end if;
	 when "01000"=>--ADDIU3
	          Reg1<='0' & Instruction(10 downto 8);
		       Reg3<='0' & Instruction(7 downto 5);
		       AluOp<="000";--加法运算
		     IF(Instruction(3)='1')then
		        Imm<="111111111111" & Instruction(3 downto 0);
		     else
		        Imm<="000000000000" & Instruction(3 downto 0);
				end if;
	 when "01101"=>--LI
	         Reg3<='0' & Instruction(10 downto 8);
		      Imm<="00000000" & Instruction(7 downto 0);
	 when "10011"=>--LW
	         Reg1<='0' & Instruction(10 downto 8);
		      Reg3<='0' & Instruction(7 downto 5);
		      AluOp<="000";--加法运算
		    IF(Instruction(4)='1')then
		      Imm<="11111111111" & Instruction(4 downto 0);
		    else
		      Imm<="00000000000" & Instruction(4 downto 0);
				end if;
	 when "10010"=>--LW_SP
	         Reg3<='0' & Instruction(10 downto 8);
		      Reg1<="1000";--SP
		      AluOp<="000";--加法运算
		    IF(Instruction(7)='1')then
		      Imm<="11111111" & Instruction(7 downto 0);
		    else
		      Imm<="00000000" & Instruction(7 downto 0);
		    end if;
	 when "11011"=>--SW
	         Reg1<='0' & Instruction(10 downto 8);--用于计算地址
		      Reg2<='0' & Instruction(7 downto 5);--写入内存的内容
		       AluOp<="000";--加法运算
		    IF(Instruction(4)='1')then
		       Imm<="11111111111" & Instruction(4 downto 0);
		    else
		       Imm<="00000000000" & Instruction(4 downto 0);
		 end if;
	 when "11010"=>--SW_SP
	         Reg2<='0' & Instruction(10 downto 8);
		      Reg1<="1000";--SP
		      AluOp<="000";--加法运算
		    IF(Instruction(7)='1')then
		       Imm<="11111111" & Instruction(7 downto 0);
		    else
		       Imm<="00000000" & Instruction(7 downto 0);
		    end if;
	 when "00010"=>--B
	           AluOp<="000";--加法运算
	      IF(Instruction(10)='1')then
		     Imm<="11111" & Instruction(10 downto 0);
		   else
		     Imm<="00000" & Instruction(10 downto 0);
	      end if;
	 when "00100"=>--BEQZ
	        AluOp<="000";
	        Reg1<='0' & Instruction(10 downto 8);
		    IF(Instruction(7)='1')then
		     Imm<="11111111" & Instruction(7 downto 0);
		    else
		     Imm<="00000000" & Instruction(7 downto 0);
		   end if;
	 when "00101"=>--BNEZ
	        AluOp<="000";
	        Reg1<='0' & Instruction(10 downto 8);
		     IF(Instruction(7)='1')then
		       Imm<="11111111" & Instruction(7 downto 0);
		      else
		        Imm<="00000000" & Instruction(7 downto 0);
				end if;
	 when others=>null; 
END CASE;
END PROCESS;

end Behavioral;
