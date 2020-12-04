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
entity full_add_tb is
end full_add_tb;

-- -----------------------------
architecture behavior of full_add_tb is
    signal s_a      : std_logic;
    signal s_b      : std_logic;
    signal s_cIn    : std_logic;
    signal s_sum    : std_logic;
    signal s_cOut   : std_logic;
    signal s_clk    : std_logic;
    signal s_n_reset  : std_logic;
begin
    full_add_inst: entity work.full_add(behaviour) port map (
        a     => s_a,
        b     => s_b,
        cIn        => s_cIn,
        sum     => s_sum,
        cOut    => s_cOut,
        clk     => s_clk,
        n_reset   => s_n_reset
    );

    clock_gen_inst: entity work.clock_gen(behaviour) port map (
        clock   => s_clk
    );

    CREATE_TEST_REPORT("Tests for the 1bit full add", "fulladd.html");

    main : process
    
        procedure sim_done is
        begin
          assert false report "Test finished" severity note;
          --  Wait forever; this will finish the simulation.
          wait;
        end sim_done;

    begin
    
    -- do a reset cycle at the begining
    s_n_reset <= '0';
    wait for 10.0 ns;
    s_n_reset <= '1';
    wait for 10.0 ns;


    TEST("a=0, b=0, cIn=0");
    s_a <= '0';
    s_b <= '0';
    s_cIn <= '0';
    wait for 10.0 ns;
    EXPECT_EQ("value of sum", '0', s_sum);
    EXPECT_EQ("value of cOut", '0', s_cOut);

    TEST("a=1, b=0, cIn=0");
    s_a <= '1';
    s_b <= '0';
    s_cIn <= '0';
    wait for 10.0 ns;
    EXPECT_EQ("value of sum", '1', s_sum);
    EXPECT_EQ("value of cOut", '0', s_cOut);

    TEST("a=0, b=1, cIn=0");
    s_a <= '0';
    s_b <= '1';
    s_cIn <= '0';
    wait for 10.0 ns;
    EXPECT_EQ("value of sum", '1', s_sum);
    EXPECT_EQ("value of cOut", '0', s_cOut);

    TEST("a=1, b=1, cIn=0");
    s_a <= '1';
    s_b <= '1';
    s_cIn <= '0';
    wait for 10.0 ns;
    EXPECT_EQ("value of sum", '0', s_sum);
    EXPECT_EQ("value of cOut", '1', s_cOut);

    TEST("a=1, b=1, cIn=1");
    s_a <= '1';
    s_b <= '1';
    s_cIn <= '1';
    wait for 10.0 ns;
    EXPECT_EQ("value of sum", '1', s_sum);
    EXPECT_EQ("value of cOut", '1', s_cOut);

    CLOSE_TEST_REPORT;
    sim_done;
    end process;

end;
