`timescale 1ns/1ns
module datapath( input clk ,rst,
                      ALUSrcA,
                      memread, memwrite ,regwrite,
                      IorD ,IRWrite , PCWrite ,PCWriteCondbeq, PCWriteCondbne,
              input [1:0] PCSrc, ALUSrcB, ALUOp, 
                    regdst, memtoreg,           
              output [5:0] opcode );
  
  logic [4:0] n31 = 5'd31;
  logic [31:0] n4 = 32'd4;
  logic [31:0] pcin ,pcout, jmppc, 
               memaddr, memout,
               inst, MDRout,
               wregd,
               Ain, Bin , Aout, Bout,
               seout,seoutshift,
               ALUa ,ALUb, 
               ALUResult, ALUOut;
  logic [2:0] aluopration;
  logic [4:0] wregin;
  logic zero , PCen;
  
    assign PCen = PCWrite | (zero & PCWriteCondbeq) | (~zero & PCWriteCondbne);
    assign pcin = (PCSrc == 2'b10 ) ? ALUOut : (PCSrc == 2'b01) ? jmppc : ALUResult ;
    //assign pcin = ALUResult;
    assign jmppc = {pcout[31:28],inst[25:0],2'b00};
    assign memaddr = IorD ? ALUOut : pcout;
    assign wregin = (regdst == 2'b10) ? n31 : (regdst == 2'b01) ? inst[15:11] : inst[20:16];
    assign wregd = (memtoreg == 2'b10) ? pcout : (memtoreg == 2'b01) ? MDRout : ALUOut;
    assign ALUa = ALUSrcA ? Aout : pcout;
    assign ALUb = (ALUSrcB == 2'b11) ? seoutshift : (ALUSrcB == 2'b10) ? seout : (ALUSrcB == 2'b01) ? n4 : Bout;
    //assign ALUb = n4;
    assign seoutshift = seout << 2;
    
    b32regen PC(pcin , clk, rst , PCen, pcout);
    datamem Memory(memaddr, Bout, clk, memread, memwrite, memout);
    b32regen IR(memout, clk, rst, IRWrite, inst);
    b32reg MDR(memout ,clk, rst, MDRout);
    RegisterFile RF(clk,rst,regwrite, inst[25:21],inst[20:16],wregin, wregd, Ain,Bin);
    b32reg A(Ain,clk, rst, Aout);
    b32reg B(Bin,clk, rst, Bout);
    alu ALU(ALUa ,ALUb ,aluopration, ALUResult ,zero);
    se16to32 SE(inst[15:0], seout);
    b32reg ALUout(ALUResult,clk, rst, ALUOut);
    aluctrl ALUCU(inst[5:0],ALUOp, aluopration);
  
  assign opcode = inst[31:26];
  

endmodule

