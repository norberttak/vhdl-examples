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

entity multiplexer is
    port(
        data     : in std_logic_vector(7 downto 0);
        addr     : in std_logic_vector(2 downto 0);
        q        : out std_logic
    );
end multiplexer;

architecture behaviour of multiplexer is
begin
    q <= data(0) when addr = "000" else
         data(1) when addr = "001" else
         data(2) when addr = "010" else
         data(3) when addr = "011" else
         data(4) when addr = "100" else
         data(5) when addr = "101" else
         data(6) when addr = "110" else
         data(7) when addr = "111";
end behaviour;
