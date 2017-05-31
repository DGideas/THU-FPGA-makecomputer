library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cpu_top is
	Port
	(
		port_clk_50: in std_logic; --50MHz clock
		port_clk_key: in std_logic; --One-Step clk key
		port_switch: in std_logic_vector(15 downto 0); --On-board switch
		port_rst: in std_logic; --Reset key
		port_mem1_oe: out std_logic; --Memory#1 signal
		port_mem1_we: out std_logic;
		port_mem1_en: out std_logic;
		port_mem1_addr: out std_logic_vector(17 downto 0);
		port_mem1_data: inout std_logic_vector(15 downto 0);
		port_mem2_oe: out std_logic; --Memory#1 signal
		port_mem2_we: out std_logic;
		port_mem2_en: out std_logic;
		port_mem2_addr: out std_logic_vector(17 downto 0);
		port_mem2_data: inout std_logic_vector(15 downto 0);
		port_com_data_ready: in std_logic; --COM signal
		port_com_rdn: out std_logic;
		port_com_tbre: inout std_logic;
		port_com_tsre: inout std_logic;
		port_com_wrn: out std_logic;
		port_led: out std_logic_vector(15 downto 0) --On-board LED
	);
end cpu_top;

architecture Behavioral of cpu_top is



component clkkey is
	port
	(
		clkkey_port_clk: in std_logic;
		clkkey_clk: out std_logic
	);
end component;
signal internal_debug_clk: std_logic;

component switch is
	port
	(
		switch_port_switch: in std_logic_vector(15 downto 0);
		switch_switch: out std_logic_vector(15 downto 0)
	);
end component;
signal internal_switch: std_logic_vector(15 downto 0);


signal internal_debug: std_logic_vector(15 downto 0) := "0000000000000000";

component mux_wb is
Port(
		 regsrc : in  STD_LOGIC_VECTOR(1 downto 0);
		input1 : in  STD_LOGIC_VECTOR (15 downto 0);
		input2 : in  STD_LOGIC_VECTOR (15 downto 0);
		output : out  STD_LOGIC_VECTOR (15 downto 0)
);
end component;

component mcmgmt is
	port
	(
		mcmgmt_clk: in std_logic;
		mcmgmt_rst: in std_logic;
		mcmgmt_port_mem1_oe: out std_logic;
		mcmgmt_port_mem1_we: out std_logic;
		mcmgmt_port_mem1_en: out std_logic;
		mcmgmt_port_mem1_addr: out std_logic_vector(17 downto 0);
		mcmgmt_port_mem1_data: inout std_logic_vector(15 downto 0);
		mcmgmt_port_mem2_oe: out std_logic;
		mcmgmt_port_mem2_we: out std_logic;
		mcmgmt_port_mem2_en: out std_logic;
		mcmgmt_port_mem2_addr: out std_logic_vector(17 downto 0);
		mcmgmt_port_mem2_data: inout std_logic_vector(15 downto 0);
		mcmgmt_port_com_data_ready: in std_logic;
		mcmgmt_port_com_rdn: out std_logic;
		mcmgmt_port_com_tbre: inout std_logic;
		mcmgmt_port_com_tsre: inout std_logic;
		mcmgmt_port_com_wrn: out std_logic;
		mcmgmt_addr: in std_logic_vector(19 downto 0);
		mcmgmt_idata: in std_logic_vector(15 downto 0);
		mcmgmt_odata: out std_logic_vector(15 downto 0);
		mcmgmt_rw: in std_logic;
		mcmgmt_by_byte: in std_logic;
		mcmgmt_byte_select: in std_logic;
		mcmgmt_free: out std_logic;
		mcmgmt_int: out std_logic;
		mcmgmt_debug_status: out std_logic_vector(4 downto 0)
	);
end component;
signal internal_mcmgmt_data: std_logic_vector(15 downto 0);
signal internal_mcmgmt_free: std_logic;
signal internal_mcmgmt_debug_status: std_logic_vector(4 downto 0);
signal internal_mcmgmt_ins: std_logic_vector(15 downto 0);


component alu is
	port
	(
		alu_input1: in std_logic_vector(15 downto 0);
		alu_input2: in std_logic_vector(15 downto 0);
		alu_output: out std_logic_vector(15 downto 0);
		alu_operator: in std_logic_vector(2 downto 0)
	);
