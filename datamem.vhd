library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all; 

entity datamem is 
  port(
    clk    : in  STD_LOGIC;
    we     : in  STD_LOGIC;              -- Write enable for data
    a      : in  STD_LOGIC_VECTOR(31 downto 0); -- Address
    wd     : in  STD_LOGIC_VECTOR(31 downto 0); -- Write data
    rd     : out STD_LOGIC_VECTOR(31 downto 0) -- Read data
  );
end datamem;

architecture synth of datamem is
   type ram_type is array (127 downto 0) of STD_LOGIC_VECTOR(31 downto 0); -- max adress would be 0x200 or 512 in binary

    -- instructions
signal mem: ram_type := (
           0  => x"20020005", -- first word receives this instruction
           1  => x"2003000c",
           2  => x"2067fff7",
           3  => x"00e22025",
           4  => x"00642824",
           5  => x"00a42820",
           6  => x"10a7000a",
           7  => x"0064202a",
           8  => x"10800001",
           9  => x"20050000",
           10 => x"00e2202a",
           11 => x"00853820",
           12 => x"00e23822",
           13 => x"ac670044",
           14 => x"8c020050",
           15 => x"08000011",
           16 => x"20020001",
           17 => x"ac020054", -- 0x44 adress  
           others => (others => '0') -- start all memory positions with zeros 
    );


begin
  process(clk)
  begin
    if rising_edge(clk) then
      if (we = '1') then
        mem(to_integer(unsigned(a(8 downto 2)))) <= wd; -- 7 bits are enough to adress 128 words 
      end if;
    end if;
  end process;

  -- Read operation, asynchronous
  rd <= mem(to_integer(unsigned(a(8 downto 2)))); -- 7 bits are enough to adress 128 words 

end architecture synth;