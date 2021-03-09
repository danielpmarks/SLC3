module full_addr
(
	input  a,b,cin,
	output s, cout
);

	always_comb
	begin
		s = a^b^cin;
		cout = (a&b)|(a&cin)|(b&cin);
	 end
     
endmodule
