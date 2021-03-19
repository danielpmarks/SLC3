module ALU(input [1:0] ALUK,
            input [15:0] A,B,
            output logic [15:0] out);

logic [15:0] S;

always_comb begin : ALU_MUX
    unique case(ALUK)
        2'b00:  //Case ADD
            out = S;
        2'b01:  //Case AND
            out = A & B;
        2'b10:  //Case NOT
            out = ~A;
        2'b11:  //Case PassA
            out = A;
    endcase
end

adder_16 adder(.A(A),.B(B), .cin(1'b0), .S(S), .cout());


endmodule