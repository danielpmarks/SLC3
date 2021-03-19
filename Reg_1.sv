module reg_1(input  logic Clk, Reset, Load,D,
              output logic Data_Out);
    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 1'b0;
		 else if (Load)
			  Data_Out <= D;
    end
	
    

endmodule
