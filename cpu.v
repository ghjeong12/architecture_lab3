`include "opcodes.v" 	   

module cpu (readM, writeM, address, data, ackOutput, inputReady, reset_n, clk);
	output readM;									// read from memory
	output writeM;									// wrtie to memory
	output [`WORD_SIZE-1:0] address;	// current address for data
	inout [`WORD_SIZE-1:0] data;			// data being input or output
	input ackOutput;								// acknowledge of data receipt from output port
	input inputReady;								// indicates that data is ready from the input port
	input reset_n;									// active-low RESET signal
	input clk;											// clock signal
																																					  
	// Write your own code!
	
endmodule							  																		  