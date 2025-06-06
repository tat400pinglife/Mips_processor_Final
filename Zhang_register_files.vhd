library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_File is
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
end Register_File;

architecture Behavioral of Register_File is
	type register_array is array(0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
	signal registers : register_array := (

		 others => (others => '0')
    );

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then
                registers(to_integer(unsigned(Rw))) <= busW;
            end if;
        end if;
    end process;
    
	 
    busA <= registers(to_integer(unsigned(Ra)));
    busB <= registers(to_integer(unsigned(Rb)));
end architecture Behavioral;