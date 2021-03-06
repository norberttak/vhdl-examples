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

entity baud_generator is
    port(
        clk     : in std_logic;
        baudx8  : out std_logic; -- 8x baud frequency
        n_reset : in std_logic
    );
end baud_generator;

architecture behaviour of baud_generator is 
    signal   s_baudx8       : std_logic;
    constant CLK_MAX_COUNT  : integer := 208; -- calculate the counter limit: 1000*CLOCK_FREQ / 2*8*BAUD_RATE
begin

    -- Your implementation shall be here

end behaviour;
