// File: bin2bcd_tb.v
// John Hubbard, 24 Oct 2014
// hw5 assignment for Verilog 0764 class: Problem 4.4.7: Binary to BCD converter
//
// Steps to run in ModelSim (on Linux this time):
// cd $HOME/git_wa/classes/ucsc/verilog_0764/hw5/f_bin2bcd/modelsim
// vlib work
// vlog -sv ../bin2bcd.v ../bin2bcd_tb.v
// vsim work.bin2bcd_tb
// run 400 ns
//

`timescale 1ns/1ns
module bin2bcd_tb;
    reg [3:0]bin_tb;
    wire [3:0]bcdHundreds_tb;
    wire [3:0]bcdTens_tb;
    wire [3:0]bcdOnes_tb;
    integer count;

    bin2bcd DUT(bin_tb, bcdHundreds_tb, bcdTens_tb, bcdOnes_tb);

    // This block prints whenever the inputs or outputs change:
    initial
    begin
        $monitor("Time %t: bin: %b%b%b%b bcd: %h %h %h ",
                 $time, bin_tb[3], bin_tb[2], bin_tb[1], bin_tb[0],
                 bcdHundreds_tb, bcdTens_tb, bcdOnes_tb);
    end

    // Test pattern: exhaustive inputs:
    initial
    begin
        for (count = 0; count < 16; count++)
        begin
            {bin_tb} = count[3:0];
            #10;
        end
    end
endmodule

/* Sample test run:

*/
