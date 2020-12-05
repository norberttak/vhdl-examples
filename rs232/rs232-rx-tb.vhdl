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
entity rs232_rx_tb is
end rs232_rx_tb;

-- -----------------------------
architecture behavior of rs232_rx_tb is
    signal s_data       : std_logic_vector(7 downto 0);
    signal s_rx       : std_logic;
    signal s_irq      : std_logic;
    signal s_clk      : std_logic;
    signal s_n_reset  : std_logic;
    signal s_rx_error : std_logic;
begin
    rs_232_rx_inst: entity work.rs232_rx(behaviour) port map (
        rx      => s_rx,
        irq     => s_irq,
        rx_data    => s_data,
        rx_error => s_rx_error,
        clk     => s_clk,
        n_reset   => s_n_reset
    );

    clock_gen_inst: entity work.clock_gen(behaviour) port map (
        clock   => s_clk
    );

    CREATE_TEST_REPORT("Tests for RS232 reciver", "rs232-rx.html");

    main : process
        variable v_test_data  : std_logic_vector(7 downto 0);

        procedure sim_done is
        begin
          assert false report "Test finished" severity note;
          --  Wait forever; this will finish the simulation.
          wait;
        end sim_done;

        procedure send_rs232(data : std_logic_vector(7 downto 0); stop_bit : std_logic) is 
        begin
            s_rx <= '0'; -- start bit
            wait for 104.16 us; -- 9600 baud rate

            for i in 0 to 7 loop
                s_rx <= data(i);
                wait for 104.16 us;
            end loop;
            
            s_rx <= stop_bit; -- 1: valid stop bit, 0: invalid stop bit
            wait for 104.16 us;
            s_rx <= '1';
        end send_rs232;

    begin
    
    -- do a reset cycle at the begining
    s_rx <= '1';
    s_n_reset <= '0';
    wait for 10.0 us;
    s_n_reset <= '1';
    wait for 10.0 us;

    TEST("Receiver test. Send 0x55 data");
    v_test_data := x"55";
    send_rs232(v_test_data, '1');
    wait for 200 us;
    EXPECT_EQ("send a byte. check received data", v_test_data, s_data);
    EXPECT_EQ("check rx_error", '0', s_rx_error);


    TEST("Receiver test. Send 0xAB data");
    v_test_data := x"ab";
    send_rs232(v_test_data, '1');
    wait for 200 us;
    EXPECT_EQ("send a byte. check received data", v_test_data, s_data);
    EXPECT_EQ("check rx_error", '0', s_rx_error);

    TEST("Receiver test. Send 0xBB data with invalid stop bit");
    v_test_data := x"aa";
    send_rs232(v_test_data, '0');
    wait for 200 us;
    EXPECT_EQ("send a byte. check received data", v_test_data, s_data);
    EXPECT_EQ("check rx_error", '1', s_rx_error);

    CLOSE_TEST_REPORT;
    sim_done;
    end process;

end;
