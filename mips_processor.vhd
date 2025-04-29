library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Top level entity for the MIPS processor
entity mips_processor is
    Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        -- Optional debugging outputs
		  result : out STD_LOGIC_VECTOR(31 downto 0);
		  overflow : out STD_LOGIC;
		  Data_a	: out STD_LOGIC_VECTOR(31 downto 0);
		  Data_b	: out STD_LOGIC_VECTOR(31 downto 0);
        debug_pc : out STD_LOGIC_VECTOR(4 downto 0);
        debug_instruction : out STD_LOGIC_VECTOR(31 downto 0)
    );
end mips_processor;

architecture Behavioral of mips_processor is
    -- Component declarations
    component program_counter is
        Port ( 
            clk : in STD_LOGIC;
				reset : in STD_LOGIC;
            pc_in : in STD_LOGIC_VECTOR(4 downto 0);
            pc_out : out STD_LOGIC_VECTOR(4 downto 0)
        );
    end component;
    
    component instruction_memory is
        Port ( 
		address		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    end component;
    
    component control_unit is
        Port ( 
            opcode : in STD_LOGIC_VECTOR(5 downto 0);
            RegDst : out STD_LOGIC;
            Branch : out STD_LOGIC;
            MemRead : out STD_LOGIC;
            MemtoReg : out STD_LOGIC;
            ALUOp1 : out STD_LOGIC;
            ALUOp0 : out STD_LOGIC;				
            MemWrite : out STD_LOGIC;
            ALUSrc : out STD_LOGIC;
            RegWrite : out STD_LOGIC;
            Jump : out STD_LOGIC
        );
    end component;
    
    component register_file is
        Port ( 
        clk      	: in  STD_LOGIC;
        enable   	: in  STD_LOGIC;
        Ra       	: in  STD_LOGIC_VECTOR(4 downto 0);  -- Address to be read and sent (corresponding to busA)
        Rb       	: in  STD_LOGIC_VECTOR(4 downto 0);  -- Address to be read and sent (corres. to bus B)
        Rw       	: in  STD_LOGIC_VECTOR(4 downto 0);  -- Address to write new value or value from ALU
        busW     	: in  STD_LOGIC_VECTOR(31 downto 0); -- Data to be written, sent from ALU (result)                    
        busA     	: out STD_LOGIC_VECTOR(31 downto 0); -- Data to be sent to ALU
        busB     	: out STD_LOGIC_VECTOR(31 downto 0)  -- Data to be sent to ALU
        );
    end component;
	 
	 component sign_extend is
		port (
		immediate16 : in  std_logic_vector (15 downto 0);
		immediate32: out std_logic_vector (31 downto 0)
		);
	 end component;
    
    component alu_control is
        Port ( 
            ALUOp : in STD_LOGIC_VECTOR(1 downto 0);
            funct : in STD_LOGIC_VECTOR(5 downto 0);
            ALUControl : out STD_LOGIC
        );
    end component;
    
    component addsub is
        Port 
	(
		add_sub		: IN STD_LOGIC ;
		dataa		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		overflow		: OUT STD_LOGIC ;
		result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);

    end component;
    
    component data_memory is
        Port ( 
		address		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rden		: IN STD_LOGIC  := '1';
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    end component;
    
    -- Control signals
    signal RegDst      : STD_LOGIC;
    signal Branch      : STD_LOGIC;
    signal MemRead     : STD_LOGIC;
    signal MemtoReg    : STD_LOGIC;
	 signal ALUOp1      : STD_LOGIC;
	 signal ALUOp0      : STD_LOGIC;	 
    signal ALUOp       : STD_LOGIC_VECTOR(1 downto 0);
    signal MemWrite    : STD_LOGIC;
    signal ALUSrc      : STD_LOGIC;
    signal RegWrite    : STD_LOGIC;
    signal Jump        : STD_LOGIC;
    
    -- Program Counter signals
    signal pc_current  : STD_LOGIC_VECTOR(4 downto 0);
    signal pc_next     : STD_LOGIC_VECTOR(4 downto 0);
    signal pc_plus1    : STD_LOGIC_VECTOR(4 downto 0);
    
    -- Instruction Memory signals
    signal instruction : STD_LOGIC_VECTOR(31 downto 0);
    
    -- Register File signals
    signal reg_write_dest : STD_LOGIC_VECTOR(4 downto 0);
    signal reg_write_data : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_read_data1 : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_read_data2 : STD_LOGIC_VECTOR(31 downto 0);
    
    -- ALU signals
	 signal alu_control_signal : STD_LOGIC;
    signal alu_input2     : STD_LOGIC_VECTOR(31 downto 0);
    signal alu_result     : STD_LOGIC_VECTOR(31 downto 0);
    signal alu_zero       : STD_LOGIC;
	 signal overflow_sig		  : STD_LOGIC;
    
    -- Sign Extension
    signal sign_extended  : STD_LOGIC_VECTOR(31 downto 0);
    
    -- Data Memory signals
    signal mem_read_data  : STD_LOGIC_VECTOR(31 downto 0);
    
    -- Jump address calculation
    signal jump_address   : STD_LOGIC_VECTOR(4 downto 0);
    
    -- Branch address calculation
    signal branch_address : STD_LOGIC_VECTOR(4 downto 0);
    signal pc_src         : STD_LOGIC;
    signal branch_or_pc1  : STD_LOGIC_VECTOR(4 downto 0);
    

    
begin
    -- PC + 1 calculation (Per requirement, PC increases by 1)
    pc_plus1 <= std_logic_vector(unsigned(pc_current) + 1);
    
    -- Program Counter
    pc: program_counter
    port map (
        clk => clk,
		  reset => reset,
        pc_in => pc_next,
        pc_out => pc_current
    );
    
    -- Instruction Memory
    inst_mem: instruction_memory
    port map (
        address => pc_current,
		  clock => clk,
        q => instruction
    );
    
    -- Control Unit
    ctrl: control_unit
    port map (
        opcode => instruction(31 downto 26),
        RegDst => RegDst,
        Branch => Branch,
        MemRead => MemRead,
        MemtoReg => MemtoReg,
        ALUOp1 => ALUOp1,
		  ALUOp0 => ALUOp0,
        MemWrite => MemWrite,
        ALUSrc => ALUSrc,
        RegWrite => RegWrite,
        Jump => Jump
    );
	 
	 -- combine code
	 ALUOp <= ALUOp1 & ALUOp0;
    
    -- Register File
    reg_write_dest <= instruction(15 downto 11) when RegDst = '1' else instruction(20 downto 16);
    
    reg_file: register_file
    port map (
        clk => clk,
        enable => RegWrite,
        Ra => instruction(25 downto 21),
        Rb => instruction(20 downto 16),
        rw => reg_write_dest,
        busW => reg_write_data,
        busA => reg_read_data1,
        busB => reg_read_data2
    );
    
	 sign_extender: sign_extend
	 port map (
	 immediate16 => instruction(15 downto 0),
	 immediate32 => sign_extended
	 );
    
    -- ALU Control
    alu_ctrl: alu_control
    port map (
        ALUOp => ALUOp,
        funct => instruction(5 downto 0),
        ALUControl => alu_control_signal
    );
    
    -- ALU
    alu_input2 <= reg_read_data2 when ALUSrc = '0' else sign_extended;
    
    alu_unit: addsub
    port map (
        dataa => reg_read_data1,
        datab => alu_input2,
        add_sub => alu_control_signal,
        result => alu_result,
		  overflow => overflow_sig
    );
    
    -- Data Memory
    data_mem: data_memory
    port map (
        clock => clk,
        address => alu_result(15 downto 0),
        data => reg_read_data2,
        wren => MemWrite,
        rden => MemRead,
        q => mem_read_data
    );
    
    -- Write back to register file
    reg_write_data <= mem_read_data when MemtoReg = '1' else alu_result;
    
    -- Branch address calculation
    -- For branch, we need to shift left by 2 and then add to PC+1

    branch_address <= instruction(4 downto 0);
	 alu_zero <= '1' when alu_result = x"00000000" else '0';
    pc_src <= Branch AND alu_zero;
    branch_or_pc1 <= branch_address when pc_src = '1' else pc_plus1;
    

	 jump_address <= instruction(4 downto 0);  
	
    -- PC next value multiplexer
    pc_next <= jump_address when Jump = '1' else branch_or_pc1;
    
    -- Debug outputs
	 Data_a <= reg_read_data1;
	 Data_b <= reg_read_data2;
	 result <= alu_result;
	 overflow <= overflow_sig;
    debug_pc <= pc_current;
    debug_instruction <= instruction;
    
end Behavioral;