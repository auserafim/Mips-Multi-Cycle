library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity controller is 
  port(op, funct:          in  STD_LOGIC_VECTOR(5 downto 0);
        clk, reset :               in  STD_LOGIC;
		 memtoreg, regdst  : out STD_LOGIC;
		 iord					 : out STD_LOGIC;
		 pcsrc				 : out STD_LOGIC_VECTOR(1 downto 0);
		 alusrcb				 : out STD_LOGIC_VECTOR(1 downto 0);
		 alusrca				 : out STD_LOGIC;
		 ------ regiter enables ------
		 irwrite	          : out STD_LOGIC;
		 memwrite			 : buffer STD_LOGIC;
		 regwrite			 : out STD_LOGIC;
		 alucontrol        : out STD_LOGIC_VECTOR(2 downto 0);
		 branch				 : out STD_LOGIC;
		 pcwrite				 : out STD_LOGIC
		 
		 
		 
		 );
end;


architecture struct of controller is


component maindec is 
  port(
    op          : in  STD_LOGIC_VECTOR(5 downto 0);
    memtoreg    : out STD_LOGIC;
    regdst      : out STD_LOGIC;
    iord        : out STD_LOGIC;
    pcsrc       : out STD_LOGIC_VECTOR(1 downto 0);
    alusrcb     : out STD_LOGIC_VECTOR(1 downto 0);
    alusrca     : out STD_LOGIC;
    irwrite     : out STD_LOGIC;
    memwrite    : out STD_LOGIC;
    pcwrite     : out STD_LOGIC;
    branch      : out STD_LOGIC;
    regwrite    : out STD_LOGIC;
    aluop       : out STD_LOGIC_VECTOR(1 downto 0);
    clk         : in  STD_LOGIC;
    reset       : in  STD_LOGIC
  );
end component;



  component aludec
    port(funct:      in  STD_LOGIC_VECTOR(5 downto 0);
         aluop:      in  STD_LOGIC_VECTOR(1 downto 0);
         alucontrol: out STD_LOGIC_VECTOR(2 downto 0));
  end component;
  


 signal aluop       : STD_LOGIC_VECTOR(1 downto 0);
begin
  
  
  
	INPUT_MAINDECODER: maindec port map (
    op,
    memtoreg,
    regdst,
    iord,
    pcsrc,
    alusrcb,
    alusrca,
    irwrite,
    memwrite,
    pcwrite,
    branch,
    regwrite,
    aluop,
    clk,
    reset
	
	);
 
  
   INPUT_ALUDEC: aludec port map(
			funct,
			aluop,
			alucontrol
	);
  



end struct;