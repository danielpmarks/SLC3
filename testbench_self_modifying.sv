module IO3_testbench();

timeunit 100ps;

timeprecision 10ps;

logic [9:0] SW;
logic	Clk, Run, Continue;
logic [9:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3;
logic [15:0]R0, R1, R2, R3, R4;
//enum logic state;

slc3_testtop test_module(.*);

assign R0 = test_module.slc.d0.registers.R0.Data_Out;
assign R1 = test_module.slc.d0.registers.R1.Data_Out;
assign R2 = test_module.slc.d0.registers.R2.Data_Out;
assign R3 = test_module.slc.d0.registers.R3.Data_Out;
assign R4 = test_module.slc.d0.registers.R4.Data_Out;
//assign state = test_module.slc.state_controller.State;
always begin
#1 Clk = ~Clk;
end

initial begin: INITIALIZE
Continue = 1;
Run = 1;
SW = 10'hB;
Clk = 1;

#2 Run = 0; //Reset
Continue = 0;

#6 Continue = 1; //Start execution
Run = 0;

#2 Run = 1;

// I/O Test 3

#110 Continue = 0;

#2 Continue = 1;

#60 SW = 10'h20;

#50 Continue = 0;

#2 Continue = 1;

#120 Continue = 0;

#2 Continue = 1;

#100 SW = 10'h145;

#14 Continue = 0;

#2 Continue = 1;

#120 Continue = 0;

#2 Continue = 1;

end


//initial begin: INITIALIZE
//Continue = 1;
//Run = 1;
//SW = 10'h14;
//Clk = 1;
//
//#2 Run = 0; //Reset
//Continue = 0;
//
//#6 Continue = 1; //Start execution
//Run = 0;
//
//#2 Run = 1;
//// XOR Test
//#100
//SW = 10'b0010110110;
//Continue = 0;
//
//#2 
//Continue = 1;
//
//#50
//SW = 10'b1100101101;
//Continue = 0;
//
//#2 
//Continue = 1;
//end

//initial begin: INITIALIZE
//Continue = 1;
//Run = 1;
//SW = 10'h5A;
//Clk = 1;
//
//#2 Run = 0; //Reset
//Continue = 0;
//
//#6 Continue = 1; //Start execution
//Run = 0;
//
//#2 Run = 1;
//
//# SW = 16'hA1;


//end

endmodule