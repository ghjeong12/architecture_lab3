 
// Opcode
`define	ALU_OP	4'd15
`define	ADI_OP		4'd4
`define	ORI_OP	4'd5
`define	LHI_OP		4'd6
`define	LWD_OP	4'd7   		  
`define	SWD_OP	4'd8  
`define	BNE_OP	4'd0
`define	BEQ_OP	4'd1
`define	JMP_OP	4'd9

// ALU instruction function codes
`define FUNC_ADD 6'd0
`define FUNC_SUB 6'd1
`define FUNC_AND 6'd2
`define FUNC_ORR 6'd3
`define FUNC_NOT 6'd4
`define FUNC_TCP 6'd5
`define FUNC_SHL 6'd6
`define FUNC_SHR 6'd7	 

`define	WORD_SIZE	16			
`define	NUM_REGS	4