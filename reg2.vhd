library IEEE; 
use IEEE.STD_LOGIC_1164.all;  

entity reg2 is 
  generic(width: integer);
  port(clk, reset, enable: in  STD_LOGIC;
       d0, d1:  in  STD_LOGIC_VECTOR(width-1 downto 0);
       q0, q1:          out STD_LOGIC_VECTOR(width-1 downto 0));
end;

architecture synth of reg2 is
begin
  process(clk, reset) begin
    if reset = '1' then  
	    q0 <= (others => '0');
		 q1 <= (others => '0');

    elsif rising_edge(clk) then
		if enable = '1' then
				q0 <= d0;
				q1 <= d1;
		end if;
    end if;
end process;
end;