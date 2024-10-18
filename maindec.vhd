library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity maindec is 
  port(
    op          : in  STD_LOGIC_VECTOR(5 downto 0);
    -- register selects --
    memtoreg    : out STD_LOGIC;
    regdst      : out STD_LOGIC;
    iord        : out STD_LOGIC;
    pcsrc       : out STD_LOGIC_VECTOR(1 downto 0);
    alusrcb     : out STD_LOGIC_VECTOR(1 downto 0);
    alusrca     : out STD_LOGIC;
    
    -- register enables --
    irwrite     : out STD_LOGIC;
    memwrite    : out STD_LOGIC;
    pcwrite     : out STD_LOGIC;
    branch      : out STD_LOGIC;
    regwrite    : out STD_LOGIC;
    aluop       : out STD_LOGIC_VECTOR(1 downto 0);
    clk         : in  STD_LOGIC;
    reset       : in  STD_LOGIC
  );
end maindec;

architecture synth of maindec is
  type statetypeSigs is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11);
  signal state, nextstate: statetypeSigs;

begin
  -- State register process
  process(clk, reset)
  begin 
    if reset = '1' then
      state <= S0;
    elsif rising_edge(clk) then 
      state <= nextstate;
    end if;
  end process;

  -- Next state logic process
  process(state, op)
  begin
    case state is
      when S0 =>
        nextstate <= S1;

      when S1 =>
        if (op = "100011" or op = "101011") then 
          nextstate <= S2; -- lw or sw

        elsif (op = "000000") then 
          nextstate <= S6; -- r-type

        elsif (op = "000100") then 
          nextstate <= S8; -- beq

        elsif (op = "001000") then 
          nextstate <= S9; -- addi

        elsif (op = "000010") then 
          nextstate <= S11; -- jump

        end if;

      when S2 =>
        if (op = "100011") then -- lw
          nextstate <= S3;
        else -- sw
          nextstate <= S5;
        end if;

      when S3 => 
        nextstate <= S4;

      when S4 =>
        nextstate <= S0;

      when S5 =>
        nextstate <= S0;

      when S6 =>
        nextstate <= S7;
    
      when S7 =>
        nextstate <= S0;

      when S8 =>
        nextstate <= S0;

      when S9 =>
        nextstate <= S10;

      when S10 =>
        nextstate <= S0;

      when S11 =>
        nextstate <= S0;

      when others =>
        nextstate <= S0;

    end case;
  end process;

  -- Output logic process
  process(state)
  begin
    -- all signals assigned to zero at the beginning of the process
	 -- if select signal is not asserted they are don’t cares. Otherwise,  they are zero if – they are register enable signals 
    memtoreg <= '0';
    regdst   <= '0';
    iord     <= '0';
    pcsrc    <= "00";
    alusrcb  <= "00";
    alusrca  <= '0';
    irwrite  <= '0';
    memwrite <= '0';
    pcwrite  <= '0';
    branch   <= '0';
    regwrite <= '0';
    aluop    <= "00";
	 
	

    -- Set control signals based on state
    case state is
      when S0 => -- fetch
        iord      <= '0';
        alusrca <= '0';
        alusrcb <= "01";
        aluop    <= "00";
        pcsrc    <="00";
        irwrite <= '1';
        pcwrite <= '1';

      when S1 =>
        alusrca <= '0';   
        alusrcb <= "11"; 
        aluop    <= "00";

      when S2 =>

        alusrca <= '1';   
        alusrcb <= "10";         
        aluop   <= "00";

      when S3 =>
        iord <= '1';
        

      when S4 =>
        regdst <= '0';
        memtoreg <= '1';
        regwrite <= '1';

      when S5 =>
        iord <= '1';
        memwrite <= '1';

      when S6 =>
        alusrca <= '1'; 
        alusrcb <= "00";   
        aluop <= "10";     

      when S7 =>
        regdst <= '1';    
        regwrite <= '1';
        memtoreg <='0';  

      when S8 =>
        alusrca <= '1';   
        alusrcb <= "00"; 
        aluop <= "01";    
        branch <= '1';
        pcsrc <= "01";  

      when S9 =>
        alusrca <= '1';   
        alusrcb <= "10"; 
        aluop <= "00";  

      when S10 =>
        regwrite <= '1';
        regdst <='0';  
        memtoreg<='0';  

      when S11 =>
        pcsrc <= "10";
        pcwrite <= '1';

      when others =>
        null;
    end case;
  end process;

end architecture;



