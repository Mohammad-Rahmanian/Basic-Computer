----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:03:12 06/28/2022 
-- Design Name: 
-- Module Name:    CPU - Behavioral 
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
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;


entity CPU is
    Port ( input_data: in  STD_LOGIC_VECTOR (7 downto 0);
           clock, reset : in  STD_LOGIC;
           output_data : out  STD_LOGIC_VECTOR (7 downto 0);
           Address : out  STD_LOGIC_VECTOR (4 downto 0);
           we : out  STD_LOGIC;
           oe : out  STD_LOGIC);
end CPU;

architecture Behavioral of CPU is
	
	signal PC, AddressRegister : STD_LOGIC_VECTOR (4 downto 0);
	signal Accumulator : STD_LOGIC_VECTOR (8 downto 0);
	signal opcode : STD_LOGIC_VECTOR (2 downto 0); 
	type state_t is (si ,s0 ,s1 ,s2 ,s3 ,s4 ,s5,sr ,sw ,sf);
	signal state : state_t := si;

begin
	process(clock, reset)
		begin
			if (reset = '0') then
				Accumulator <= "000000000";
				PC <= "00000";
				AddressRegister <= "00000";
				Address <= "00000";
				state <= si;
				oe <= '1';
				we <= '0';
			elsif(rising_edge(clock)) then
				case state is
					when si =>	--instruction fetch
						AddressRegister <= input_data(4 downto 0);
						opcode <= input_data(7 downto 5);
						PC <= std_logic_vector(unsigned(PC) + 1) ;
						we <= '0' ;
						oe <= '0';
						output_data <= "ZZZZZZZZ" ;
						state <= s0;
					when s0 =>	--choosing the next state using the opcode
						case opcode is
							when "000" | "010" | "011" => -- Load or Add or Nand
								oe <= '1' ;
								Address <= AddressRegister ;
								state <= sr ;
							when "001" => -- Store
								Address <= AddressRegister ;
								state <=  s2;
							when "100" => -- JCC
								if (Accumulator(8) = '0') then
									PC <= AddressRegister;
									Address <= AddressRegister;
								else
									Address <= PC;
								end if;
								oe <= '1';
								state <= sf;
							when "101" => -- SHL
								oe <= '1';
								Address <= PC;
								Accumulator <= Accumulator(7 downto 0) & '0';
								state <= sf;
							when "110" => -- SHR
								oe <= '1';
								Address <= PC;
								Accumulator <= '0' & Accumulator(8 downto 1);
								state <= sf;
							when "111" => -- Halt
								state <= s5;
							when others =>
								Accumulator <= "000000000"; 
								PC <= "00000";
								AddressRegister <= "00000";
								state <= si;
								AddressRegister <= PC;
								oe <= '1';
								we <= '0';
						end case;
					when s1 => -- Load
						Accumulator <= '0' & input_data;
						Address <= PC ;
						oe <= '1';
						state <= sf;
					when s2 => -- Store
						output_data <= Accumulator(7 downto 0);
						we <= '1';
						state <= sw;
					when s3 => -- Add
						Accumulator <= Accumulator + input_data;
						Address <= PC ;
						oe <= '1';
						state <= sf;
					when s4 => -- Nand
						Accumulator(8) <= '0';
						Accumulator(7 downto 0) <= Accumulator(7 downto 0) nand input_data;
						Address <= PC ;
						oe <= '1';
						state <= sf;
					when s5 => -- Halt
							state <= s5;
							oe <= '0';
							we <= '0';
					when sr => -- Read from RAM
						case opcode is
							when "000" => state <= s1 ;
							when "010" => state <= s3 ;
							when "011" => state <= s4 ;
							when others => state <= sf ;
						end case;
					when sw => -- Write to RAM
						we <= '0';
						oe <= '1';
						Address <= PC;
						state <= sf;
					when sf => -- final state
						state <= si;
					when others => state <= sf ;
				end case;
			end if;
		end process;
end Behavioral;







