library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity decoder is
    Port ( reg1 : out  STD_LOGIC_VECTOR (3 downto 0);--读出的寄存器
           reg2 : out  STD_LOGIC_VECTOR (3 downto 0);--读出的寄存器
           reg3 : out  STD_LOGIC_VECTOR (3 downto 0);--写回的寄存器
           imm : out  STD_LOGIC_VECTOR (15 downto 0);--扩展后的立即数
			   imm1 : out  STD_LOGIC_VECTOR (15 downto 0);--扩展后的立即数
			  rw : out std_logic;--内存读写
			  we : out std_logic;
			  muxop1 : out std_logic_vector(1 downto 0);--多路选择器1
			  muxop2 : out std_logic_vector(1 downto 0);--多路选择器2
			  muxop3 : out std_logic_vector(1 downto 0);--多路选择器3
			  muxop4 : out std_logic_vector(1 downto 0);--多路选择器4
			  muxpc : out std_logic_vector(2 downto 0);--多路选择器pc
			  aluop : out std_logic_vector(2 downto 0);--alu操作数
           instruction : in  STD_LOGIC_VECTOR (15 downto 0)--指令
			  );
end decoder;

architecture Behavioral of decoder is
begin
process(instruction)
begin
case instruction(15 downto 11) is
    when "00001"=> null;--NOP
	 when "11100"=>--ADDU,SUBU
	      we<='1';
			muxpc<="000";
			muxop1<="00";
			muxop2<="00";
			muxop3<="00";
			muxop4<="00";
	    case instruction(1 downto 0) is
	     when "01"=>--ADDU
	       reg1<='0' & instruction(10 downto 8);--rx
	       reg2<='0' & instruction(7 downto 5);--ry
	       reg3<='0' & instruction(4 downto 2);--rz
		    aluop<="000";--加法运算
		  when "11"=>--SUBU
		    reg1<='0' & instruction(10 downto 8);--rx
	       reg2<='0' & instruction(7 downto 5);--ry
	       reg3<='0' & instruction(4 downto 2);--rz
		    AluOp<="001";--减法运算
		  when others=>null;
		  end case;
	 when "11101"=>--AND,CMP,MFPC,OR,JR
	          muxop3<="00";
				 muxop4<="00";
	    case instruction(4 downto 0) is
		   when "01100"=>--AND
			     we<='1';
				  muxpc<="000";
				  muxop1<="00";
			     muxop2<="00";
			     reg1<='0' & instruction(10 downto 8);--rx
		        reg2<='0' & instruction(7 downto 5);--ry
		        reg3<='0' & instruction(10 downto 8);--rz
  			     aluop<="010";--逻辑与
			when "01010"=>--CMP
			     we<='1';
				  muxpc<="000";
				  muxop1<="00";
			     muxop2<="00";
			     reg1<='0' & instruction(10 downto 8);--rx
		        reg2<='0' & instruction(7 downto 5);--ry
		        reg3<="1010";--T寄存器
			     aluop<="100";--逻辑异或
			when "01101"=>--OR
			    we<='1';
				 muxpc<="000";
				 muxop1<="00";
			    muxop2<="00";
			    reg1<='0' & instruction(10 downto 8);--rx
		       reg2<='0' &  instruction(7 downto 5);--ry
		       reg3<='0' & instruction(10 downto 8);--rz
			    aluop<="011";--逻辑或
			when "00000"=>
			    if(instruction(6)='0')then--MFPC
				   we<='1';
					muxpc<="000";
		         reg3<='0' & instruction(10 downto 8);
				 else --JR
				   muxop1<="00";
			      muxop2<="00";
					muxpc<="000";
				   reg1<='0' & instruction(10 downto 8);--rx	
             end if;					
			when others=>null;
			end case;
    when "11110"=>--MFIH,MTIH
	        we<='1';
			  muxop1<="00";
			  muxop2<="00";
			  muxpc<="000";
			  muxop3<="00";
			  muxop4<="00";
	    case instruction(7 downto 0) is
	       when "00000000"=>--MFIH
	        reg3<='0' & instruction(10 downto 8);--rx
		     reg1<="1001";--IH寄存器
	       when "00000001"=>--MTIH
		     reg3<="1001";--IH寄存器
		     reg1<='0' & instruction(10 downto 8);--rx
		    when others=>null;
		 end case;
	 when "01100"=>--MTSP,BTEQZ,ADDSP
	          muxop3<="00";
				 muxop4<="00";
	    case instruction(10 downto 8) is
	       when "100"=>--MTSP
			  we<='1';
			  muxpc<="000";
			  muxop1<="00";
			   muxop2<="00";
	        reg1<='0' & instruction(7 downto 5);--rx
		     reg3<="1000";--SP
			  
		    when "000"=>--BTEQZ
			 muxpc<="010";
		     reg1<="1010";--T寄存器
			  aluop<="000";--加法运算
			  muxop1<="01";
			  muxop2<="01";
		      IF(instruction(7)='1')then
		        imm<="11111111" & Instruction(7 downto 0);
		      else
		        imm<="00000000" & Instruction(7 downto 0);
			   end if;
		    when "011"=>--ADDSP
			     we<='1';
				  muxpc<="000";
				  muxop1<="00";
			     muxop2<="01";
		        reg1<="1000";--SP
	           reg3<="1000";--SP
			     aluop<="000";--加法运算
	         IF(instruction(7)='1')then
		        imm<="11111111" & instruction(7 downto 0);
		      else
		        imm<="00000000" & instruction(7 downto 0);
				end if;
		    when others=>null;
	     end case;	  
	 when "00110"=>--SLL,SRA
	          we<='1';
				 muxop4<="00";
				 muxpc<="000";
				 muxop1<="00";
			    muxop2<="01";
				 muxop3<="00";
	     case instruction(1 downto 0) is
	       when "00"=>--SLL
	          reg3<='0' & instruction(10 downto 8);--rx
		       reg1<='0' & instruction(7 downto 5);
				 aluop<="101";--逻辑左移
		       if(instruction(4 downto 2)="000")then
				   imm<="0000000000001000";--左移8位
				 else
				   imm<="0000000000000" & instruction(4 downto 2);
				 end if;
			 when "11"=>--SRA
			    reg3<='0' & Instruction(10 downto 8);--rx
		       reg1<='0' & Instruction(7 downto 5);
	          aluop<="110";--逻辑右移
		       if(instruction(4 downto 2)="000")then
				   imm<="0000000000001000";--右移8位
				 else
				   imm<="0000000000000" & instruction(4 downto 2);
				 end if;
	       when others=>null;
			 end case;
	 when "01001"=>--ADDIU
	          we<='1';
				 muxpc<="000";
				 muxop1<="00";
			    muxop2<="01";
				 muxop3<="00";
				 muxop4<="00";
	          reg1<='0' & Instruction(10 downto 8);
		       reg3<='0' & Instruction(10 downto 8);
		       aluop<="000";--加法运算
		     IF(Instruction(7)='1')then
		       imm<="11111111" & instruction(7 downto 0);
		     else
		       imm<="00000000" & instruction(7 downto 0);
		   	end if;
	 when "01000"=>--ADDIU3
	          we<='1';
				 muxpc<="000";
				 muxop1<="00";
			    muxop2<="01";
				 muxop3<="00";
				 muxop4<="00";
	          reg1<='0' & instruction(10 downto 8);
		       reg3<='0' & instruction(7 downto 5);
		       aluop<="000";--加法运算
		     IF(Instruction(3)='1')then
		        imm<="111111111111" & instruction(3 downto 0);
		     else
		        imm<="000000000000" & instruction(3 downto 0);
				end if;
	 when "01101"=>--LI
	         we<='1';
				muxpc<="000";
			   muxop2<="01";
				muxop3<="00";
				muxop4<="01";
	         reg3<='0' & instruction(10 downto 8);
		      imm1<="00000000" & instruction(7 downto 0);
	 when "10011"=>--LW
	         we<='1';
				muxpc<="000";
				muxop1<="00";
			   muxop2<="01";
				muxop3<="01";
				muxop4<="00";
	         reg1<='0' & instruction(10 downto 8);
		      reg3<='0' & instruction(7 downto 5);
		      aluop<="000";--加法运算
				rw<='1';
		    IF(instruction(4)='1')then
		      imm<="11111111111" & instruction(4 downto 0);
		    else
		      Imm<="00000000000" & Instruction(4 downto 0);
				end if;
	 when "10010"=>--LW_SP
	         we<='1';
				muxpc<="000";
				muxop1<="00";
			   muxop2<="01";
				muxop3<="01";
				muxop4<="00";
	         reg3<='0' & instruction(10 downto 8);
		      reg1<="1000";--SP
				rw<='1';
		      aluop<="000";--加法运算
		    IF(instruction(7)='1')then
		      imm<="11111111" & instruction(7 downto 0);
		    else
		      imm<="00000000" & Instruction(7 downto 0);
		    end if;
	 when "11011"=>--SW
	         muxop1<="00";
			   muxop2<="01";
				muxpc<="000";
				muxop4<="00";
	         reg1<='0' & instruction(10 downto 8);--用于计算地址
		      reg2<='0' & instruction(7 downto 5);--写入内存的内容
		       aluop<="000";--加法运算
				 rw<='0';
		    IF(instruction(4)='1')then
		       imm<="11111111111" & instruction(4 downto 0);
		    else
		       imm<="00000000000" & instruction(4 downto 0);
		 end if;
	 when "11010"=>--SW_SP
	         muxop1<="00";
			   muxop2<="01";
				muxpc<="000";
				muxop4<="00";
	         reg2<='0' & instruction(10 downto 8);
		      reg1<="1000";--SP
		      aluop<="000";--加法运算
				rw<='0';
		    IF(instruction(7)='1')then
		       imm<="11111111" & instruction(7 downto 0);
		    else
		       imm<="00000000" & instruction(7 downto 0);
		    end if;
	 when "00010"=>--B
	           muxop1<="01";
			     muxop2<="01";
	           aluop<="000";--加法运算
				  muxpc<="100";
	      IF(instruction(10)='1')then
		     imm<="11111" & instruction(10 downto 0);
		   else
		     imm<="00000" & instruction(10 downto 0);
	      end if;
	 when "00100"=>--BEQZ
	        aluop<="000";
			  muxop1<="01";
			  muxop2<="01";
			  muxpc<="010";
	        reg1<='0' & instruction(10 downto 8);
		    IF(instruction(7)='1')then
		     imm<="11111111" & instruction(7 downto 0);
		    else
		     imm<="00000000" & instruction(7 downto 0);
		   end if;
	 when "00101"=>--BNEZ
	        aluop<="000";
			  muxop1<="01";
			  muxop2<="01";
			  muxpc<="011";
			  muxop4<="00";
	        reg1<='0' & instruction(10 downto 8);
		     IF(instruction(7)='1')then
		       imm<="11111111" & instruction(7 downto 0);
		      else
		        imm<="00000000" & instruction(7 downto 0);
				end if;
	 when others=>null; 
END CASE;
END PROCESS;

end Behavioral;

