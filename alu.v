`timescale 1ns / 100ps
						 
module ALU(A,B,OP,C, bcond);

	input signed [15:0]A;
	input signed [15:0]B;
	input [3:0]OP;
	output signed [15:0]C;					   
	output reg bcond;

	reg[15:0] C;
	
	initial begin
	bcond = 0;
	end

	always @ (A or B or OP) begin
		bcond = 0;
		if(OP == 4'b0000) begin C = A + B; end
		else if(OP == 4'b0001) begin
			C = A - B;
			if(C == 0) bcond = 0;    //A=B
			else bcond = 1;
		end
		else if (OP == 4'b0010) begin C <= ~(A & B); end
		else if (OP == 4'b0011) begin C <= ~(A | B); end
		else if (OP == 4'b0100) begin C <= A ~^ B; end
		else if (OP == 4'b0101) begin C <= (A & B); end
		else if (OP == 4'b0110) begin C <= (A | B); end
		else if (OP == 4'b0111) begin C <= (A ^ B); end
		else if (OP == 4'b1000) begin C <= A; end
		else if (OP == 4'b1001) begin C <= ~A; end
		else if (OP == 4'b1010) begin C <= {A[15], A[15:1]}; end
		else if (OP == 4'b1011) begin C <= A >>> 1; end
		else if (OP == 4'b1100) begin C <= ~(A) + 1; end            //TCP
		else if (OP == 4'b1101) begin C <= A << 1; end
		else if (OP == 4'b1110) begin C <= A <<< 1; end
		else if (OP == 4'b1111) begin C <= {B[7:0], 8'h00}; end     //LHI
	end
	
endmodule

