module Main_Decoder(
    input [6:0]Op,
    input Zero,
    input [2:0] funct3,
    output RegWrite,ALUSrc,MemWrite,PCSrc,
    output [1:0]ImmSrc,ResultSrc,
    output [2:0] ALUOp
    );
    
    wire Branch;
    
    localparam [6:0] R_Type=7'b0110011,
                     I_Type=7'b0010011,
                     I_load_Type=7'b0000011,
                     S_Type=7'b0100011,
                     B_Type=7'b1100011,
                     J_Type=7'b1101111;
                     
    
    assign RegWrite = (Op == R_Type | Op == I_Type | Op == I_load_Type | Op ==J_Type) ? 1'b1 :
                                                              1'b0 ;
    //The ImmSrc signal decides the kind of immediate that is generated
    //based on the type of the instruction
    assign ImmSrc = (Op == S_Type) ? 2'b01 : 
                    (Op == B_Type) ? 2'b10 :
                    (Op == J_Type) ? 2'b11 :    
                     2'b00 ; // for I-type , because for R-type, we wont be using the immediate value
                                         
    //The ALUSrc signal decides whether the immediate value is used or not.
    assign ALUSrc = (Op == I_load_Type | Op==I_Type | Op == S_Type) ? 1'b1 :
                                                            1'b0 ;
    assign MemWrite = (Op == S_Type) ? 1'b1 :
                                       1'b0 ;
    assign ResultSrc = (Op == I_load_Type) ? 2'b01 :
                       (Op == J_Type) ? 2'b10:2'b00 ;
    assign Branch = (Op == B_Type) ? 1'b1 :
                                     1'b0 ;
                                         
    assign PCSrc = (Op == J_Type) |(Branch & ((funct3 == 3'b000 & Zero) || (funct3 == 3'b001 & ~Zero))) ; //this is used to select the PC input based on 
    //if the instruction is branch if equal. (meaning if a=b, then branch if instruction is )
                                         
    assign ALUOp = (Op == R_Type ) ? 3'b000 :
                   (Op == I_Type ) ? 3'b001 :
                   (Op == B_Type ) ? 3'b010 : // subtraction coz both branching instructions involve subtraction
                   (Op == S_Type |  Op == I_load_Type) ? 3'b011 : // addition
                                   3'b100;
                                    
endmodule
