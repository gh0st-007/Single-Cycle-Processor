`include "ALU_Decoder.v"
`include "Main_Decoder.v"

module Control_Unit_Top(
        input [6:0] Op, funct7,
        input [2:0] funct3,
        input Zero,
        output RegWrite, ALUSrc, MemWrite,PCSrc, 
        output [1:0]ImmSrc,ResultSrc,
        output [2:0]ALUControl
    );
    wire [2:0]ALUOp;

    Main_Decoder Main_Decoder(
                .Op(Op),
                .funct3(funct3),
                .Zero(Zero),
                .RegWrite(RegWrite),
                .ImmSrc(ImmSrc),
                .ALUSrc(ALUSrc),
                .ALUOp(ALUOp),
                .MemWrite(MemWrite),
                .ResultSrc(ResultSrc),
                .PCSrc(PCSrc)
                
    );

    ALU_Decoder ALU_Decoder(
                            .ALUOp(ALUOp),
                            .funct3(funct3),
                            .funct7(funct7),
                            .ALUControl(ALUControl)
    );


endmodule