end component;
signal alu_src_data1:std_logic_vector(15 downto 0);
signal alu_src_data2:std_logic_vector(15 downto 0);
signal alu_result:std_logic_vector(15 downto 0);
signal alu_idex_op:std_logic_vector(2 downto 0);

component add_pc  is  --PC自加器
    Port (
      input1 : in  STD_LOGIC_VECTOR(15 downto 0);  
		input2 : in  STD_LOGIC_VECTOR(15 downto 0);
		output : out STD_LOGIC_VECTOR(15 downto 0)
);
end component;
signal pc_output:  STD_LOGIC_VECTOR(15 downto 0);  
signal pc_add2:  STD_LOGIC_VECTOR(15 downto 0);


component pc is
   Port (
  	   pc_in: in std_logic_vector(15 downto 0);
		pc_out: out std_logic_vector(15 downto 0);
		pc_clk: in std_logic;
		pc_rst: in std_logic
);
end component;
signal pc_input:STD_LOGIC_VECTOR(15 downto 0):="0000000000000001";

component mux_pc is
Port(
		pcsrc : in  STD_LOGIC_VECTOR (2 downto 0);
		input1 : in  STD_LOGIC_VECTOR (15 downto 0);
		input2 : in  STD_LOGIC_VECTOR (15 downto 0);
		input3 : in  STD_LOGIC_VECTOR (15 downto 0);
		output : out  STD_LOGIC_VECTOR (15 downto 0)
);
end component;
signal pc_src_op:  STD_LOGIC_VECTOR (2 downto 0);
signal pc_reg:  STD_LOGIC_VECTOR (15 downto 0);
--******************寄存器堆
component regfile is
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
end component;
signal regfile_port_we:std_logic;
signal regfile_port_waddr: std_logic_vector(3 downto 0);
signal regfile_port_wdata: std_logic_vector(15 downto 0);
signal regfile_port_raddr1: std_logic_vector(3 downto 0);
signal regfile_port_rdata1: std_logic_vector(15 downto 0);
signal regfile_port_raddr2: std_logic_vector(3 downto 0);
signal regfile_port_rdata2: std_logic_vector(15 downto 0);
--******************
component mux_reg1 is
    Port ( alusrca : in  STD_LOGIC_VECTOR (1 downto 0);
           muxreg1 : in  STD_LOGIC_VECTOR (15 downto 0);
           mux_PC : in  STD_LOGIC_VECTOR (15 downto 0);
           mux_dataA : out  STD_LOGIC_VECTOR (15 downto 0)
			  );
end component ;

component mux_reg2 is
    Port ( alusrcb : in  STD_LOGIC_VECTOR (1 downto 0);
           muxreg2 : in  STD_LOGIC_VECTOR (15 downto 0);
           mux_imm : in STD_LOGIC_VECTOR (15 downto 0);
           mux_dataB : out  STD_LOGIC_VECTOR (15 downto 0)
			  );
end component ;
component mux_result is
 Port (    alusrc : in  STD_LOGIC_VECTOR (1 downto 0);
           mux_alures : in  STD_LOGIC_VECTOR (15 downto 0);
           mux_menres : in STD_LOGIC_VECTOR (15 downto 0);
           mux_dataC : out  STD_LOGIC_VECTOR (15 downto 0));
end component  ;
signal ex_mux_result:std_logic_vector(15 downto 0);
--多路选择器
component decoder is
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
end component;
signal id_mux_reg1:std_logic_vector(1 downto 0);
signal id_mux_reg2:std_logic_vector(1 downto 0);
signal id_mux_imm:std_logic_vector(15 downto 0);
signal id_mux:std_logic_vector(1 downto 0);
--******************IF_ID
component if_id_segment_regfile is
    port
    (
   	 if_id_segment_regfile_clk: in std_logic;
   	 if_id_segment_regfile_write_in: in std_logic;
   	 if_id_segment_regfile_instruction_in: in std_logic_vector(15 downto 0);
   	 if_id_segment_regfile_instruction_out: out std_logic_vector(15 downto 0);
		 --id_ex_segment_regfiel_we_result_in:  in std_logic_vector (1 downto 0);
   	-- id_ex_segment_regfiel_we_result_out: out  std_logic_vector (1 downto 0);
   	 if_id_segment_regfile_pc_in: in std_logic_vector(15 downto 0);
   	 if_id_segment_regfile_pc_out: out std_logic_vector(15 downto 0)
    );
