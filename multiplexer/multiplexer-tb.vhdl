-- Copyright 2020, Norbert Takacs (norberttak@gmail.com)
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.utest.all; 

-- -----------------------------
entity multiplexer_tb is
end multiplexer_tb;

-- -----------------------------
architecture behavior of multiplexer_tb is
    signal s_data   : std_logic_vector(7 downto 0);
    signal s_addr   : std_logic_vector(2 downto 0);
    signal s_q      : std_logic;
begin
    multiplexer_inst: entity work.multiplexer(behaviour) port map (
        data     => s_data,
        addr     => s_addr,
        q        => s_q
    );

    CREATE_TEST_REPORT("Multiplexer", "multiplexer.html");
    TEST("Test basic combinations");
    main : process
    
        procedure sim_done is
        begin
          assert false report "Test finished" severity note;
          --  Wait forever; this will finish the simulation.
          wait;
        end sim_done;

    begin
    
    --test case select input 0
    s_data <= "00000001";
    s_addr <= "000";
    wait for 10.0 ns;
    EXPECT_EQ("select input 0", '1', s_q);

    s_data <= "00000001";
    s_addr <= "001";
    wait for 10.0 ns;
    EXPECT_EQ("select input 1", '0', s_q);

    s_data <= "00000010";
    s_addr <= "001";
    wait for 10.0 ns;
    EXPECT_EQ("select input 1", '1', s_q);

    CLOSE_TEST_REPORT;
    sim_done;
    end process;

end;
