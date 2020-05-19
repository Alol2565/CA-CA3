`timescale 1ns/1ns
module cpu( input clk ,rst);
                      
                      
        wire  alusrcA,
              memread, memwrite ,regwrite,
              pc_write, pc_write_condition_beq, pc_write_condition_bne,
              IorD,IR_write,
              zero;
              
        wire [1:0] toaluctrl,alusrcB,pcsrc,
                    regdst,memtoreg;        
        wire [2:0] aluopration;       
        wire [5:0] opcode ,opr;  
              
  

controller CU(opcode, zero, clk, rst, alusrcA, memread, memwrite ,regwrite, pc_write, pc_write_condition_beq, pc_write_condition_bne, IorD, IR_write, alusrcB,toaluctrl, pcsrc, regdst,memtoreg );
datapath DP(clk ,rst, alusrcA, memread, memwrite ,regwrite,IorD, IR_write, pc_write, pc_write_condition_beq, pc_write_condition_bne, pcsrc, alusrcB, toaluctrl, regdst,memtoreg, opcode);          



endmodule