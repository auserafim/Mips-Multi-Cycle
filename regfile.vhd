library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_std.all; 

entity regfile is 
  port(clk:           in  STD_LOGIC;
       we3:           in  STD_LOGIC;
       ra1, ra2, wa3: in  STD_LOGIC_VECTOR(4 downto 0);   -- ra1 e ra2: endereços p/ leitura; wa3: endereco p/ escrita
       wd3:           in  STD_LOGIC_VECTOR(31 downto 0);  -- conteudo a ser gravado no endereco wa3
       rd1, rd2:      out STD_LOGIC_VECTOR(31 downto 0)); -- portas de leitura: rd1 associado a ra1 e rd2 associado ra2
end;

architecture synth of regfile is
  type ramtype is array (31 downto 0) of STD_LOGIC_VECTOR(31 downto 0); -- 32 registradores de 32 bits
  signal mem: ramtype;
begin
  -- escrita sincronizada na borda de subida do sinal de clock
  process(clk) begin
    if rising_edge(clk) then
       if we3 = '1' then 
		    mem(to_integer(unsigned(wa3))) <= wd3;
       end if;
    end if;
  end process;
  
  -- leitura combinacional para rd1 e rd2 a partir dos enderecos ra1 e ra2
  -- registrador 0 sempre em 0
  process(all) begin
    if (to_integer(unsigned(ra1)) = 0) then 
	     rd1 <= X"00000000"; -- registrador 0 sempre em 0
    else 
	     rd1 <= mem(to_integer(unsigned(ra1)));
    end if;
    
	 if (to_integer(unsigned(ra2)) = 0) then 
	    rd2 <= X"00000000";  -- registrador 0 sempre em 0
    else 
	    rd2 <= mem(to_integer(unsigned(ra2)));
    end if;
  end process;
end synth;