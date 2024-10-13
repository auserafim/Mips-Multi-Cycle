library IEEE; 
use IEEE.STD_LOGIC_1164.all;  

entity reg is 
  generic(width: integer);
  port(clk, reset, enable: in  STD_LOGIC;
       d:          in  STD_LOGIC_VECTOR(width-1 downto 0);
       q:          out STD_LOGIC_VECTOR(width-1 downto 0));
end;

architecture synth of reg is
begin
  process(clk, reset) begin
    if reset = '1' then  
	    q <= (others => '0');
    elsif rising_edge(clk) then
		if enable = '1' then
				q <= d;
		end if;
    end if;
end process;
end;