library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;


entity testbench is
end testbench;

architecture test of testbench is
  component comp
    port(clk, reset:           in  STD_LOGIC;
         writedata, dataadr:   out STD_LOGIC_VECTOR(31 downto 0);
         memwrite:             out STD_LOGIC);
  end component;
  signal writedata, dataadr:    STD_LOGIC_VECTOR(31 downto 0);
  signal clk, reset,  memwrite: STD_LOGIC;
begin

  -- instancie o computador (comp)
  dut: comp port map(clk, reset, writedata, dataadr, memwrite);

  -- Gera um clock com periodo de 10 ns
  process begin
    clk <= '1';
    wait for 5 ns; 
    clk <= '0';
    wait for 5 ns;
  end process;
  
  -- reseta nos primeiros dois ciclos
  process begin
    reset <= '1';
    wait for 22 ns;
    reset <= '0';
    wait;
  end process;

  
  
  -- Verifica se o valor 7 foi escrito para o endereco 84
  process (clk)
    variable dataadr_int: integer;
    variable writedata_int: integer;
  begin
    if falling_edge(clk) then
      if memwrite = '1' then
        -- Convert dataadr and writedata to integer
        dataadr_int := to_integer(unsigned(dataadr));
        writedata_int := to_integer(signed(writedata));
        
		  if (dataadr_int = 84 and writedata_int = 7) then 
            report "Sem erros: Sucesso" severity failure;
        elsif (dataadr_int /= 80) then 
            report "Simulacao falhou!" severity failure;
        end if;
       end if;
    end if;
  end process;
end;