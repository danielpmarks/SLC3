module datapath( 
					input Reset,
              input Clk,
              input LD_MAR,
                     LD_MDR,
                     LD_IR,
                     LD_BEN,
                     LD_CC,
                     LD_REG,
                     LD_PC,
                     LD_LED, // for PAUSE instruction
									
              input  GatePC,
                     GateMDR,
                     GateALU,
                     GateMARMUX,
									
              input logic [1:0]  PCMUX,
              input logic DRMUX,
                            SR1MUX,
                            SR2MUX,
                            ADDR1MUX,
              input logic [1:0] ADDR2MUX,
                                   ALUK,
				  
              input logic MIO_EN,
              input logic [15:0] MDR_In,
              output logic [15:0] MAR,MDR,PC,IR,
              output logic BEN,
              output logic [9:0] LED
);

       logic [15:0] Data;
       logic [3:0] Gate_Select;
       logic [15:0] ADDER1, ADDER2, ADDER_OUT;
       logic [15:0] ALU_Out, PC_In, MDR_Data, SR1_OUT, SR2_OUT, SR2_MUX_OUT;
       logic [2:0] DR, SR1,SR2;
       logic N,Z,P, N_in, Z_in, P_in;
       logic BEN_in;
       assign SR2 = IR[2:0];
       assign LED = IR[9:0];

       always_comb begin : NZP_Logic
              N_in = Data[15];
              Z_in = Data == 16'h0000 ? 1'b1 : 1'b0;
              P_in = (~Data[15]) & (~Z_in);
              BEN_in = (IR[11]&N)|(IR[10]&Z)|(IR[9]&P);

       end

       // NZP registers
       reg_1 N_reg(.Clk(Clk), .Reset(Reset), .Load(LD_CC), .D(N_in), .Data_Out(N));
       reg_1 Z_reg(.Clk(Clk), .Reset(Reset), .Load(LD_CC), .D(Z_in), .Data_Out(Z));
       reg_1 P_reg(.Clk(Clk), .Reset(Reset), .Load(LD_CC), .D(P_in), .Data_Out(P));

       reg_1 BEN_reg(.Clk(Clk),.Reset(Reset), .Load(LD_BEN),.D(BEN_in), .Data_Out(BEN));

       always_comb begin : ADDERS_MUX
              ADDER1 = ADDR1MUX ? SR1_OUT : PC;
              //ADDER2 = 16'd0;
              unique case(ADDR2MUX)
                     2'b00: ADDER2 = 16'd0;
                     2'b01: ADDER2 = {{10{IR[5]}}, IR[5:0]};
                     2'b10: ADDER2 = {{7{IR[8]}}, IR[8:0]};
                     2'b11: ADDER2 = {{5{IR[10]}}, IR[10:0]};
              endcase
       end

       // 16-bit adder
       adder_16 ADDER(.A(ADDER1), .B(ADDER2), .cin(1'b0), .S(ADDER_OUT), .cout());

              

       always_comb 
       begin : Gate_MUX

              //Logic to load the data bus using a MUX instead of tri-state buffers
              Gate_Select = {GatePC,GateMDR,GateALU, GateMARMUX};

              unique case (Gate_Select)

                     4'b1000: //GatePC
                            Data = PC;
                     4'b0100: //GateMDR
                            Data = MDR;
                     4'b0010: //GateALU
                            Data = ALU_Out;
                     4'b0001: //GateMARMUX
                            Data = ADDER_OUT;
                     default:
                            Data = 16'hxx;
                     endcase
       end

       always_comb begin : SR1_SELECT
              unique case(SR1MUX)
                     1'b0: SR1 = IR[11:9];
                     1'b1: SR1 = IR[8:6];
              endcase
       end

       always_comb begin : SR2_MUX
		SR2_MUX_OUT = SR2_OUT;
              unique case(SR2MUX)
                     
                     1'b0: SR2_MUX_OUT = SR2_OUT;
                     1'b1: SR2_MUX_OUT = {{11{IR[4]}}, IR[4:0]}; /* Set the SR2 MUX out to immediate value from IR */
              endcase
       end
       
       always_comb begin : DR_MUX
              DR = 3'b111;
              unique case(DRMUX)
                     1'b0: DR = IR[11:9];
                     1'b1: DR = 3'b111;
              endcase

       end

        //Register File
       Reg_File registers(.Clk(Clk), .Reset(Reset), .D(Data), .DR(DR), .SR1(SR1), .SR2(SR2), .LD_REG(LD_REG), .SR1_OUT(SR1_OUT), .SR2_OUT(SR2_OUT));

       //ALU
       ALU ALU_Unit(.ALUK(ALUK), .A(SR1_OUT), .B(SR2_MUX_OUT), .out(ALU_Out));

       always_comb begin : PC_MUX  //MUX input to the PC
              PC_In = PC + 1;
              unique case (PCMUX)
                     (2'b00): //Increment PC
                            PC_In = PC + 1;
                     (2'b01):
                            PC_In = Data;
                     (2'b10):
                            PC_In = ADDER_OUT;
              endcase
       end

       always_comb begin : MDR_MUX //MUX input to the MDR
              // MIO_EN is active low
              MDR_Data = MIO_EN ? MDR_In : Data;
       end

      

      
       //Program Counter register
       reg_16 reg_PC(.Clk(Clk),.Reset(Reset), .Load(LD_PC), .D(PC_In), .Data_Out(PC));

       //Memory registers
       reg_16 reg_MAR(.Clk(Clk),.Reset(1'b0), .Load(LD_MAR), .D(Data), .Data_Out(MAR));
       reg_16 reg_MDR(.Clk(Clk),.Reset(1'b0), .Load(LD_MDR), .D(MDR_Data), .Data_Out(MDR));
       
       //Instruction register
       reg_16 reg_IR(.Clk(Clk),.Reset(1'b0), .Load(LD_IR), .D(Data), .Data_Out(IR));

       /*always_ff @ (posedge Clk) begin
              if(LD_LED)
                     LED <= IR[9:0];
              else
                     LED <= 10'd0;
       end*/

endmodule