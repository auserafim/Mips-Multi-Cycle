library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity controller is 
  port(op, funct:          in  STD_LOGIC_VECTOR(5 downto 0);
       zero:               in  STD_LOGIC;
       memtoreg, memwrite: out STD_LOGIC;
       pcsrc, alusrc:      out STD_LOGIC;
       regdst, regwrite:   out STD_LOGIC;
       jump:               out STD_LOGIC;
       alucontrol:         out STD_LOGIC_VECTOR(2 downto 0));
end;


architecture struct of controller is
  component maindec
    port(op:                 in  STD_LOGIC_VECTOR(5 downto 0);
         memtoreg, memwrite: out STD_LOGIC;
         branch, alusrc:     out STD_LOGIC;
         regdst, regwrite:   out STD_LOGIC;
         jump:               out STD_LOGIC;
         aluop:              out STD_LOGIC_VECTOR(1 downto 0));
  end component;
  component aludec
    port(funct:      in  STD_LOGIC_VECTOR(5 downto 0);
         aluop:      in  STD_LOGIC_VECTOR(1 downto 0);
         alucontrol: out STD_LOGIC_VECTOR(2 downto 0));
  end component;
  
  signal aluop:  STD_LOGIC_VECTOR(1 downto 0);
  signal branch: STD_LOGIC;
begin
  -- Faça: Instancie o main decoder (maindec) passando op (opcode) e os 9 sinais de saida.
  -- Referência:  figura 7.11 e 7.12 do livro.
  
  
	INPUT_MAINDECODER: maindec port map (
			op       => op,
         memtoreg => memtoreg,
			memwrite => memwrite,
         branch   => branch,
			alusrc   => alusrc,
         regdst   => regdst,
			regwrite => regwrite,
         jump 		=> jump,
         aluop    => aluop
	
	);
  


  --Faça: instancie o alu decoder (aludec) a saida desse modulo deve ser direcionada
  -- para o sinal de saida alucontrol, que controlara a ula (veja figuras 7.11 e 7.12) 
  
   INPUT_ALUDEC: aludec port map(
	
	
			funct      => funct,
			aluop      => aluop,
			alucontrol => alucontrol
	
	
	);
  

  -- Faça: Elabore a lógica do pcsrc usando uma porta and.
  -- Esse bit será o seletor do primeiro mux2 na entrada do PC (veja figura 7.14)
  pcsrc <= branch and zero;

end;