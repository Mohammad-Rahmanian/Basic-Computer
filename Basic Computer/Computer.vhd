----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:05:30 06/28/2022 
-- Design Name: 
-- Module Name:    Computer - Behavioral 
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

entity Computer is
	Port (  clock, reset : in  STD_LOGIC);
end Computer;

architecture Behavioral of Computer is

	component CPU is
		 Port ( input_data : in  STD_LOGIC_VECTOR (7 downto 0);
				  clock, reset : in  STD_LOGIC;
				  output_data : out  STD_LOGIC_VECTOR (7 downto 0);
				  Address : out  STD_LOGIC_VECTOR (4 downto 0);
				  we : out  STD_LOGIC;
				  oe : out  STD_LOGIC);
	end component CPU;
	component RAM is
		Port( w , r , reset , clock: in std_logic;
				input_data : in std_logic_vector(7 downto 0);
				address : in std_logic_vector(4 downto 0);
				output_data : out std_logic_vector(7 downto 0));

	end component RAM;

	signal ram_to_cpu , cpu_to_ram : STD_LOGIC_VECTOR (7 downto 0);
	signal address : STD_LOGIC_VECTOR (4 downto 0);
	signal r, w : STD_LOGIC;

begin

	CPU_Computer : CPU port map (input_data => ram_to_cpu, clock => clock, reset => reset, output_data => cpu_to_ram, Address => address, we => w, oe => r);
	Memory_Computer : RAM port map (w => w, r => r, reset => reset, clock => clock, address => address, input_data => cpu_to_ram, output_data => ram_to_cpu);

end Behavioral;

