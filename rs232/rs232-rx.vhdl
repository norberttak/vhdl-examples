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
    baud_generator_inst: entity work.baud_generator(behaviour) 
        port map (
          clk     => clk,
          baudx8  => s_baudx8,
          n_reset => n_reset
        );

    process (s_baudx8, n_reset)
    begin
        if (n_reset = '0') then
            s_rx_data <= (others=>'0');
            s_irq  <= '0';
            s_baud_tick <= 0;
            s_bit_count <= 0;
            s_rs232_state <= IDLE;
        elsif (s_baudx8'event and s_baudx8='1') then

            case s_rs232_state is
                when IDLE =>
                    s_baud_tick <= 0;
                    s_bit_count <= 0;
                    s_irq       <= '0';
                    if rx = '0' then
                        s_rs232_state <= START;
                    end if;

                when START =>
                    s_rx_error <= '0';
                    if (s_baud_tick = 7) then
                        s_rs232_state <= DATA;
                        s_baud_tick <= 0;
                    else
                        s_baud_tick <= s_baud_tick + 1;
                    end if;

                when DATA =>
                    s_baud_tick <= s_baud_tick + 1;
                    if (s_baud_tick = 4) then
                        s_rx_data(s_bit_count) <= rx;
                    elsif (s_baud_tick = 7) then
                        s_baud_tick <= 0;
                        if (s_bit_count >= 7) then
                           s_rs232_state <= STOP;
                       else
                           s_bit_count <= s_bit_count + 1;
                       end if;
                    end if;

                when STOP =>
                    s_baud_tick <= s_baud_tick + 1;
                    if (s_baud_tick = 4 and rx /= '1') then
                        -- invalid STOP bit detected. return to IDLE and set rx_error
                        s_rx_error <= '1';
                    elsif (s_baud_tick = 7) then
                        s_irq <= '1';
                        s_rs232_state <= IDLE;
                    end if;
                        
                when others =>
                    s_rs232_state <= IDLE;
                    s_rx_error <= '1';
            end case;
        end if;
    end process;

    rx_data  <= s_rx_data when n_reset = '1' else (others=>'0');
    irq      <= s_irq when n_reset = '1' else '0';
    rx_error <= s_rx_error when n_reset = '1' else '0';

end behaviour;
