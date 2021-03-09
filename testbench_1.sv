module testbench();

timeunit 100ps;

timeprecision 10ps;

logic [9:0] SW;
logic	Clk, Run, Continue;
logic [9:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3;

slc3_testtop test_module(.*);

always begin
#1 Clk = ~Clk;
end

initial begin: INITIALIZE
Continue = 1;
Run = 1;
SW = 10'h00;
Clk = 1;

#2 Run = 0; //Reset
Continue = 0;

#6 Continue = 1; //Start execution
Run = 0;

#6 Continue = 0;
Run = 1;

#6 Continue = 1;

#6 Continue = 0;

#6 Continue = 1;

#6 Continue = 0;

#6 Continue = 1;

#6 Continue = 0;


end

endmodule