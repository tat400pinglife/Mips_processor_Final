library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity program_counter is
    Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
		  jump : in STD_LOGIC;
		  jump_addr : in STD_LOGIC_VECTOR(4 downto 0);
        pc_in : in STD_LOGIC_VECTOR(4 downto 0);
        pc_out : out STD_LOGIC_VECTOR(4 downto 0)
    );
end program_counter;

architecture Behavioral of program_counter is
    signal pc_reg : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
	 begin
    process(clk, reset, jump, jump_addr)
    begin
          if reset = '1' then
            pc_reg <= "00000";
            elsif jump = '1' then 
            pc_reg <= jump_addr;
        elsif rising_edge(clk) then
            pc_reg <= pc_in;
        end if;
    end process;
    
    pc_out <= pc_reg;
end Behavioral;