end component;
signal if_id_regfile_instruction: std_logic_vector(15 downto 0);
signal if_id_pc: std_logic_vector(15 downto 0);

--****************id_ex
component id_ex_segment_regfile is
 port
	(
  	id_ex_segment_regfile_clk : in  std_logic;
   	 id_ex_segment_regfile_write_in : in  std_logic;
   	 id_ex_segment_regfile_rdata1_in : in  std_logic_vector (15 downto 0);
   	 id_ex_segment_regfile_rdata2_in : in  std_logic_vector (15 downto 0);
   	 id_ex_segment_regfile_rdata1_out : out  std_logic_vector (15 downto 0);
   	 id_ex_segment_regfile_rdata2_out : out  std_logic_vector (15 downto 0);
   	 id_ex_segment_regfile_pc_in : in  std_logic_vector (15 downto 0);
   	 id_ex_segment_regfile_pc_out : out  std_logic_vector (15 downto 0);
   	 id_ex_segment_regfile_alu_op_in : in  std_logic_vector (2 downto 0);
   	 id_ex_segment_regfile_alu_op_out : out  std_logic_vector (2 downto 0);
   	 id_ex_segment_regfile_reg_rx_in : in  std_logic_vector (15 downto 0);
   	 id_ex_segment_regfile_reg_rx_out : out  std_logic_vector (15 downto 0);
   	 id_ex_segment_regfile_mem_we_in : in  std_logic;
   	 id_ex_segment_regfile_mem_we_out : out  std_logic;
   	 id_ex_segment_regfile_pc_src_in : in   std_logic_vector (2 downto 0);
   	 id_ex_segment_regfile_pC_src_out : out  std_logic_vector (2 downto 0);
   	 id_ex_segment_regfile_reg_ry_in : in  std_logic_vector (15 downto 0);
   	 id_ex_segment_regfile_reg_ry_out : out  std_logic_vector (15 downto 0);
   	 id_ex_segment_regfile_src_result_in : in   std_logic_vector (1 downto 0);
   	 id_ex_segment_regfile_src_result_out : out  std_logic_vector (1 downto 0);
   	 id_ex_segment_regfile_reg_we_in : in  std_logic;
   	 id_ex_segment_regfile_reg_we_out : out  std_logic;
		 id_ex_segment_regfile_we_result_in:  in std_logic_vector (1 downto 0);
   	 id_ex_segment_regfile_we_result_out: out  std_logic_vector (1 downto 0);
   	 id_ex_segment_regfile_imm_in : in  std_logic_vector (15 downto 0);
   	 id_ex_segment_regfile_imm_out : out  std_logic_vector (15 downto 0));
end component;
signal id_ex_pc: std_logic_vector(15 downto 0);
signal id_ex_regfile_alu_op: std_logic_vector(2 downto 0);
signal id_ex_regfile_reg_rx: std_logic_vector(15 downto 0);
signal id_ex_regfile_mem_we: std_logic;
signal regfile_mem_we: std_logic;
signal id_ex_regfile_pc_src: std_logic_vector(2 downto 0);
signal id_ex_regfile_reg_ry: std_logic_vector(15 downto 0);
signal regfile_reg_ry: std_logic_vector(15 downto 0);
signal id_ex_regfile_src_result: std_logic_vector(1 downto 0);
signal regfile_src_result: std_logic_vector(1 downto 0);
signal id_ex_regfile_reg_we: std_logic;
signal regfile_reg_we: std_logic;
signal id_ex_regfile_imm:std_logic_vector(15 downto 0);
signal regfile_imm:std_logic_vector(15 downto 0);
signal regfile_port_rdataA :  std_logic_vector (15 downto 0);
signal regfile_port_rdataB :  std_logic_vector (15 downto 0);
signal id_ex_regfile_we_result: std_logic_vector(1 downto 0);
--****************ex_mem
component ex_mem_segment_regfile is
	port
	(
  	ex_mem_segment_regfile_clk: in std_logic;
   	 ex_mem_segment_regfile_write_in: in std_logic;
   	 ex_mem_segment_regfile_alu_result_in: in std_logic_vector(15 downto 0);
   	 ex_mem_segment_regfile_alu_result_out: out std_logic_vector(15 downto 0);
   	 ex_mem_segment_regfile_mem_we_in: in std_logic;
   	 ex_mem_segment_regfile_mem_we_out: out std_logic;
   	 ex_mem_segment_regfile_reg_ry_in: in std_logic_vector(15 downto 0);
   	 ex_mem_segment_regfile_reg_ry_out: out std_logic_vector(15 downto 0);
   	 ex_mem_segment_regfile_src_result_in: in std_logic_vector(1 downto 0);
   	 ex_mem_segment_regfile_src_result_out: out std_logic_vector(1 downto 0);
   	 ex_mem_segment_regfile_reg_we_in: in std_logic;
   	 ex_mem_segment_regfile_reg_we_out: out std_logic;
		 ex_mem_segment_regfile_we_result_in:  in std_logic_vector (1 downto 0);
   	 ex_mem_segment_regfile_we_result_out:  out std_logic_vector (1 downto 0);
   	 ex_mem_segment_regfile_imm_in: in std_logic_vector(15 downto 0);
   	 ex_mem_segment_regfile_imm_out: out std_logic_vector(15 downto 0)
	);
