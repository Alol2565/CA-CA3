`timescale 1ns/1ns
module controller(
          input [5:0] opcode,
          input zero, clk, reset,
          output reg alusrcA, 
                 memread, memwrite ,regwrite,
                 pc_write, pc_write_condition_beq, pc_write_condition_bne,
                 IorD,
                 IR_write,  
          output reg[1:0] alusrcB, toaluctrl, pcsrc,regdst,memtoreg );
    
    reg[5:0] PS, NS;
    always@(posedge clk ,posedge reset) begin
                 {regdst,
                 alusrcA, alusrcB,
                 memread, memwrite ,regwrite,memtoreg,
                 pcsrc, pc_write, pc_write_condition_beq, pc_write_condition_bne,
                 IorD,
                 IR_write} = 17'b0;
      NS = 6'b00000;
  
      case(PS)
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
          NS = 6'b000010;
          end  
        6'b000010:begin 
          case(opcode)
            6'b000010:begin //j
                pc_write = 1'b1;
                pcsrc = 2'b01;
                NS = 6'b000000;
            end 
            6'b000100:begin //beq
                     alusrcA = 1'b1;
                     pcsrc = 2'b01;  ///??????????
                     pc_write_condition_beq = 1'b1;
                     toaluctrl = 2'b01;
                     alusrcB = 2'b00;
                     NS = 6'b000000;
            end
            6'b000101:begin //bne
                     alusrcA = 1'b1;
                     alusrcB = 2'b00;
                     pc_write_condition_bne = 1'b1;
                     pcsrc = 2'b01; /////////
		                 toaluctrl = 2'b01; 
		                 NS = 6'b000000;
            end
            6'b000001:begin //jr
                     pcsrc = 2'b10;// ?????????????????????//
                     pc_write = 1'b1;
                     NS = 6'b0;
            end
            6'b000011:begin //jal
                     pcsrc = 2'b01;
                     pc_write = 1'b1;
                     regwrite = 1'b1;
                     regdst = 2'b10; //s1
                     memtoreg = 2'b10; // s2
                     NS = 6'b0;
            end
            6'b000000:begin //rtype
                     alusrcB = 2'b0;
                     alusrcA = 1'b1;
                     toaluctrl = 2'b10;
                     NS = 6'b000011;
            end
            6'b001000:begin //addi    
                    alusrcA = 1'b1;
                    alusrcB = 2'b01;
                    toaluctrl = 2'b00;
                    NS = 6'b000011;
            end  
            6'b001100:begin //andi
                    alusrcA = 1'b1;
                    alusrcB = 2'b01;
                    toaluctrl = 2'b11;
                    NS = 6'b000011;
            end
            6'b100011:begin //lw
                    alusrcA = 1'b1;
                    alusrcB = 2'b10;
                    toaluctrl = 2'b00; 
                    NS = 6'b000011;
            end
            6'b101011:begin //sw
                    alusrcA = 1'b1;
                    alusrcB = 2'b10;
                    toaluctrl = 2'b00;
                    NS = 6'b000011;
            end
        endcase
          end
       6'b000011: begin 
              case(opcode)

              6'b000000:begin //rtypeb
                     regdst = 2'b01; 
                     regwrite = 1'b1;
                     memtoreg = 2'b00; 
                     NS = 6'b0;
              end

              6'b001000:begin //addi    
                    regdst = 2'b01;
                    regwrite = 1'b1;
                    memtoreg = 2'b00; 
                    NS = 6'b0;
              end 
              6'b001100:begin //andi
                    regdst = 2'b01;
                    regwrite = 1'b1;
                    memtoreg = 2'b00; 
                    NS = 6'b0;

              end
              6'b100011:begin //lw
                    memread = 1'b1;
                    IorD = 1'b1;
                    NS = 6'b000100;
            end
              6'b101011:begin //sw
                    memwrite = 1'b1;
                    IorD = 1'b1;
                    NS = 6'b0; 

            end
              endcase
       end
       6'b000100: begin 
         case(opcode)
         6'b100011:begin //lw
              regdst = 2'b00;
              regwrite = 1'b1;
              memtoreg = 2'b01;
              NS = 6'b0;
            end
         endcase
       end
      endcase
    end
    
     
    always @(posedge clk)
    begin
      if(reset == 1'b1)
        PS <= 6'b0;
      else 
        PS <= NS;
    end
    
endmodule
