library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_control is
	port (
			ALUOp : in STD_LOGIC_VECTOR(1 downto 0);
         funct : in STD_LOGIC_VECTOR(5 downto 0);
         ALUControl : out STD_LOGIC
			);
end alu_control;

architecture behavioral of alu_control is

begin
	process (ALUOp, funct)
	begin
		ALUControl <= '1';
		
		case ALUOp is
		
		when "00" =>
			ALUControl <= '1';
		
		when "01" =>
			ALUControl <= '0';
		
		when "10" =>
			case funct is
			when "100000" =>
				ALUControl <= '1';
			
			when "100010" =>
				ALUControl <= '0';
			
			when others =>
				ALUControl <= '1';
			end case;
			
		when others =>
			ALUControl <= '1';
		end case;
	end process;
end behavioral;