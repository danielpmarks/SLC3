module CLA (
    input [3:0] A, B,
    input cin,
    output [3:0] S,
    output cout, P, G
);
	// The design is 4x4 hierarchical, so it is split into 4 parts
	// CLU One -> P0-3 and G0-3 are portions of the P and G signals
	logic P0, P1, P2, P3;
	logic G0, G1, G2, G3;
	logic c0, c1, c2, c3;

	// Assigning the propogate and generate bits
	assign P0 = A[0] ^ B[0];
	assign P1 = A[1] ^ B[1];
	assign P2 = A[2] ^ B[2];
	assign P3 = A[3] ^ B[3];

	assign G0 = A[0] & B[0];
	assign G1 = A[1] & B[1];    
	assign G2 = A[2] & B[2];
	assign G3 = A[3] & B[3];

	// Assigning group propogate and generate bits
	assign P = P0 & P1 & P2 & P3;
	assign G = G3 | (G2 & P3)|(G1 & P3 & P2)|(G0 & P3 & P2 & P1);

	// Assigning carry bits for the lookahead adders
	assign c0 = (cin);
	assign c1 = (cin & (P0)) | (G0);
	assign c2 = (cin & (P0) & (P1)) | ((G0) & (P1) | (G1));
	assign c3 = (cin & (P0) & (P1) & (P2)) | ((G0) & (P1) & (P2)) | ((G1) & (P2)) | (G2);

	// Carry outs aren't needed
	// These 4 adders make up the CLA
	full_addr CLA1 (.a(A[0]),.b(B[0]),.cin(c0),.s(S[0]),.cout());
	full_addr CLA2 (.a(A[1]),.b(B[1]),.cin(c1),.s(S[1]),.cout());
	full_addr CLA3 (.a(A[2]),.b(B[2]),.cin(c2),.s(S[2]),.cout());
	full_addr CLA4 (.a(A[3]),.b(B[3]),.cin(c3),.s(S[3]),.cout());

endmodule