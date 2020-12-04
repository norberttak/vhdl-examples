--------------------------------------------------------------------
--  Altera PCI testbench
--  Package NAME: log
--  COMPANY:  Altera Coporation.
--            www.altera.com    

--  FUNCTIONAL DESCRIPTION:
--  This file logs the transaction to the screen and to a txt file called log.txt

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
use std.textio.all;
use work.std_logic_textio.all;


package log is

file data_file_handler : text open write_mode is "log.txt";

procedure print(s: in string);
procedure print_sig_val(address: std_logic_vector;data: std_logic_vector);
procedure print_sig_val(arg: string);

end log;

package body  log  is
------------------------------------------------------------------------------------

procedure test_is_equal(test_case_title: string; value1: std_logic_vector; value2: std_logic_vector) is
begin
    
end test_is_equal;

--*******************************************
procedure print(s: in string) is
    variable l: line;
    variable lineout: line;
--******************************************    
  begin
    write(lineout, s);
    writeline(data_file_handler,lineout);
    
    write(l, s);
    writeline(output,l);
  end print;

--********************************************************************
procedure print_sig_val(address: std_logic_vector;data: std_logic_vector)  is
  variable tranx : line;
  variable l : line;
--********************************************************************  
begin
   
   --print to output file
   write(l,now, justified=>right,field =>10, unit=> ns );
   write(l,string'("  "));
   hwrite(l,address,justified=>left);
   write(l,string'("     "));
   hwrite(l,data);
   writeline(data_file_handler,l);

   write(tranx, now, justified=>right,field =>10, unit=> ns );
   write(tranx, string'("   "));
   hwrite(tranx,address,justified=>left);
   write(tranx, string'("     "));
   hwrite(tranx,data);
   writeline(output,tranx);
end print_sig_val;     

--********************************************************************
procedure print_sig_val(arg: string)  is
  variable tranx : line;
  variable l : line;
--********************************************************************  
begin
   
   --print to output file
   write(l, now, justified=>right,field =>10, unit=> ns );
   write(l, string'("   "));
   write(l,arg);
   writeline(data_file_handler,l);

   write(tranx, now, justified=>right,field =>10, unit=> ns );
   write(tranx, string'("   "));
   write(tranx,arg);
   writeline(output,tranx);
end print_sig_val;


end;