end component;
signal ex_mem_regfile_alu_result: std_logic_vector(15 downto 0);
signal ex_mem_regfile_mem_we: std_logic;
signal ex_mem_regfile_reg_ry: std_logic_vector(15 downto 0);
signal ex_mem_regfile_src_result : std_logic_vector(1 downto 0);
signal ex_mem_regfile_reg_we: std_logic;
signal ex_mem_regfile_imm: std_logic_vector(15 downto 0);
signal ex_mem_regfile_we_result : std_logic_vector(1 downto 0);
--**********************mem_we
component mem_we_segment_regfile is
    port
    (
   	 mem_we_segment_regfile_clk: in std_logic;
   	 mem_we_segment_regfile_write_in: in std_logic;
   	 mem_we_segment_regfile_result_in: in std_logic_vector(15 downto 0);
   	 mem_we_segment_regfile_result_out: out std_logic_vector(15 downto 0);
   	 mem_we_segment_regfile_reg_we_in: in std_logic;
   	 mem_we_segment_regfile_reg_we_out: out std_logic;
		 mem_we_segment_regfile_we_result_in:  in std_logic_vector (1 downto 0);
   	 mem_we_segment_regfile_we_result_out:  out std_logic_vector (1 downto 0);
   	 mem_we_segment_regfile_imm_in: in std_logic_vector(15 downto 0);
   	 mem_we_segment_regfile_imm_out: out std_logic_vector(15 downto 0)
    );
end component;
signal mem_we_regfile_result: std_logic_vector(15 downto 0);
signal mem_we_regfile_imm: std_logic_vector(15 downto 0);
signal mem_we_regfile_we_result : std_logic_vector(1 downto 0);

--*****************************
begin


clkkey1: clkkey port map
(
	clkkey_port_clk => port_clk_key,
	clkkey_clk => internal_debug_clk
);

switch1: switch port map
(
	switch_port_switch => port_switch,
	switch_switch => internal_switch
);


alu1: alu port map(
		alu_input1 => alu_src_data1, 
		alu_input2 =>  alu_src_data2,
		alu_output => port_led,
		alu_operator => alu_idex_op
		);
addpc1:add_pc port map(
		input1 => pc_output,
		input2 => "0000000000000010",
		output => pc_add2
		);

pc1: pc port map(
		pc_in => pc_input,
		pc_out => pc_output,
      pc_clk => port_clk_key,
      pc_rst => port_rst
		);
mux_pc1:mux_pc port map(
		pcsrc => pc_src_op,
		input1 => pc_add2,
      input2 => regfile_port_rdata1,
      input3 => alu_result,
		output=> pc_input
);
mux_wb1:mux_wb port map(
	   regsrc=>mem_we_regfile_we_result, 
		input1=>mem_we_regfile_result, 
		input2=> mem_we_regfile_imm,
		output=> regfile_port_wdata
);

