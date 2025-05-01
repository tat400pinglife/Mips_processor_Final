library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Modified data_memory component with forwarding capability
entity data_memory_with_forwarding is
    Port ( 
        address     : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        clock       : IN STD_LOGIC  := '1';
        data        : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        rden        : IN STD_LOGIC  := '1';
        wren        : IN STD_LOGIC ;
        q           : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
end data_memory_with_forwarding;

architecture Behavioral of data_memory_with_forwarding is
    component data_memory is
        Port ( 
            address     : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            clock       : IN STD_LOGIC  := '1';
            data        : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            rden        : IN STD_LOGIC  := '1';
            wren        : IN STD_LOGIC ;
            q           : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    end component;
    
    -- Internal signals for data forwarding
    signal mem_data_out : STD_LOGIC_VECTOR(31 downto 0);
    
    -- Store buffer - one entry for simplicity
    signal last_write_addr : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal last_write_data : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal write_valid : STD_LOGIC := '0';
    
begin
    -- Instantiate the actual memory
    mem: data_memory
    port map (
        address => address,
        clock => clock,
        data => data,
        rden => rden,
        wren => wren,
        q => mem_data_out
    );
    
    -- Process to track memory writes
    process(clock)
    begin
        if rising_edge(clock) then
            if wren = '1' then
                -- Store the data being written
                last_write_addr <= address;
                last_write_data <= data;
                write_valid <= '1';
            end if;
        end if;
    end process;
    
    -- Forwarding logic - combinational, outside the process
    q <= last_write_data when (rden = '1' and write_valid = '1' and address = last_write_addr) else
         mem_data_out;

end Behavioral;