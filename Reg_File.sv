module Reg_File(input Clk,
                input logic [15:0] D, 
                input  logic[2:0] DR, SR1, SR2,
                input LD_REG,
                output logic [15:0] SR1_OUT, SR2_OUT);


logic [2:0] LD_EXD;
logic [15:0] OUT_0, OUT_1, OUT_2, OUT_3, OUT_4,OUT_5, OUT_6,OUT_7;

//Extend LD_REG to 3 bits
assign LD_EXD = {LD_REG, LD_REG, LD_REG};

always_comb begin : SR_OUT
    SR1_OUT = OUT_0;
    SR2_OUT = OUT_0;
    unique case(SR1)
        1'b000:
            SR1_OUT = OUT_0;
        1'b001:
            SR1_OUT = OUT_1;
        1'b010:
            SR1_OUT = OUT_2;
        1'b011:
            SR1_OUT = OUT_3;
        1'b100:
            SR1_OUT = OUT_4;
        1'b101:
            SR1_OUT = OUT_5;
        1'b110:
            SR1_OUT = OUT_6;
        1'b111:
            SR1_OUT = OUT_7;
    endcase

    unique case(SR2)
        1'b000:
            SR2_OUT = OUT_0;
        1'b001:
            SR2_OUT = OUT_1;
        1'b010:
            SR2_OUT = OUT_2;
        1'b011:
            SR2_OUT = OUT_3;
        1'b100:
            SR2_OUT = OUT_4;
        1'b101:
            SR2_OUT = OUT_5;
        1'b110:
            SR2_OUT = OUT_6;
        1'b111:
            SR2_OUT = OUT_7;
    endcase
end

reg_16 R0(.Clk(Clk), .Reset(1'b0), .Load(LD_REG & (DR == 3'b000)), .D(D), .Data_Out(OUT_0));
reg_16 R1(.Clk(Clk), .Reset(1'b0), .Load(LD_REG & (DR == 3'b001)), .D(D), .Data_Out(OUT_1));
reg_16 R2(.Clk(Clk), .Reset(1'b0), .Load(LD_REG & (DR == 3'b010)), .D(D), .Data_Out(OUT_2));
reg_16 R3(.Clk(Clk), .Reset(1'b0), .Load(LD_REG & (DR == 3'b011)), .D(D), .Data_Out(OUT_3));
reg_16 R4(.Clk(Clk), .Reset(1'b0), .Load(LD_REG & (DR == 3'b100)), .D(D), .Data_Out(OUT_4));
reg_16 R5(.Clk(Clk), .Reset(1'b0), .Load(LD_REG & (DR == 3'b101)), .D(D), .Data_Out(OUT_5));
reg_16 R6(.Clk(Clk), .Reset(1'b0), .Load(LD_REG & (DR == 3'b110)), .D(D), .Data_Out(OUT_6));
reg_16 R7(.Clk(Clk), .Reset(1'b0), .Load(LD_REG & (DR == 3'b111)), .D(D), .Data_Out(OUT_7));

endmodule