mcmgmt1: mcmgmt port map
(
	mcmgmt_clk => port_clk_key,
	mcmgmt_rst => port_rst,
	mcmgmt_port_mem1_oe => port_mem1_oe,
	mcmgmt_port_mem1_we => port_mem1_we,
	mcmgmt_port_mem1_en => port_mem1_en,
	mcmgmt_port_mem1_addr => port_mem1_addr,
	mcmgmt_port_mem1_data => port_mem1_data,
	mcmgmt_port_mem2_oe => port_mem2_oe,
	mcmgmt_port_mem2_we => port_mem2_we,
	mcmgmt_port_mem2_en => port_mem2_en,
	mcmgmt_port_mem2_addr => port_mem2_addr,
	mcmgmt_port_mem2_data => port_mem2_data,
	mcmgmt_port_com_data_ready => port_com_data_ready,
	mcmgmt_port_com_rdn => port_com_rdn,
	mcmgmt_port_com_tbre => port_com_tbre,
	mcmgmt_port_com_tsre => port_com_tsre,
	mcmgmt_port_com_wrn => port_com_wrn,
	mcmgmt_addr => "00000000000000000000",
	mcmgmt_idata => "1111111111111111",
	mcmgmt_odata =>internal_mcmgmt_ins,
	mcmgmt_rw => '1',
	mcmgmt_by_byte => '1',
	mcmgmt_byte_select => '1',
	mcmgmt_free => internal_mcmgmt_free,
	mcmgmt_int => open,
	mcmgmt_debug_status => internal_mcmgmt_debug_status
);

internal_debug <= internal_mcmgmt_debug_status & "01010101011";
--************
regfile1: regfile port map
(
   regfile_clk=>port_clk_key,
   regfile_rst=>port_rst,
    	regfile_we=>regfile_port_we,
    	regfile_waddr=> regfile_port_waddr,
    	regfile_wdata=> regfile_port_wdata,
    	regfile_raddr1=>regfile_port_raddr1,
    	regfile_rdata1=> regfile_port_rdata1,
    	regfile_raddr2=> regfile_port_raddr2,
    	regfile_rdata2=>regfile_port_rdata2
);
--************
mux_reg11: mux_reg1  port map(
alusrca=>id_mux_reg1,
muxreg1=>regfile_port_rdata1,
mux_PC=>pc_add2,
mux_dataA=>regfile_port_rdataA
);

mux_reg21: mux_reg2  port map(
alusrcb=>id_mux_reg2,
muxreg2=>regfile_port_rdata2,
mux_imm=>id_mux_imm,
mux_dataB=>regfile_port_rdataB
);
mux_result1: mux_result port map(
alusrc=>ex_mem_regfile_src_result,
mux_alures=>ex_mem_regfile_alu_result,
mux_menres=>internal_mcmgmt_data,
mux_dataC=>ex_mux_result
);

--************

