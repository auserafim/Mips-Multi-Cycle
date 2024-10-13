library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all; 

entity instructmem is 
  port(a:  in  STD_LOGIC_VECTOR(5 downto 0); 
       rd: out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture synth of instructmem is

   -- Array de memória inicializado com o programa	
   type ram_type is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
   signal mem: ram_type := (
			  0 => x"20020005", -- primeira palavra da memória recebe esse valor
           1 => x"2003000c",
           2 => x"2067fff7",
           3 => x"00e22025",
           4 => x"00642824",
           5 => x"00a42820",
           6 => x"10a7000a",
           7 => x"0064202a",
           8 => x"10800001",
           9 => x"20050000",
           10 => x"00e2202a",
           11 => x"00853820",
           12 => x"00e23822",
           13 => x"ac670044",
           14 => x"8c020050",
           15 => x"08000011",
           16 => x"20020001",
           17 => x"ac020054",
	   others => (others => '0')
	);

begin	 
	-- leitura combinacional (independente de clock)
	rd <= mem(to_integer(unsigned(a))); -- converte para inteiro para endereçar a mem
end synth;

