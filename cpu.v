`include "opcodes.v" 
`include "register_file.v"	
`include "control_unit.v"   
`include "data_path.v"

module cpu (readM, writeM, address, data, ackOutput, inputReady, reset_n, clk);
	output reg readM;									// read from memory
	output writeM;									// wrtie to memory
	output reg [`WORD_SIZE-1:0] address;	// current address for data
	inout wire [`WORD_SIZE-1:0] data;			// data being input or output
	input ackOutput;								// acknowledge of data receipt from output port
	input inputReady;								// indicates that data is ready from the input port
	input reset_n;									// active-low RESET signal
	input clk;										// clock signal
																																					  
	// Write your own code!
	reg [7:0] PC;
	wire [7:0] nextPC;
	reg [`WORD_SIZE-1:0] instruction;


	wire [11:0] signal;                    //control signal


	control_unit CON (instruction, signal);

	//inputs for datapath
	wire DI_readM = readM;
	wire DI_writeM; assign writeM = DI_writeM;
	wire [`WORD_SIZE-1:0] DI_address;
	reg [`WORD_SIZE-1:0] inputData;
	wire [`WORD_SIZE-1:0] outputData;

	reg first;

	data_path DP (
		DI_readM, 
		DI_writeM, 
		DI_address, 
		inputData, 
		outputData,
		ackOutput, 
		inputReady, 
		instruction, 
		signal, 
		clk,
		PC,
		nextPC, 
		reset_n
	);

	assign data = (!clk) ? outputData : `WORD_SIZE'bz;


	initial
	begin
		PC = 0;
		address = 0;
		readM = 1;
		first = 1;
	end

	always @(*) begin
		if(!reset_n) address = 0;
		else if(clk) address = PC;
		else address = DI_address;
	end

	always @ (posedge clk)
	begin
		if(!reset_n)
		begin
			first <= 1;
			PC <= -1;
			readM <= 1;	
		end
		else
		begin
			PC <= nextPC;
			readM <= 1;
		end
	end

	always @ (posedge inputReady)
	begin
		if(first)
		begin
			instruction = data;
			first = 0;
		end
		else begin
			if(clk > 0) instruction <= data;
			readM <= 0;
		end	
	end
	
endmodule				  