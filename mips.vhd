library IEEE; 
use IEEE.STD_LOGIC_1164.all;

 
entity mips is
  port(clk, reset:        in  STD_LOGIC;
       readdata:          inout  STD_LOGIC_VECTOR(31 downto 0);
       memwrite:          inout STD_LOGIC;
		 adr		: 			  inout STD_LOGIC_VECTOR(31 downto 0);
		 B			: 			  inout STD_LOGIC_VECTOR(31 downto 0)
		 );
end;

architecture struct of mips is

component controller is 
  port(op :					  in  STD_LOGIC_VECTOR(5 downto 0);
		 funct	:          in  STD_LOGIC_VECTOR(5 downto 0);
		 clk: in  STD_LOGIC;
		 reset :               in  STD_LOGIC;
		 memtoreg:out STD_LOGIC;
		 regdst  : out STD_LOGIC;
		 iord					 : out STD_LOGIC;
		 pcsrc				 : out STD_LOGIC_VECTOR(1 downto 0);
		 alusrcb				 : out STD_LOGIC_VECTOR(1 downto 0);
		 alusrca				 : out STD_LOGIC;
		 irwrite	          : out STD_LOGIC;
		 memwrite			 : out STD_LOGIC;
		 regwrite			 : out STD_LOGIC;
		 alucontrol        : out STD_LOGIC_VECTOR(2 downto 0);
		 branch				 : out STD_LOGIC;
		 pcwrite				 : out STD_LOGIC
		 );
end component;
  
  
component datapath is  
    port (
        clk: in STD_LOGIC;
		  reset: in STD_LOGIC;
        memtoreg: in STD_LOGIC;
		  pcsrc: in STD_LOGIC_VECTOR (1 downto 0);
        regdst: in STD_LOGIC;
--------------- REGISTERS SINGNALS ------------------------
		  IRWrite:in STD_LOGIC;
		  PCEn : in STD_LOGIC;
		  regwrite : in STD_LOGIC;
-----------------------------------------------------------------
		  ALUSrcB: in STD_LOGIC_VECTOR (1 downto 0);
		  ALUSrcA: in STD_LOGIC;
        alucontrol: in STD_LOGIC_VECTOR (2 downto 0);
        zero: out STD_LOGIC;
		  IorD: in STD_LOGIC;
        readdata: in STD_LOGIC_VECTOR(31 downto 0);
		  Adr: out STD_LOGIC_VECTOR(31 downto 0);
		  instr: buffer STD_LOGIC_VECTOR(31 downto 0);
		  	B	 : buffer STD_LOGIC_VECTOR(31 downto 0)

    );
end component;



component datamem is 
  port(
    clk    : in  STD_LOGIC;
    we     : in  STD_LOGIC;              -- Write enable for data
    a      : in  STD_LOGIC_VECTOR(31 downto 0); -- Address
    wd     : in  STD_LOGIC_VECTOR(31 downto 0); -- Write data
    rd     : out STD_LOGIC_VECTOR(31 downto 0) -- Read data
  );
end component;


			-- signals 
			
			
			 signal and1, pcwrite, branch: STD_LOGIC;
			
	 signal memtoreg,     regdst,      iord,    alusrca,   irwrite,     regwrite, zero, PCEn: STD_LOGIC;

    signal pcsrc, alusrcb: STD_LOGIC_VECTOR(1 downto 0);
	 signal alucontrol        : STD_LOGIC_VECTOR(2 downto 0);
	 signal instr: std_logic_vector(31 downto 0);

 
begin
  -- Instancie a unidade de controle (controller) conectando os sinais de entrada  de forma apropriada
  
  	INPUT_CONTROLLER: controller port map(
			  op         => instr(31 downto 26),
			  funct      => instr(5  downto 0 ),
			  clk 		=> clk,
			  reset   => reset,
			  memtoreg   => memtoreg, 
			  regdst     => regdst,
				iord => iord,
				pcsrc		 => pcsrc,
				alusrcb     => alusrcb,
			  alusrca    => alusrca,
			  irwrite	=> irwrite,
			  memwrite   => memwrite,
			  regwrite   => regwrite,
			  alucontrol => alucontrol,
			  branch		 => branch,
				pcwrite	=>pcwrite

	);

  	INPUT_DATAPATH: datapath port map(
		      -- inputs
				clk 	   	      => clk,
				reset			      => reset,
				memtoreg 			=> memtoreg,
				pcsrc			      => pcsrc,
				regdst				=> regdst,	
				IRWrite 				=> irwrite,
				PCEn  	  			=> PCEn,
				regwrite  		   => regwrite,
				ALUSrcB 	  			=>alusrcb,
				ALUSrcA 	  			=> alusrca, -- error cause of the case sensitivity
				alucontrol 			=>alucontrol,
				zero					=> zero,
				IorD 					=> iord,
				readdata 			=> readdata,
				Adr  					=> adr,
				instr					=> instr,
				B						=> B

);





		INPUT_MEMORY: datamem port map(
		
	
    clk => clk,  
    we    => memwrite,
    a     =>adr,
    wd    =>B,
    rd    =>readdata
		
		);
		
		
		
		
		
		
		
	and1 <= branch and zero;
   PCEn <= and1 or pcwrite;

end;
