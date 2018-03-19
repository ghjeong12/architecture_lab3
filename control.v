`include "opcodes.v" 	   

module control (instruction, signal);
	input [`WORD_SIZE-1:0] instruction;
	output reg [11:0] signal;
	//signal order : RegDst, Jump, Branch, MemRead, MemtoReg,
	//               MemWrite, ALUSrc, RegWrite, ALUOp(4 bits)

	initial
	begin
		signal = 0;
	end

	always @ (*)
	begin
		if(instruction[15:12] == 4'b1111)       // R-type
		begin
			case(instruction[5:0])
				`FUNC_ADD: signal = 12'h810;   // ADD
				`FUNC_SUB: signal = 12'h811;
				`FUNC_SHR: signal = 12'h81a;
				`FUNC_SHL: signal = 12'h81d;
				`FUNC_ORR: signal = 12'h816;
				`FUNC_NOT: signal = 12'h819;
				`FUNC_TCP: signal = 12'h81d;
				`FUNC_AND: signal = 12'h815;
			endcase
		end
		else
		begin
			case(instruction[15:12])
				`ADI_OP: signal = 12'h030;
				`SWD_OP: signal = 12'h060;
				`BNE_OP: signal = 12'h201;
				`JMP_OP: signal = 12'h400;
				`LHI_OP: signal = 12'h03f;
			endcase
		end
	end
	
endmodule							  																		  
