`timescale 1ns/1ns

module b32regen(input [31:0] in, input clk, rst, enable, output reg [31:0] out);
  reg [31:0] a;
  always@(posedge clk, posedge rst) begin
    if(rst)
      out <= 31'b0;
  else begin
    if(enable)
          out <= in;

    end
    end
    
    
endmodule



