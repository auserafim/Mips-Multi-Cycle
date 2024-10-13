library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity maindec is 
  port(op:                 in  STD_LOGIC_VECTOR(5 downto 0);
       memtoreg, memwrite: out STD_LOGIC;
       branch, alusrc:     out STD_LOGIC;
       regdst, regwrite:   out STD_LOGIC;
       jump:               out STD_LOGIC;
       aluop:              out STD_LOGIC_VECTOR(1 downto 0));
end;

architecture synth of maindec is
  signal controls: STD_LOGIC_VECTOR(8 downto 0);
begin
  -- Veja as tabelas 7.1, 7.2 e 7.3 do livro para entender os sinais gerados
  process(all) begin
    case op is
      when "000000" => controls <= "110000010"; -- RTYPE
      when "100011" => controls <= "101001000"; -- LW
      when "101011" => controls <= "001010000"; -- SW
      when "000100" => controls <= "000100001"; -- BEQ
      when "001000" => controls <= "101000000"; -- ADDI
      when "000010" => controls <= "000000100"; -- J
      when others   => controls <= "---------"; -- illegal op
    end case;
  end process;
 
  regwrite   <= controls(8);   -- 1 bit for regwrite
  regdst     <= controls(7);   -- 1 bit for regdst
  alusrc     <= controls(6);   -- 1 bit for alusrc
  branch     <= controls(5);   -- 1 bit for branch
  memwrite   <= controls(4);   -- 1 bit for memwrite
  memtoreg   <= controls(3);   -- 1 bit for memtoreg
  jump       <= controls(2);   -- 1 bit for jump
  aluop      <= controls(1 downto 0); -- 2 bits for aluop
end synth;
