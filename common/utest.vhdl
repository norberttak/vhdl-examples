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
--use ieee.numeric_std.all;
use std.textio.all;
--use ieee.std_logic_textio.all;

package utest is

    file data_file_handler : text;

    procedure CREATE_TEST_REPORT ( title: in string ; filename: in string);
    procedure TEST               ( testcase: in string );
    procedure CLOSE_TEST_REPORT;
    procedure EXPECT_TRUE        ( test_title: string; value: boolean );
    procedure EXPECT_FALSE       ( test_title: string; value: boolean );
    procedure EXPECT_EQ          ( test_title: string; expected: std_logic_vector; observed: std_logic_vector );
    procedure EXPECT_EQ          ( test_title: string; expected: std_logic;        observed: std_logic );
    procedure EXPECT_EQ          ( test_title: string; expected: bit;              observed: bit );
    procedure EXPECT_NEQ         ( test_title: string; expected: std_logic_vector; observed: std_logic_vector );
    procedure EXPECT_NEQ         ( test_title: string; expected: std_logic       ; observed: std_logic );
    procedure EXPECT_EQ          ( test_title: string; expected: integer         ; observed: integer );
    procedure EXPECT_NEQ         ( test_title: string; expected: integer         ; observed: integer );

    constant  PASS_STR   : string := "<font color=""green""><strong>PASS</strong></font>";
    constant  FAIL_STR   : string := "<font color=""red""><strong>FAILED</strong></font>";    
end utest;