decoder1: decoder port map(
instruction =>if_id_regfile_instruction,
imm1=>id_ex_regfile_imm,
rw=>id_ex_regfile_mem_we,
we=>id_ex_regfile_reg_we,
aluop=>id_ex_regfile_alu_op,
muxpc=>id_ex_regfile_pc_src,
muxop3=>id_ex_regfile_src_result,
muxop4=>id_mux,
reg1=>regfile_port_raddr1,
reg2=>regfile_port_raddr2,
reg3=>regfile_port_waddr,
imm=>id_mux_imm,
muxop2=>id_mux_reg2,
muxop1=>id_mux_reg1
);
--****************if_id
if_id_segment_regfile1: if_id_segment_regfile port map
(
    	if_id_segment_regfile_clk=>port_clk_key,
    	if_id_segment_regfile_write_in=>'1',
    	if_id_segment_regfile_instruction_in=>port_switch,
    	if_id_segment_regfile_instruction_out=> if_id_regfile_instruction,
    	if_id_segment_regfile_pc_in=>pc_output,
    	if_id_segment_regfile_pc_out=>if_id_pc
);
--************id_ex
id_ex_segment_regfile1: id_ex_segment_regfile port map
(
    	id_ex_segment_regfile_clk=>port_clk_key,
    	id_ex_segment_regfile_write_in =>'1',
    	id_ex_segment_regfile_rdata1_in =>regfile_port_rdataA,
    	id_ex_segment_regfile_rdata2_in => regfile_port_rdataB,
    	id_ex_segment_regfile_rdata1_out =>alu_src_data1,
    	id_ex_segment_regfile_rdata2_out => alu_src_data2,
    	id_ex_segment_regfile_pc_in => if_id_pc,
    	id_ex_segment_regfile_pc_out =>id_ex_pc,
    	id_ex_segment_regfile_alu_op_in =>id_ex_regfile_alu_op,
    	id_ex_segment_regfile_alu_op_out =>alu_idex_op,
    	id_ex_segment_regfile_reg_rx_in => id_ex_regfile_reg_rx,
    	id_ex_segment_regfile_reg_rx_out =>pc_reg,
    	id_ex_segment_regfile_mem_we_in => id_ex_regfile_mem_we,
    	id_ex_segment_regfile_mem_we_out => regfile_mem_we,
    	id_ex_segment_regfile_pc_src_in=>id_ex_regfile_pc_src,
    	id_ex_segment_regfile_pc_src_out=>pc_src_op,
    	id_ex_segment_regfile_reg_ry_in =>id_ex_regfile_reg_ry,
    	id_ex_segment_regfile_reg_ry_out =>regfile_reg_ry,
    	id_ex_segment_regfile_src_result_in =>id_ex_regfile_src_result,
    	id_ex_segment_regfile_src_result_out =>regfile_src_result,
    	id_ex_segment_regfile_reg_we_in =>id_ex_regfile_reg_we,
    	id_ex_segment_regfile_reg_we_out =>regfile_reg_we,
		id_ex_segment_regfile_we_result_in=> id_mux,
   	id_ex_segment_regfile_we_result_out=>id_ex_regfile_we_result,
    	id_ex_segment_regfile_imm_in =>id_ex_regfile_imm,
    	id_ex_segment_regfile_imm_out =>regfile_imm
);
--***************ex_mem
ex_mem_segment_regfile1: ex_mem_segment_regfile port map
	(
    	ex_mem_segment_regfile_clk => port_clk_key,
    	ex_mem_segment_regfile_write_in=> '1',
    	ex_mem_segment_regfile_alu_result_in=>alu_result,
    	ex_mem_segment_regfile_alu_result_out=>ex_mem_regfile_alu_result,
    	ex_mem_segment_regfile_mem_we_in=>regfile_mem_we,
    	ex_mem_segment_regfile_mem_we_out=>ex_mem_regfile_mem_we,
    	ex_mem_segment_regfile_reg_ry_in=>regfile_reg_ry,
    	ex_mem_segment_regfile_reg_ry_out=>ex_mem_regfile_reg_ry,
    	ex_mem_segment_regfile_src_result_in=>regfile_src_result,
    	ex_mem_segment_regfile_src_result_out=> ex_mem_regfile_src_result,
    	ex_mem_segment_regfile_reg_we_in=>regfile_reg_we,
    	ex_mem_segment_regfile_reg_we_out=>ex_mem_regfile_reg_we,
		ex_mem_segment_regfile_we_result_in=>id_ex_regfile_we_result,
   	 ex_mem_segment_regfile_we_result_out=>ex_mem_regfile_we_result,
    	ex_mem_segment_regfile_imm_in=>regfile_imm,
    	ex_mem_segment_regfile_imm_out=>ex_mem_regfile_imm
	);
--****************mem-we
mem_we_segment_regfile1: mem_we_segment_regfile port map
	(
    	mem_we_segment_regfile_clk=>port_clk_key,
    	mem_we_segment_regfile_write_in => '1',
    	mem_we_segment_regfile_result_in => ex_mux_result,
    	mem_we_segment_regfile_result_out=>mem_we_regfile_result,
    	mem_we_segment_regfile_reg_we_in=>ex_mem_regfile_reg_we,
    	mem_we_segment_regfile_reg_we_out=>regfile_port_we,
		mem_we_segment_regfile_we_result_in=>ex_mem_regfile_we_result,
   	mem_we_segment_regfile_we_result_out=>mem_we_regfile_we_result,
    	mem_we_segment_regfile_imm_in=>ex_mem_regfile_imm,
    	mem_we_segment_regfile_imm_out=>mem_we_regfile_imm
	);
end Behavioral;


