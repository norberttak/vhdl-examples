--------------------------------------------------------------------
--  Altera PCI testbench
--  MODULE NAME: clk_gen
--  COMPANY:  Altera Coporation.
--            www.altera.com    

-- FUNCTIONAL DESCRIPTION:
-- This file generates clock for the system
-- Change the pciclk_66Mhz_enable to true in the top level file
-- to generate 66Mhz clock for the system.

--  REVISION HISTORY:  
--  Revision 1.1 Description: No change.
--  Revision 1.0 Description: Initial Release.
--
--  Copyright (C) 1991-2004 Altera Corporation, All rights reserved.  
--  Altera products are protected under numerous U.S. and foreign patents, 
--  maskwork rights, copyrights and other intellectual property laws. 
--  This reference design file, and your use thereof, is subject to and 
--  governed by the terms and conditions of the applicable Altera Reference 
--  Design License Agreement (either as signed by you or found at www.altera.com).  
--  By using this reference design file, you indicate your acceptance of such terms 
--  and conditions between you and Altera Corporation.  In the event that you do
--  not agree with such terms and conditions, you may not use the reference design 
--  file and please promptly destroy any copies you have made. 
--  This reference design file is being provided on an "as-is" basis and as an 
--  accommodation and therefore all warranties, representations or guarantees 
--  of any kind (whether express, implied or statutory) including, without limitation, 
--  warranties of merchantability, non-infringement, or fitness for a particular purpose, 
--  are specifically disclaimed.  By making this reference design file available, 
--  Altera expressly does not recommend, suggest or require that this reference design 
--  file be used in combination with any other product not provided by Altera.
-----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity clock_gen is
    port(clock : out std_logic);
end clock_gen;

architecture behaviour of clock_gen is
    signal clk : std_logic;
begin
    clk_process: process
    begin
        clk <= '1';
        wait for 15.625 ns; -- 32 MHz clock
        clk <= '0';
        wait for 15.625 ns;
    end process clk_process;

    clock <= clk;

end behaviour;
