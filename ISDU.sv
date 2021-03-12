//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//------------------------------------------------------------------------------


module ISDU (   input logic         Clk, 
									Reset,
									Run,
									Continue,
									
				input logic[3:0]    Opcode, 
				input logic         IR_5,
				input logic         IR_11,
				input logic         BEN,
				  
				output logic        LD_MAR,
									LD_MDR,
									LD_IR,
									LD_BEN,
									LD_CC,
									LD_REG,
									LD_PC,
									LD_LED, // for PAUSE instruction
									
				output logic        GatePC,
									GateMDR,
									GateALU,
									GateMARMUX,
									
				output logic [1:0]  PCMUX,
				output logic        DRMUX,
									SR1MUX,
									SR2MUX,
									ADDR1MUX,
				output logic [1:0]  ADDR2MUX,
									ALUK,
				  
				output logic        Mem_OE,
									Mem_WE
				);

	enum logic [4:0] {  Halted, 
						PauseIR1, 
						PauseIR2, 
						S_18, 
						S_33_1, 
						S_33_2,
						S_33_3, 
						S_35, 
						S_32, 
						S_01,
						S_05,
						S_09,
						S_06,
						S_25_1,
						S_25_2,
						S_27,
						S_07,
						S_23,
						S_16_1,
						S_16_2,
						S_16_3,
						S_04,
						S_21,
						S_12,
						S_00,
						S_22}   State, Next_state;   // Internal state logic
		
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= Halted;
		else 
			State <= Next_state;
	end
   
	always_comb
	begin 
		// Default next state is staying at current state
		Next_state = State;
		
		// Default controls signal values
		LD_MAR = 1'b0;
		LD_MDR = 1'b0;
		LD_IR = 1'b0;
		LD_BEN = 1'b0;
		LD_CC = 1'b0;
		LD_REG = 1'b0;
		LD_PC = 1'b0;
		LD_LED = 1'b0;
		 
		GatePC = 1'b0;
		GateMDR = 1'b0;
		GateALU = 1'b0;
		GateMARMUX = 1'b0;
		 
		ALUK = 2'b00;
		 
		PCMUX = 2'b00;
		DRMUX = 1'b0;
		SR1MUX = 1'b0;
		SR2MUX = 1'b0;
		ADDR1MUX = 1'b0;
		ADDR2MUX = 2'b00;
		 
		Mem_OE = 1'b0;
		Mem_WE = 1'b0;
	
		// Assign next state
		unique case (State)
			Halted : 
				if (Run) 
					Next_state = S_18;                      
			S_18 : 
				Next_state = S_33_1;
			// Any states involving SRAM require more than one clock cycles.
			// The exact number will be discussed in lecture.
			S_33_1 : 
				Next_state = S_33_2;
			S_33_2 : 
				Next_state = S_33_3;
			S_33_3 :
				Next_state = S_35;
			S_35 : 
				Next_state = S_32;
			// PauseIR1 and PauseIR2 are only for Week 1 such that TAs can see 
			// the values in IR.
			PauseIR1 : 
				if (~Continue) 
					Next_state = PauseIR1;
				else 
					Next_state = PauseIR2;
			PauseIR2 : 
				if (Continue) 
					Next_state = PauseIR2;
				else 
					Next_state = S_18;
			S_32 : 
				case (Opcode)
					4'b0001 : 	//ADD
						Next_state = S_01;
					4'b0101 : 	//AND
						Next_state = S_05;
					4'b1001 :	//NOT
						Next_state = S_09;
					4'b0110 :	//LDR
						Next_state = S_06;
					4'b0111 :	//STR
						Next_state = S_07;
					4'b0100 :	//JSR
						Next_state = S_04;
					4'b1100 :	//JMP
						Next_state = S_12;
					4'b0000 : 	//BR
						Next_state = S_00;
					4'b1101 :	//Pause
						Next_state = PauseIR1;
					default : 
						Next_state = S_18;
				endcase
			S_01 : 
				Next_state = S_18;
			S_05 :
				Next_state = S_18;
			S_09 :
				Next_state = S_18;
			S_06 :
				Next_state = S_25_1;
			S_25_1 :
				Next_state = S_25_2;
			S_25_2 :
				Next_state = S_27;
			S_27 :
				Next_state = S_18;
			S_07 :
				Next_state = S_23;
			S_23 :
				Next_state = S_16_1;
			S_16_1 :
				Next_state = S_16_2;
			S_16_2 :
				Next_state = S_16_3;
			S_16_3 :
				Next_state = S_18;
			S_04 :
				Next_state = S_21;
			S_21 :
				Next_state = S_18;
			S_12 :
				Next_state = S_18;
			S_00 :
				if(BEN)
					Next_state = S_22;
				else
					Next_state = S_18;
			S_22 :
				Next_state = S_18;

			// You need to finish the rest of states.....

			default : ;

		endcase
		
		// Assign control signals based on current state
		case (State)
			Halted: ;
			S_18 : 
				begin 
					GatePC = 1'b1;
					LD_MAR = 1'b1;
					PCMUX = 2'b00;
					LD_PC = 1'b1;
				end
			S_33_1 : 
				Mem_OE = 1'b1;
			S_33_2 : 
				begin 
					Mem_OE = 1'b1;
					LD_MDR = 1'b1;
				end
			S_33_3:
				begin
					Mem_OE = 1'b1;
					LD_MDR = 1'b1;
				end	
			S_35 : 
				begin 
					GateMDR = 1'b1;
					LD_IR = 1'b1;
				end
			PauseIR1: ;
			PauseIR2: ;
			S_32 : 
				LD_BEN = 1'b1;
			/* ADD */
			S_01 : 
				begin 
					SR1MUX = 1'b1;	//Use IR[8:6]
					SR2MUX = IR_5;	
					ALUK = 2'b00;
					GateALU = 1'b1;
					LD_REG = 1'b1;	//Load destination register
					DRMUX = 1'b0;	//DR select from IR[11:9]
					LD_CC = 1'b1;
				end

			/* AND */
			S_05 :
				begin
					SR1MUX = 1'b1;
					SR2MUX = IR_5;
					ALUK = 2'b01;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					DRMUX = 1'b0;
					LD_CC = 1'b1;
				end
			/* NOT */
			S_09:
				begin
					SR1MUX = 1'b1;	//Select SR1 as IR[8:6]
					ALUK = 2'b10;	//Not A
					GateALU = 1'b1;	// Load from ALU
					LD_REG = 1'b1;	// Load register
					DRMUX = 1'b0;	// Set DR to IR[11:9]
				end
			
			/* LDR */
			S_06:
				begin
					LD_MAR = 1'b1;	// Load MAR
					SR1MUX = 1'b1;	// Load register from IR[8:6]
					ADDR2MUX = 2'b01;	// Add offset6
					ADDR1MUX = 1'b1;	// Add from base register
					GateMARMUX = 1'b1;	// Load MAR from adder
				end
			S_25_1:
				begin
					Mem_OE = 1'b1;	// Memory read enable

				end
			S_25_2:
				begin
					LD_MDR = 1'b1;	// Load MDR
					Mem_OE = 1'b1;	// Memory read enable
				end
			S_27:
				begin
					LD_REG = 1'b1;	// Load register
					GateMDR = 1'b1;	// Load from MDR
					DRMUX = 1'b0;	// Load into register IR[11:9]
					LD_CC = 1'b1;
				end
			
			/* STR */
			S_07:
				begin
					LD_MAR = 1'b1;	// Load MAR
					SR1MUX = 1'b1;	// Load register from IR[8:6]
					ADDR2MUX = 2'b01;	// Add offset6
					ADDR1MUX = 1'b1;	// Add from base register
					GateMARMUX = 1'b1;	// Load MAR from adder
				end
			S_23:
				begin
					LD_MDR = 1'b1;	//Load MDR
					GateALU = 1'b1;	// Load from ALU
					ALUK = 2'b11;	// ALU = PassA
					SR1MUX = 1'b0;	// Set source register to IR[11:9]
					Mem_OE = 1'b0;	// Load MDR from data bus
				end
			S_16_1:
				begin
					Mem_WE = 1'b1;	//Write enable for memory system
				end
			S_16_2:
				begin
					Mem_WE = 1'b1;	//Write enable for memory system
				end
			S_16_3:
				begin
					Mem_WE = 1'b1;	//Write enable for memory system
				end

			/* BR */
			S_22:
				begin
					LD_PC = 1'b1;	// Load PC
					ADDR1MUX = 1'b0;	// Select PC
					ADDR2MUX = 2'b10;	// Select offset9
					PCMUX = 2'b10;	// Load PC from the adder
				end

			/* JMP */
			S_12:
				begin
					LD_PC = 1'b1;	// Load PC
					SR1MUX = 1'b1;	// Set SR1 to IR[8:6]
					ALUK = 2'b11;	// Pass A
					GateALU = 1'b1;	// Pass data from ALU to bus
					PCMUX = 2'b01;	// Load PC from data bus
				end

			/* JSR */
			S_04:
				begin
					LD_REG = 1'b1;	// Load register
					GatePC = 1'b1;	// Load from PC
					DRMUX = 1'b1;	// Set destination register to R7
				end
			S_21:
				begin
					LD_PC = 1'b1;	// Load PC
					PCMUX = 2'b10;	// Load from adder
					ADDR1MUX = 1'b0;	// Set adder1 to PC
					ADDR2MUX = 2'b11;	// Set adder2 to offset11
				end
			


			default : ;
		endcase
	end 

	
endmodule
