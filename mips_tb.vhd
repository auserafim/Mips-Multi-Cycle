library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;

entity mips_tb is
end mips_tb;

architecture test of mips_tb is
  component mips is
    port(
      clk       : in  STD_LOGIC;
      reset     : in  STD_LOGIC;
      readdata  : inout STD_LOGIC_VECTOR(31 downto 0);
      memwrite  : inout STD_LOGIC;
      adr       : inout STD_LOGIC_VECTOR(31 downto 0);
      B         : inout STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;

  -- Testbench signals
  signal B, adr, readdata: STD_LOGIC_VECTOR(31 downto 0);
  signal clk, reset, memwrite: STD_LOGIC;

begin

  dut: mips port map(
    clk => clk,
    reset => reset,
    readdata => readdata,
    memwrite => memwrite,
    adr => adr,
    B => B
  );


  clk_process: process
  begin
    clk <= '1';
    wait for 5 ns; 
    clk <= '0';
    wait for 5 ns;
  end process;

      -- reset for the first two cycles 
  reset_process: process
  begin
    reset <= '1';
    wait for 1 ns; 
    reset <= '0';
    wait; 
  end process;

  -- check if the value 7 was written to address 84
  check_process: process (clk)
    variable adr_int: integer;
    variable B_int: integer;
  begin
    if falling_edge(clk) then
      if memwrite = '1' then
        -- convert adr and B to integer
        adr_int := to_integer(unsigned(adr));
        B_int := to_integer(signed(B));
        
        -- check for success
        if (adr_int = 84 and B_int = 7) then 
          report "[success]" severity note;
        elsif (adr_int /= 84) then 
          report "[simulation failed]" severity error;
        end if;
      end if;
    end if;
  end process;

end architecture;
