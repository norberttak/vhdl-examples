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

entity full_add is
    port(
        a     : in std_logic;
        b     : in std_logic;
        cIn   : in std_logic;
        sum   : out std_logic;
        cOut  : out std_logic;

        clk   : in std_logic;
        n_reset : in std_logic
    );
end full_add;

-- full add :
-- a    b    cIn  cOut  sum
-- 0    0    0    0     0
-- 0    0    1    0     1
-- 0    1    0    0     1
-- 0    1    1    1     0
-- 1    0    0    0     1
-- 1    0    1    1     0
-- 1    1    0    1     0
-- 1    1    1    1     1

--full add 1st version (asyncron):
--architecture behaviour of full_add is
--begin
--    sum <= (a xor b) xor cIn;
--    cOut <= (a and b) or (b and cIn) or (cIn and a);
--end behaviour;


--full add 2nd version(syncron):
architecture behaviour of full_add is
    signal s_sum : std_logic;
    signal s_cOut : std_logic;
begin
    process(clk, n_reset)
    begin
        if (n_reset = '0') then
            s_sum <= '0';
            s_cout <= '0';
        elsif (clk'event and clk='1') then 
            s_sum <= (a xor b) xor cIn;
            s_cOut <= (a and b) or (b and cIn) or (cIn and a);
        end if;
    end process;

    sum <= s_sum when n_reset = '1' else '0';
    cOut <= s_cOut when n_reset = '1' else '0';
end behaviour;
