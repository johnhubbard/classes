`timescale 1ns/1ns

module counter #(parameter WIDTH=4)
              (//Inputs
               clk,
               reset,
               enable,
               preload,
               preload_data,
               mode,

               //Outputs
               detect,
               result);

input               clk;
input               reset;
input               enable;
input               preload;
input  [WIDTH-1:0]  preload_data;
input               mode;
output              detect;
output [WIDTH-1:0]  result;

wire                clk;
wire                reset;
wire                enable;
wire                preload;
wire   [WIDTH-1:0]  preload_data;
wire                mode;
reg                 detect;
reg    [WIDTH-1:0]  result;

always @ (posedge clk or posedge reset)
begin
   if (reset)
      result <= {WIDTH{1'b0}};
   else
      if (enable)
         if (preload)
            result <= preload_data;
         else
            if (!mode)
               if (result == {WIDTH{1'b1}}) begin
                   result <= {WIDTH{1'b0}};
                   detect <= 1'b0;
               end
               else begin
                   result <= result + 1;
                   detect <= (result ==  {WIDTH{1'b1}} - 1);
               end
            else
               if (result == {WIDTH{1'b0}})
                   result <= {WIDTH{1'b1}};
               else
                   result <= result - 1;

end
endmodule
