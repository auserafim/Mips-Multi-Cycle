library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD.all; 

entity datamem is 
  port(clk, we:  in STD_LOGIC;
       a, wd:    in STD_LOGIC_VECTOR(31 downto 0);
       rd:       out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture synth of datamem is
   -- Array de memória
   type ram_type is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
	signal mem: ram_type := (others => (others => '0')); -- inicializada com zeros
begin
  -- na borda de subida, se we = '1', escreve na palavra de memória endereçada
  -- pelo sinal a
  process(clk)
  begin
     if rising_edge(clk) then
        if (we = '1') then
           -- endereços de palavras avançam de 4 em 4. Por isso, os
	   -- 2 bits menos significativos de 'a' sao desconsiderados.  
           mem(to_integer(unsigned(a(7 downto 2)))) <= wd;
        end if;
     end if;
  end process;
  
  -- Concorrentemente lê a palavra endereçada por a
  rd <= mem(to_integer(unsigned(a(7 downto 2)))); 
end synth;
