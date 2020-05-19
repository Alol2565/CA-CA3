`timescale 1ns/1ns
module controller1(
          input [5:0] opcode,
          input zero, clk, reset,
          output reg alusrcA, 
                 memread, memwrite ,regwrite,
                 pc_write, pc_write_condition_beq, pc_write_condition_bne,
                 IorD,
                 IR_write,  
          output reg[1:0] alusrcB, toaluctrl, pcsrc,regdst,memtoreg );
          
          
  reg[5:0] PS, NS;

   always @(posedge clk , posedge reset)
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
                  NS = 6'b000000;
                  
          6'b000000:begin //IF
            memread = 1;
            alusrcA = 0;
            IorD = 0;
            IR_write = 1; 
            alusrcB = 2'b01; 
            toaluctrl = 2'b00; 
            pc_write = 1'b1; 
            pcsrc = 2'b00;
            NS = 6'b000001;
          end      
          6'b000001:begin //ID
          alusrcA = 1'b0; alusrcB = 2'b11; toaluctrl = 2'b00;
              	
          
  
          end 