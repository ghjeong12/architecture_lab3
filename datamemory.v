`include "opcodes.v" 	   

module datamemory (
	readM,
	writeM,
	calc_address,
	address,
	writeData,
	inputData,
	outputData,
	readData,
	ackOutput,
	inputReady,
	MemWrite,
	MemRead,
	clk
);
	
	output reg readM;									// read from memory
	output reg writeM;									// wrtie to memory
	input [`WORD_SIZE-1:0] calc_address;
	output wire [`WORD_SIZE-1:0] address;     	// current address for data
	input wire [`WORD_SIZE-1:0] writeData;
	input wire [`WORD_SIZE-1:0] inputData;         //data from tb
	output wire [`WORD_SIZE-1:0] outputData;         //data to tb
	output reg [`WORD_SIZE-1:0] readData;		
	input ackOutput;								// acknowledge of data receipt from output port
	input inputReady;								// indicates that data is ready from the input port
	input MemWrite;
	input MemRead;
	input clk;

	assign outputData = (MemWrite) ? writeData : `WORD_SIZE'bz;
	assign address = calc_address;
	
	always @ (negedge clk)
	begin
		if(MemRead)
		begin
			//address = calc_address;
			readM = 1;
			if(inputReady) readData = inputData;
		end
		else if(MemWrite)
		begin
			//address = calc_address;
			//outputData = writeData;
			readM = 0;
			writeM = 1;
			//wait(ackOutput);
			//$display("writeData : %h", writeData);
			//writeM = 0;
		end
	end

	always @(posedge ackOutput)
	begin
		writeM <= 0;
		$display("writedata : %h", writeData);
	end
	

endmodule							  																		  
