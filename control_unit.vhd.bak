library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    Port (
        OpCode : in STD_LOGIC_VECTOR (5 downto 0);
        RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0 : out STD_LOGIC
    );
end control_unit;

architecture Behavioral of control_unit is
begin
    process(OpCode)
    begin
        case OpCode is
            when "000000" =>  
                RegDst   <= '1';
                ALUSrc   <= '0';
                MemtoReg <= '0';
                RegWrite <= '1';
                MemRead  <= '0';
                MemWrite <= '0';
                Branch   <= '0';
                ALUOp1   <= '1';
                ALUOp0   <= '0';
            
            when "100011" =>  -- lw (Load Word)
                RegDst   <= '0';
                ALUSrc   <= '1';
                MemtoReg <= '1';
                RegWrite <= '1';
                MemRead  <= '1';
                MemWrite <= '0';
                Branch   <= '0';
                ALUOp1   <= '0';
                ALUOp0   <= '0';
            
            when "101011" =>  -- sw (Store Word)
                RegDst   <= 'X';
                ALUSrc   <= '1';
                MemtoReg <= 'X';
                RegWrite <= '0';
                MemRead  <= '0';
                MemWrite <= '1';
                Branch   <= '0';
                ALUOp1   <= '0';
                ALUOp0   <= '0';
            
            when "000100" =>  -- beq (Branch if Equal)
                RegDst   <= 'X';
                ALUSrc   <= '0';
                MemtoReg <= 'X';
                RegWrite <= '0';
                MemRead  <= '0';
                MemWrite <= '0';
                Branch   <= '1';
                ALUOp1   <= '0';
                ALUOp0   <= '1';
            
            when others =>  -- Default case
                RegDst   <= '0';
                ALUSrc   <= '0';
                MemtoReg <= '0';
                RegWrite <= '0';
                MemRead  <= '0';
                MemWrite <= '0';
                Branch   <= '0';
                ALUOp1   <= '0';
                ALUOp0   <= '0';
        end case;
    end process;
end Behavioral;
