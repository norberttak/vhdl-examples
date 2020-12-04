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

library work;
use work.utest.all; 

-- -----------------------------
entity and_gate_tb is
end and_gate_tb;

-- -----------------------------
architecture behavior of and_gate_tb is
    signal s_a : bit;
    signal s_b : bit;
    signal s_q : bit;
begin
    and_gate_inst: entity work.and_gate(behaviour) port map (
        a     => s_a,
        b     => s_b,
        q     => s_q
    );

    CREATE_TEST_REPORT("AND gate test", "and-gate.html");
    TEST("Test input conbinations");
    main : process
    
        procedure sim_done is
        begin
          assert false report "Test finished" severity note;
          --  Wait forever; this will finish the simulation.
          wait;
        end sim_done;

    begin
    
    --test case 1 and 1
    s_a <= '1';
    s_b <= '1';
    wait for 10.0 ns;
    EXPECT_EQ("1 and 1", '1', s_q);

    --test case 0 and 1
    s_a <= '0';
    s_b <= '1';
    wait for 10.0 ns;
    EXPECT_EQ("0 and 1", '0', s_q);

    --test case 1 and 0
    s_a <= '1';
    s_b <= '0';
    wait for 10.0 ns;
    EXPECT_EQ("1 and 0", '0', s_q);

    --test case 0 and 0
    s_a <= '0';
    s_b <= '0';
    wait for 10.0 ns;
    EXPECT_EQ("0 and 0", '0', s_q);

    CLOSE_TEST_REPORT;
    sim_done;
    end process;

end;
