// File: test_mux_on_board.v
//
// John F. Hubbard, 26 Mar 2015
//
// MODULE: test_mux_on_board
//
//     This module tests different MUX modules, using the BASYS3 board as the
//     test bench, as recommended in Jag's (instructor's) course outline for
//     UCSC 30207: Digital Design with FPGA.
//
// MODULE: mux_tb
//
//     This module tests different MUX modules, using Modelsim simulation.
//

module mux_tb();
    parameter MAX_VEC = 32;
    integer vec;
    reg a, b, c, d, e;
    reg [3-1:0] s;
    reg [4-1:0] sLoop;
    wire f1, f2;

    five_to_one_mux_using_case DUT1(a, b, c, d, e, s, f1);
    five_to_one_mux_using_if   DUT2(a, b, c, d, e, s, f2);

    initial begin

        for (sLoop = 0; sLoop < 8; sLoop = sLoop + 1) begin
            s = sLoop[3:0];
            #1;

            $display("----- select (s): %b -----------", sLoop);

            for (vec = 0; vec < MAX_VEC; vec = vec + 1) begin
                {e,d,c,b,a} = vec;

                #1;
                if (f1 != f2) begin
                    $display("ERROR: f1 != f2 *******************************");
                    $display("ERROR case: ",
                             "{e,d,c,b,a}: %b, s: %b, f1: %b, f2: %b",
                             vec[5-1:0], s, f1, f2);
                end
//              else
//                  $display("{e,d,c,b,a}: %b, s: %b, f1: %b, f2: %b",
//                           vec[5-1:0], s, f1, f2);
            end
        end
    end

endmodule

module test_mux_on_board(clk, btnU, sw, seg, an, led);
    parameter NINPUTS = 256;
    parameter MAXERROR = 9;

    input clk, btnU;
    input [15:0]sw;
    output [0:6] seg;
    output [3:0] an;
    output[15:0] led;

    wire done;
    reg [NINPUTS-1:0] inputs, i;
    wire o1, o2, o3;
    wire [15:0] packedHex;
    reg [3:0] error;

    always @(posedge clk or posedge btnU) begin
        if (btnU) begin
            inputs = 0;
            i = 0;
        end
        else if (done) begin
            i = i + 1;
            if (i % 10 == 0)
                inputs = ~(0);
            else
                inputs = i;
        end
    end

    always @(posedge clk)
    if (btnU)
        error = 0;
    else if (done)
        if (error < MAXERROR)
            if ( (o1 != o2) || (o1 != o3) || (o2 != o3) )
                error = error + 1;

    //o1(4), o2(4), o3(4), first(4)
    //0 or 1 0 or 1 <3 to 0> <2 to 0>
    assign text = btnU ? 0 : ((inputs % 10) == 0) ? ~(0) :
                    {{3'b0, o1}, {3'b0,o2},{3'b0,o3}, error};
    //a,b,c,d,e
    //0 1 2 3 4
    five_to_one_mux_using_case DUT1(a, b, c, d, e, s, o1);
    five_to_one_mux_using_if   DUT2(a, b, c, d, e, s, o2);

    display_packed_hex_for_n_seconds #(0.5) D(clk, btnU, seg, an,
                                              packedHex, done);
    assign led = inputs;

    // Provide error injection: if sw0 is on, then tie o3 to 1'b1. That will
    // generate errors. Otherwise, o2 tracks o2, avoiding any errors:
    assign o3 = (sw[0] ? 1'b1 : o2);
endmodule

