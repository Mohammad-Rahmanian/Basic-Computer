----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:56:10 06/28/2022 
-- Design Name: 
-- Module Name:    RAM - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_arith.ALL;

entity RAM is
	port(
		address : in std_logic_vector(4 downto 0);
		w , r , reset , clock: in std_logic;
		input_data : in std_logic_vector(7 downto 0);
		output_data : out std_logic_vector(7 downto 0)
	);
end RAM;
architecture Behavioral of RAM is
type mem_type is array (0 to 31) of std_logic_vector(7 downto 0);
signal block_ram : mem_type := ( "00011111" ,	--load
										   "01011110" ,	--add
											"01111101" ,	--nand
											"00111111" ,	--store
											"10100000" ,	--shl
											"11000000" ,	--shr
											"10011100" ,	--branch
											"00011011" ,	--load
											"11111111" ,	--Halt
										    "00000000" ,
											"00000000" ,
											"00000000" ,
											"00000000" ,
											"00000000" ,
											"00000000" ,
											"00000000" ,
											"00000000" ,
											"00000000" ,
											"00000000" ,
											"00000000" ,
											"00000000" ,
											"00000000" ,
											"00000000" ,
											"00000000" ,
											"00000000" ,
											"00000000" ,
											"00000000" ,
											"00000000" ,
											"00000000" ,
											"10101010" ,
											"00000011" , 
											"00000001" );

begin
	process (clock)
		begin
			if rising_edge(clock) then
				if (w = '1') and (r = '0') then
					block_ram(conv_integer(address)) <= input_data;
				elsif (w = '0') and (r = '1') then
					output_data <= block_ram(conv_integer(address));
				end if;
			end if;
		end process;
end Behavioral;

