`include "opcodes.v" 
`include "alu.v"
`include "register_file.v"	   

module data_path (
	readM,
	writeM,
	address,
	inputData,
	outputData,
	ackOutput,
	inputReady,
	instruction,
	conSignal,
	clk,
	PC,
	nextPC,
	reset_n
);
	output readM;									// read from memory
	output writeM;									// wrtie to memory
	output wire [`WORD_SIZE-1:0] address;	// current address for data
	input wire [`WORD_SIZE-1:0] inputData;			// data being input from memory
	output wire [`WORD_SIZE-1:0] outputData;		// data begin output to memory
	input ackOutput;								// acknowledge of data receipt from output port
	input inputReady;								// indicates that data is ready from the input port
	input [`WORD_SIZE-1:0] instruction;
	input [7:0] PC;
	output wire [7:0] nextPC;
	input clk;
	input [11:0] conSignal;
	//signal order : RegDst, Jump, Branch, MemRead, MemtoReg,
	//               MemWrite, ALUSrc, RegWrite, ALUOp(4 bits)
	input reset_n;

	//control signals
	wire RegDst = conSignal[11];
	wire Jump = conSignal[10];
	wire Branch = conSignal[9];
	wire MemRead = conSignal[8];
	wire MemtoReg = conSignal[7];
	wire MemWrite = conSignal[6];
	wire ALUSrc = conSignal[5];
	wire RegWrite = conSignal[4];
	wire [3:0] ALUOp = conSignal[3:0];

	//inputs and outputs for register file
	wire [1:0] r1 = instruction[11:10];
	wire [1:0] r2 = instruction[9:8];
	wire [1:0] rd;
	assign rd = RegDst ? instruction[7:6] :  instruction[9:8];
	wire [`WORD_SIZE-1:0] writeData;
	wire [`WORD_SIZE-1:0] readData1;
	wire [`WORD_SIZE-1:0] readData2;

	//sign-extended instruction[7:0]
	wire [`WORD_SIZE-1:0] extended = { {8{instruction[7]}}, instruction[7:0] };
	wire [`WORD_SIZE-1:0] zero_extended = {8'h00, instruction[7:0]};

	//inputs and outputs for regALU
	wire [`WORD_SIZE-1:0] A = readData1;
	wire [`WORD_SIZE-1:0] B = ALUSrc ? (instruction[15:12] == `ORI_OP ? zero_extended : extended) : readData2;
	wire [3:0] OP = ALUOp;
	//wire [`WORD_SIZE-1:0] C;


	//inputs and outputs for datamemory
	wire DM_readM; assign readM = DM_readM;
	wire DM_writeM; assign writeM = DM_writeM;
	wire [`WORD_SIZE-1:0] calc_address;
	wire [`WORD_SIZE-1:0] DM_address; assign address = DM_address;
	wire [`WORD_SIZE-1:0] DM_readData;


	//branch logic
	wire bcond;

	//jump logic
	wire [`WORD_SIZE-1:0] jumpTarget = {PC[15:12], instruction[11:0]}; 

	assign writeData = MemtoReg ? DM_readData : calc_address;          //fix this

	register_file regFile (r1, r2, rd, writeData, RegWrite, readData1, readData2, clk, reset_n);
	ALU regALU(A, B, OP, calc_address, bcond);
	

	data_memory datMem (
		DM_readM,      //readM
		DM_writeM,     //writeM
		calc_address,   // address to load/store
		DM_address,     // address for access to data
		readData2,     //  data to write
		inputData,      // data from memory
		outputData,
		DM_readData,   // output from this module
		ackOutput,
		inputReady,
		MemWrite,
		MemRead,
		clk
	);

	assign nextPC = Jump ? jumpTarget : ((bcond && Branch) ? PC + 1 + extended : PC + 1);
	//assign nextPC = (bcond && Branch) ? (PC + 1 + extended) : ( Jump ? jumpTarget : (PC + 1));
	
endmodule					