package body utest is

    procedure CREATE_TEST_REPORT (title: in string; filename: in string) is
        variable lineout: line;
    begin
        file_open(data_file_handler, filename, write_mode);
        write(lineout, string'("<html>"));
        write(lineout, string'("<title>"));
        write(lineout, title);
        write(lineout, string'("</title>"));
        write(lineout, string'("<body style=""margin: 2cm;""><center><h1>"));
        write(lineout, title);
        write(lineout, string'("</h1></center>"));

        writeline(data_file_handler,lineout);       
    end CREATE_TEST_REPORT;

    procedure CLOSE_TEST_REPORT is
        variable lineout: line;
    begin
        write(lineout, string'("</table><hr></p>Test report finish at "));
        write(lineout, now);
        write(lineout, string'("</body></html>"));
        writeline(data_file_handler,lineout);
        file_close(data_file_handler);
    end CLOSE_TEST_REPORT;

    procedure TEST(testcase: in string ) is
        variable lineout: line;
    begin        
        write(lineout, string'("</table><hr><p/><h3>"));
        write(lineout, testcase);
        write(lineout, string'("</h3><p/>"));
        write(lineout, string'("<table border=1 width=""85%"">"));
        write(lineout, string'("<tr><td width=""30%""><b>test</b></td><td width=""30%""><b>expected</b></td><td width=""30%""><b>observed</b></td><td width=""10%""><b>result</b></td></tr>"));
        writeline(data_file_handler,lineout);
    end TEST;
    
    procedure printTestResult(test_title: string; expected: in string; observed: in string; result: in string) is
       variable lineout: line;
    begin
        write(lineout, string'("<tr><td>"));
        write(lineout, test_title);
        write(lineout, string'("</td><td>"));
        write(lineout, expected);
        write(lineout, string'("</td><td>"));
        write(lineout, observed);
        write(lineout, string'("</td><td>"));
        write(lineout, result);
        write(lineout, string'("</td></tr>"));
        writeline(data_file_handler,lineout);
    end;


    function to_string ( a: std_logic_vector) return string is
        variable b : string (1 to a'length) := (others => NUL);
        variable stri : integer := 1; 
    begin
        for i in a'range loop
            b(stri) := std_logic'image(a((i)))(2);
            stri := stri+1;
        end loop;
        return b;
    end function;

    function to_string (a : std_logic) return string is
        variable b : string (1 to 1);        
    begin
        case a is
            when '0' => b := "0";
            when '1' => b := "1";
            when 'Z' => b := "Z";
            when 'H' => b := "H";
            when 'L' => b := "L";
            when others => b := "X";
        end case;
        return b;
    end function;

    function to_string (arg : integer) return string is
        variable L : line;
        variable result : string(1 to 32);
    begin
        write(L, arg);
        read(L, result);
        return result;
    end function;

    function to_string (arg : bit) return string is
        variable result : string(1 to 1);
    begin
        case arg is
            when '0' => result:="0";
            when '1' => result:="1";
            when others => result:="X";
        end case;
        return result;
    end function;

    procedure EXPECT_TRUE (test_title: string; value: boolean) is 
    begin
        if (value = TRUE) then
            printTestResult(test_title,"TRUE","TRUE",PASS_STR);
        else
            printTestResult(test_title,"TRUE","FALSE",FAIL_STR);
        end if;
    end EXPECT_TRUE;

    procedure EXPECT_FALSE (test_title: string; value: boolean) is 
    begin
        if (value = FALSE) then
            printTestResult(test_title,"FALSE","FALSE",PASS_STR);
        else
            printTestResult(test_title,"FALSE","TRUE",FAIL_STR);
        end if;
    end EXPECT_FALSE;

    procedure EXPECT_EQ (test_title: string; expected: std_logic_vector; observed: std_logic_vector) is 
    begin
        if (expected = observed) then
            printTestResult(test_title, to_string(expected),to_string(observed),PASS_STR);
        else
            printTestResult(test_title, to_string(expected),to_string(observed),FAIL_STR);
        end if;
    end EXPECT_EQ;

    procedure EXPECT_EQ (test_title: string; expected: std_logic; observed: std_logic) is 
    begin
        if (expected = observed) then
            printTestResult(test_title, to_string(expected),to_string(observed),PASS_STR);
        else
            printTestResult(test_title, to_string(expected),to_string(observed),FAIL_STR);
        end if;
    end EXPECT_EQ;

    procedure EXPECT_EQ (test_title: string; expected: integer; observed: integer) is 
    begin
        if (expected = observed) then
            printTestResult(test_title, to_string(expected),to_string(observed),PASS_STR);
        else
            printTestResult(test_title, to_string(expected),to_string(observed),FAIL_STR);
        end if;
    end EXPECT_EQ;

    procedure EXPECT_EQ (test_title: string; expected: bit; observed: bit) is 
    begin
        if (expected = observed) then
            printTestResult(test_title, to_string(expected),to_string(observed),PASS_STR);
        else
            printTestResult(test_title, to_string(expected),to_string(observed),FAIL_STR);
        end if;
    end EXPECT_EQ;


    procedure EXPECT_NEQ (test_title: string; expected: std_logic_vector; observed: std_logic_vector) is 
    begin
        if (expected /= observed) then
            printTestResult(test_title, to_string(expected),to_string(observed),PASS_STR);
        else
            printTestResult(test_title, to_string(expected),to_string(observed),FAIL_STR);
        end if;
    end EXPECT_NEQ;

    procedure EXPECT_NEQ (test_title: string; expected: std_logic; observed: std_logic) is 
    begin
        if (expected /= observed) then
            printTestResult(test_title, to_string(expected),to_string(observed),PASS_STR);
        else
            printTestResult(test_title, to_string(expected),to_string(observed),FAIL_STR);
        end if;
    end EXPECT_NEQ;
   
    procedure EXPECT_NEQ (test_title: string; expected: integer; observed: integer) is 
    begin
        if (expected /= observed) then
            printTestResult(test_title, to_string(expected),to_string(observed),PASS_STR);
        else
            printTestResult(test_title, to_string(expected),to_string(observed),FAIL_STR);
        end if;
    end EXPECT_NEQ;

    procedure EXPECT_NEQ (test_title: string; expected: bit; observed: bit) is 
    begin
        if (expected /= observed) then
            printTestResult(test_title, to_string(expected),to_string(observed),PASS_STR);
        else
            printTestResult(test_title, to_string(expected),to_string(observed),FAIL_STR);
        end if;
    end EXPECT_NEQ;
end;
