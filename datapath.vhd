library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

----- MIPS datapath -----

entity datapath is  
    port (
        clk, reset: in STD_LOGIC;
        memtoreg: in STD_LOGIC;
		  pcsrc: in STD_LOGIC_VECTOR (1 downto 0);
        regdst: in STD_LOGIC;
--------------- REGISTERS SINGNALS ------------------------
		  IRWrite, PCEn, regwrite : in STD_LOGIC;
-----------------------------------------------------------------
		  ALUSrcB: in STD_LOGIC_VECTOR (1 downto 0);
		  ALUSrcA: in STD_LOGIC;
        alucontrol: in STD_LOGIC_VECTOR (2 downto 0);
        zero: out STD_LOGIC;
		  IorD: in STD_LOGIC;
        readdata: in STD_LOGIC_VECTOR(31 downto 0);
		  Adr: out STD_LOGIC_VECTOR(31 downto 0);
		  instr:buffer STD_LOGIC_VECTOR(31 downto 0);
		  B	 : buffer STD_LOGIC_VECTOR(31 downto 0)
    );
end;

architecture struct of datapath is

    -- Componentes
    component ula
        port(
            a, b: in STD_LOGIC_VECTOR(31 downto 0);
            alucontrol: in STD_LOGIC_VECTOR(2 downto 0);
            result: buffer STD_LOGIC_VECTOR(31 downto 0);
            zero: out STD_LOGIC
        );
    end component;

    component regfile
        port(
            clk: in STD_LOGIC;
            we3: in STD_LOGIC;
            ra1, ra2, wa3: in STD_LOGIC_VECTOR(4 downto 0);
            wd3: in STD_LOGIC_VECTOR(31 downto 0);
            rd1, rd2: out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component adder
        port(
            a, b: in STD_LOGIC_VECTOR(31 downto 0);
            y: out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component sl2
        port(
            a: in STD_LOGIC_VECTOR(31 downto 0);
            y: out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component signext
        port(
            a: in STD_LOGIC_VECTOR(15 downto 0);
            y: out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component reg 
        generic (width: integer);
        port(
            clk, reset, enable: in STD_LOGIC;
            d: in STD_LOGIC_VECTOR(width - 1 downto 0);
            q: out STD_LOGIC_VECTOR(width - 1 downto 0)
        );
    end component;
	 component reg2 is 
			generic(width: integer);
			port(clk, reset, enable: in  STD_LOGIC;
					d0, d1:  in  STD_LOGIC_VECTOR(width-1 downto 0);
					q0, q1:          out STD_LOGIC_VECTOR(width-1 downto 0));
	 end component;

    component mux2 
        generic (width: integer);
        port(
            d0, d1: in STD_LOGIC_VECTOR(width-1 downto 0);
            s: in STD_LOGIC;
            y: out STD_LOGIC_VECTOR(width- 1 downto 0)
        );
    end component;
	 
	 component mux4 is 
		generic (width: integer);
		port(
				d0, d1, d2, d3: in  STD_LOGIC_VECTOR(width-1 downto 0);
				s:      in  STD_LOGIC_VECTOR(1 downto 0);
				y:      out STD_LOGIC_VECTOR(width-1 downto 0)
			  );
	end component;
	
	
	
	
component mux3 is 
		  generic (width: integer);
		  port(d0, d1, d2: in  STD_LOGIC_VECTOR(width-1 downto 0);
				 s:      in  STD_LOGIC_VECTOR(1 downto 0);
				 y:      out STD_LOGIC_VECTOR(width-1 downto 0));
end component;



    -- Sinais
    signal writereg: STD_LOGIC_VECTOR(4 downto 0);
    signal pcnext, pc, pcjump: STD_LOGIC_VECTOR(31 downto 0);
    signal signimm, signimmsh: STD_LOGIC_VECTOR(31 downto 0);
    signal srca,srcb, result, AluResult, ALUOut,  A, rs, Data, rt: STD_LOGIC_VECTOR(31 downto 0);
	 signal enable_signal: STD_LOGIC := '1';

	 
	 
begin
    
	 -- FIRST CYCLE LOGIC
	 -- pc logic 
    pcreg: reg generic map(32) port map(
						 clk, 
						 reset, 
						 PCEn,
						 pcnext, 
						 pc
	 );
	 
	 -- multiplexer for reading pc or AluOut 
	 muxmem: mux2 generic map(32) port map(
						pc, 
						ALUOut, 
						IorD, 
						Adr
	 );
	 
	 -- first nonarchitectural register 
	 first_cycle_register: reg generic map(32) port map(
						 clk, 
						 reset, 
						 IRWrite,
						 readdata, 
						 instr
	 );
	 
	 
	 


	 -- Second cylce logic 
	 
    immsh: sl2 port map( 
					 signimm, 
					 signimmsh
	 );
	 

	 
	

    -- Register file logic
	 
	 
    rf: regfile port map(
					 clk,
					 regwrite, 
					 instr(25 downto 21), 
					 instr(20 downto 16), 
					 writereg, 
					 result, 
					 rs, 
					 rt
	 );
	 
	 
	 	 second_cycle_register:  reg2 generic map(32) port map(
	 
				
						 clk, 
						 reset, 
						 enable_signal,
						 rs, 
						 rt, 
						 A, 
						 B
	 );
	 
	 
	 
	 
	 
    wrmux: mux2 generic map(5) port map(
					 instr(20 downto 16), 
					 instr(15 downto 11), 
					 regdst, 
					 writereg
	 );
	 
	 
	 
    se: signext port map(
					 instr(15 downto 0), 
					 signimm
	 );
	 
	 
	 -- THIRD CLYCLE
			
	  srcAmux: mux2 generic map(32) port map(
	             pc,
					 A,
					 AluSrcA,
					 srca	
	  
	  ); 
	
		srcBmux: mux4 generic map(32) port map(
					 B, 
					 X"00000004", 
					 signimm, 
					 signimmsh,
					 ALUSrcB,
					 srcb
	 );
   
	
	
	
	
    mainalu: ula port map(
					 srca, 
					 srcb, 
					 alucontrol, 
					 ALUResult, 
					 zero
	 );
	 
	 
	 third_cycle_register: reg generic map(32) port map(
						 clk, 
						 reset, 
						 enable_signal,
						 ALUResult, 
						 ALUOut
	 );
	 
	 
	 
	 -- Fourth cycle
		pcjump <= pc(31 downto 28) & instr(25 downto 0) & "00";

		pcnextmux:  mux3 generic map(32) port map(
	             ALUResult,
					 ALUOut,
					 pcjump,
					 pcsrc,
					 pcnext	
	  
	  ); 
	  
	  
	  fourth_cycle_register: reg generic map(32) port map(
	  
	  
	  					 clk, 
						 reset, 
						enable_signal,
						 readdata, 
						 Data
	  
	  );
	  

	-- Fifth cycle
	
	  memtoregmux: mux2 generic map(32) port map(
	             ALUOut,
					 Data,
					 memtoreg,
					 result	
	  ); 
		


end;

