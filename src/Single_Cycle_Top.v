`include "PC.v"
`include "Instruction_Memory.v"
`include "Register_File.v"
`include "Sign_Extend.v"
`include "ALU.v"
`include "Control_Unit_Top.v"
`include "Data_Memory.v"
`include "PC_Adder.v"
`include "Mux.v"
`include "MUX4.v"

module Single_Cycle_Top(clk,rst);

    input clk,rst;

    wire [31:0] PC_Top,PC_Target,PC_Next,RD_Instr,RD1_Top,Imm_Ext_Top,ALUResult,ReadData,PCPlus4,RD2_Top,SrcB,Result;
    wire RegWrite,MemWrite,ALUSrc,PCSrc,Zero;
    wire [1:0]ImmSrc,ResultSrc;
    wire [2:0]ALUControl_Top;

    PC_Module PC(
                .clk(clk),
                .rst(rst),
                .PC(PC_Top),
                .PC_Next(PC_Next)
    );
    
    PC_Adder PC_Adder(
                    .a(PC_Top),
                    .b(32'd4),
                    .c(PCPlus4)
    );
    
    PC_Adder PC_immediate_Adder(
                    .a(PC_Top),
                    .b(Imm_Ext_Top),
                    .c(PC_Target)
                    );
    
    Mux PC_Source_Mux(
                    .in1(PCPlus4),
                    .in2(PC_Target),
                    .sel(PCSrc),
                    .out(PC_Next)
    
    );
    
    Instruction_Memory Instruction_Memory(
                            .rst(rst),
                            .A(PC_Top),
                            .RD(RD_Instr)
    );

    Register_File Register_File(
                            .clk(clk),
                            .rst(rst),
                            .WE3(RegWrite),
                            .WD3(Result),
                            .A1(RD_Instr[19:15]),
                            .A2(RD_Instr[24:20]),
                            .A3(RD_Instr[11:7]),
                            .RD1(RD1_Top),
                            .RD2(RD2_Top)
    );

    Mux ALU_input_Mux(
                            .in1(RD2_Top),
                            .in2(Imm_Ext_Top),
                            .sel(ALUSrc),
                            .out(SrcB)

    );

    Sign_Extend Immediate_Generator(
                        .In(RD_Instr),
                        .ImmSrc(ImmSrc),
                        .Imm_Ext(Imm_Ext_Top)
    );

    ALU ALU(
            .A(RD1_Top),
            .B(SrcB),
            .Result(ALUResult),
            .ALUControl(ALUControl_Top),
            .Zero(Zero)
    );

    Control_Unit_Top Control_Unit_Top(
                            .Op(RD_Instr[6:0]),
                            .funct7(RD_Instr[31:25]),
                            .funct3(RD_Instr[14:12]),
                            .Zero(Zero),
                            .RegWrite(RegWrite),
                            .ALUSrc(ALUSrc),
                            .MemWrite(MemWrite),
                            .ImmSrc(ImmSrc),
                            .ResultSrc(ResultSrc),
                            .ALUControl(ALUControl_Top),
                            .PCSrc(PCSrc)
    );

    Data_Memory Data_Memory(
                        .clk(clk),
                        .rst(rst),
                        .WE(MemWrite),
                        .WD(RD2_Top),
                        .A(ALUResult),
                        .RD(ReadData)
    );

    Mux4 Write_Back_Mux(
                        .in1(ALUResult),
                        .in2(ReadData),
                        .in3(PCPlus4),
                        .in4(32'd0),
                        .sel(ResultSrc),
                        .out(Result)

    );

    
endmodule
