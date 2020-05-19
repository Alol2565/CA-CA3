`timescale 1ns/1ns
module controller1(
          input [5:0] opcode,
          input zero, clk, reset,
          output reg alusrcA, 
                 memread, memwrite ,regwrite,
                 pc_write, pc_write_condition,
                 IorD,
                 IR_write,  
          output reg[1:0] alusrcB, toaluctrl, pcsrc,regdst,memtoreg );
          
          
  reg[5:0] PS, NS;

   always @(posedge clk)
    begin
      if(reset)
        PS <= 6'b000000;
      else 
        PS <= NS;
    end
    
    always@(posedge clk ,posedge reset) begin
                {regdst,
                 alusrcA, alusrcB,
                 memread, memwrite ,regwrite,memtoreg,
                 pcsrc, pc_write, pc_write_condition,
                 IorD,
                 IR_write} = 16'b0;
