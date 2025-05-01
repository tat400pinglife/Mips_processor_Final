library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mips_processor_tb is
end mips_processor_tb;

architecture Behavioral of mips_processor_tb is
    component mips_processor is
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            -- Optional debugging outputs
            result : out STD_LOGIC_VECTOR(31 downto 0);
            overflow : out STD_LOGIC;
            Data_a : out STD_LOGIC_VECTOR(31 downto 0);
            Data_b : out STD_LOGIC_VECTOR(31 downto 0);
            debug_pc : out STD_LOGIC_VECTOR(4 downto 0);
            debug_instruction : out STD_LOGIC_VECTOR(31 downto 0);
				debug_RegDst : out STD_LOGIC;
			   debug_Branch : out STD_LOGIC;
			   debug_MemRead : out STD_LOGIC;
			   debug_MemtoReg : out STD_LOGIC;
			   debug_ALUOp1 : out STD_LOGIC;
			   debug_ALUOp0 : out STD_LOGIC;             
			   debug_MemWrite : out STD_LOGIC;
			   debug_ALUSrc : out STD_LOGIC;
			   debug_RegWrite : out STD_LOGIC;
			   debug_Jump : out STD_LOGIC;
			   debug_ALUControl : out STD_LOGIC
        );
    end component;
    
    -- Constants
    constant CLK_PERIOD : time := 10 ps;
    constant NUM_CYCLES : integer := 30;  -- Total number of test cycles
    
    -- Signals
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal result : STD_LOGIC_VECTOR(31 downto 0);
    signal overflow : STD_LOGIC;
    signal Data_a : STD_LOGIC_VECTOR(31 downto 0);
    signal Data_b : STD_LOGIC_VECTOR(31 downto 0);
    signal debug_pc : STD_LOGIC_VECTOR(4 downto 0);
    signal debug_instruction : STD_LOGIC_VECTOR(31 downto 0);
	 signal debug_RegDst : STD_LOGIC;
    signal debug_Branch :  STD_LOGIC;
    signal debug_MemRead :  STD_LOGIC;
    signal debug_MemtoReg :  STD_LOGIC;
    signal debug_ALUOp1 : STD_LOGIC;
    signal debug_ALUOp0 :  STD_LOGIC;             
    signal debug_MemWrite :  STD_LOGIC;
    signal debug_ALUSrc :  STD_LOGIC;
    signal debug_RegWrite :  STD_LOGIC;
    signal debug_Jump :  STD_LOGIC;
	 signal debug_ALUControl : STD_LOGIC; 
    
begin
    -- Instantiate the Unit Under Test (UUT)
    UUT: mips_processor port map (
        clk => clk,
        reset => reset,
        result => result,
        overflow => overflow,
        Data_a => Data_a,
        Data_b => Data_b,
        debug_pc => debug_pc,
        debug_instruction => debug_instruction,
		  debug_RegDst => debug_RegDst,
		  debug_Branch => debug_branch,
		  debug_MemRead => debug_MemRead,
		  debug_MemtoReg => debug_MemToReg,
		  debug_ALUOp1 => debug_ALUOp1,
		  debug_ALUOp0 => debug_ALUOp0,
		  debug_MemWrite => debug_MemWrite,
		  debug_ALUSrc => debug_ALUSrc,
		  debug_RegWrite => debug_RegWrite,
		  debug_Jump => debug_Jump,
		  debug_ALUControl => debug_ALUControl
    );

    -- Clock generation process
    CLK_PROCESS: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    -- Stimulus process - simplified with a loop
    STIM_PROC: process
    begin
        -- Initial reset
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        
        -- Run for specified number of cycles
        wait for CLK_PERIOD * NUM_CYCLES;
        
        -- Stop simulation
        wait;
    end process;
    
end Behavioral;