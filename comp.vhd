library IEEE; 
use IEEE.STD_LOGIC_1164.all; 

-- top-level design: interliga o processador com as memórias de
-- instrucao e de dados, ou seja, define o computador. Para uma melhor
-- compreensao sobre os sinais, observe o projeto da figura 7.59 do livro.

entity comp is 
  port(clk, reset:           in     STD_LOGIC;
       writedata, dataadr:   buffer STD_LOGIC_VECTOR(31 downto 0);
       memwrite:             buffer STD_LOGIC);
end;

architecture test of comp is
  component mips 
    port(clk, reset:        in  STD_LOGIC;
         pc:                out STD_LOGIC_VECTOR(31 downto 0);
         instr:             in  STD_LOGIC_VECTOR(31 downto 0);
         memwrite:          out STD_LOGIC;
         aluout, writedata: out STD_LOGIC_VECTOR(31 downto 0);
         readdata:          in  STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component instructmem
    port(a:  in  STD_LOGIC_VECTOR(5 downto 0);
         rd: out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component datamem
    port(clk, we:  in STD_LOGIC;
         a, wd:    in STD_LOGIC_VECTOR(31 downto 0);
         rd:       out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  signal pc, instr, 
         readdata: STD_LOGIC_VECTOR(31 downto 0);
begin
  -- instancie o processador (mips) e as memórias (insrtuctmem e datamem) e interligue-os de acordo com a 
  -- figura 7.59 do livro
  
  
    INPUT_MIPS: mips port map(
			clk			=> clk,
			reset			=> reset,
         pc				=> pc,
         instr			=> instr,
         memwrite		=> memwrite,
         aluout  		=> dataadr,
			writedata	=> writedata,
         readdata		=> readdata
		);
  
  -- instanciacao da memoria
  imem1:  instructmem port map( 
			pc(7 downto 2), 
			instr
  );

  dmem1:  datamem port map(
			  clk, 
			  memwrite, 
			  dataadr, 
			  writedata, 
			  readdata
  );
end test;

