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

entity rs232_rx is
    port(
        rx          : in std_logic;
        rx_data     : out std_logic_vector(7 downto 0);
        irq         : out std_logic;
        rx_error    : out std_logic;

        clk         : in std_logic;
        n_reset     : in std_logic
    );
end rs232_rx;

architecture behaviour of rs232_rx is
    type state_type is (IDLE, START, DATA, STOP);
    signal s_rs232_state : state_type;
    signal s_bit_count : integer;
    signal s_baudx8 : std_logic;
    signal s_baud_tick : integer; 
    signal s_rx_data   : std_logic_vector(7 downto 0);
    signal s_irq    : std_logic;
    signal s_rx_error   : std_logic;
begin

    irq <= '0';
    rx_error <= '0';
    rx_data <= (others => '0');
    -- Your implementation shall be here

end behaviour;
