module adder_16 (
    input [15:0] A, B,
    input cin,
    output [15:0] S,
    output cout
);
	// The design is 4x4 hierarchical, so it is split into 4 parts
	// CLU One -> P0-3 and G0-3 are portions of the P and G signals

	logic P0, P1, P2, P3;
	logic G0, G1, G2, G3;
	logic C0, C4, C8, C12;

	//
	assign Pg = P0 & P1 & P2 & P3;
	assign Gg = G3 | (G2 & P3)|(G1 & P3 & P2)|(G0 & P3 & P2 & P1);

	// Carry bits for CLAs
	assign C0 = (cin);
	assign C4 = (cin & (P0)) | (G0);
	assign C8 = (cin & (P0) & (P1)) | ((G0) & (P1) | (G1));
	assign C12 = (cin & (P0) & (P1) & (P2)) | ((G0) & (P1) & (P2)) | ((G1) & (P2)) | (G2);
	assign cout = (cin & (P0) & (P1) & (P2) & (P3)) | ((G0) & (P1) & (P2) & (P3)) | ((G1) & (P2) & (P3)) | (G2 & (P3)) | (G3);

	// Carry outs aren't needed
	// These 4 CLAs make up the 4x4 lookahead adder
	CLA CLU1 (.A(A[3:0]),.B(B[3:0]),.cin(C0),.S(S[3:0]),.cout(), .P(P0), .G(G0));
	CLA CLU2 (.A(A[7:4]),.B(B[7:4]),.cin(C4),.S(S[7:4]),.cout(), .P(P1), .G(G1));
	CLA CLU3 (.A(A[11:8]),.B(B[11:8]),.cin(C8),.S(S[11:8]),.cout(), .P(P2), .G(G2));
	CLA CLU4 (.A(A[15:13]),.B(B[15:13]),.cin(C12),.S(S[15:13]),.cout(), .P(P3), .G(G3));

endmodule