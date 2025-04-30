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
		  Data_a	: out STD_LOGIC_VECTOR(31 downto 0);
		  Data_b	: out STD_LOGIC_VECTOR(31 downto 0);
        debug_pc : out STD_LOGIC_VECTOR(4 downto 0);
        debug_instruction : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    constant CLK_PERIOD : time := 10 ps;

    signal clk : STD_LOGIC := '0';
	 signal reset : STD_LOGIC := '0';
	 signal result : STD_LOGIC_VECTOR(31 downto 0);
	 signal overflow : STD_LOGIC;
	 signal Data_a : STD_LOGIC_VECTOR(31 downto 0);
	 signal Data_b : STD_LOGIC_VECTOR(31 downto 0);
	 signal debug_Pc : STD_LOGIC_VECTOR(4 downto 0);
	 Signal debug_instruction : STD_LOGIC_VECTOR(31 downto 0);


    
begin
    UUT: mips_processor port map (
        clk => clk,
		  reset => reset,
		  result => result,
		  overflow => overflow,
		  Data_a => Data_a,
		  Data_b => Data_b,
		  debug_pc => debug_pc,
		  debug_instruction => debug_instruction
    );


    CLK_CYCLE: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
STIM_PROC: process
begin

reset <= '1';
wait for CLK_PERIOD;

reset <= '0';
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;
wait for CLK_PERIOD;

wait;
end process;
end Behavioral;