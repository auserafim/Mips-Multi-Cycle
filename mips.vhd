library IEEE; 
use IEEE.STD_LOGIC_1164.all;

 
entity mips is
  port(clk, reset:        in  STD_LOGIC;
       pc:                out STD_LOGIC_VECTOR(31 downto 0);
       instr:             in  STD_LOGIC_VECTOR(31 downto 0);
       memwrite:          out STD_LOGIC;
       aluout, writedata: out STD_LOGIC_VECTOR(31 downto 0);
       readdata:          in  STD_LOGIC_VECTOR(31 downto 0));
end;

architecture struct of mips is
  component controller
    port(op, funct:          in  STD_LOGIC_VECTOR(5 downto 0);
         zero:               in  STD_LOGIC;
         memtoreg, memwrite: out STD_LOGIC;
         pcsrc, alusrc:      out STD_LOGIC;
         regdst, regwrite:   out STD_LOGIC;
         jump:               out STD_LOGIC;
         alucontrol:         out STD_LOGIC_VECTOR(2 downto 0));
  end component;
  component datapath
    port(clk, reset:        in  STD_LOGIC;
         memtoreg, pcsrc:   in  STD_LOGIC;
         alusrc, regdst:    in  STD_LOGIC;
         regwrite, jump:    in  STD_LOGIC;
         alucontrol:        in  STD_LOGIC_VECTOR(2 downto 0);
         zero:              out STD_LOGIC;
         pc:                buffer STD_LOGIC_VECTOR(31 downto 0);
         instr:             in STD_LOGIC_VECTOR(31 downto 0);
         aluout, writedata: buffer STD_LOGIC_VECTOR(31 downto 0);
         readdata:          in  STD_LOGIC_VECTOR(31 downto 0));
  end component;
  signal memtoreg, alusrc, regdst, regwrite, jump, pcsrc: STD_LOGIC;
  signal zero: STD_LOGIC;
  signal alucontrol: STD_LOGIC_VECTOR(2 downto 0);
begin
  -- Instancie a unidade de controle (controller) conectando os sinais de entrada  de forma apropriada
  
  	INPUT_CONTROLLER: controller port map(
			  op         => instr(31 downto 26),
			  funct      => instr(5  downto 0 ),
			  zero       => zero,
			  memtoreg   => memtoreg, 
			  memwrite   => memwrite,
			  pcsrc		 => pcsrc,
			  alusrc     => alusrc,
			  regdst     => regdst,
			  regwrite   => regwrite,
			  jump       => jump,
			  alucontrol => alucontrol
	);

  -- Instancie o datapath conectando os sinais de controle gerados pela unidade de controle
  	INPUT_DATAPATH: datapath port map(
		      -- inputs
				clk 	   	      => clk,
				reset			      => reset,
				memtoreg 			=> memtoreg,
				pcsrc			      => pcsrc,
				alusrc            => alusrc,
				regdst				=> regdst,
				regwrite          => regwrite,
			   jump				   => jump,
				alucontrol			=> alucontrol,
				zero					=> zero,
				pc                => pc,
				instr					=> instr,
				aluout            => aluout,
				writedata         => writedata,
				readdata          => readdata
);
end;
