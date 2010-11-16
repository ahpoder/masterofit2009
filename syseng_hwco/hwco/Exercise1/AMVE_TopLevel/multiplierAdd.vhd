
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplieradd is
  port( dataa,datab : in 	std_logic_vector(31 downto 0);
        result		: out	std_logic_vector(31 downto 0)); 
end multiplieradd;

architecture customInst of multiplieradd is
signal result1,result2,result3,result4 : std_logic_vector(15 downto 0); 
signal i_sum : std_logic_vector(7 downto 0); 
begin
  result1 <= std_logic_vector(unsigned(dataa(31 downto 24)) * unsigned(datab(31 downto 24))); 
  result2 <= std_logic_vector(unsigned(dataa(23 downto 16)) * unsigned(datab(23 downto 16))); 
  result3 <= std_logic_vector(unsigned(dataa(15 downto  8)) * unsigned(datab(15 downto  8))); 
  result4 <= std_logic_vector(unsigned(dataa( 7 downto  0)) * unsigned(datab( 7 downto  0))); 
 
  i_sum <= std_logic_vector(unsigned(result1(7 downto 0)) + unsigned(result2(7 downto 0)) + unsigned(result3(7 downto 0)) + unsigned(result4(7 downto 0)));
  result <= X"000000" & i_sum;
  
end customInst;
