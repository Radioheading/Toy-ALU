/* ACM Class System (I) Fall Assignment 1 
 *
 *
 * Implement your naive adder here
 * 
 * GUIDE:
 *   1. Create a RTL project in Vivado
 *   2. Put this file into `Sources'
 *   3. Put `test_adder.v' into `Simulation Sources'
 *   4. Run Behavioral Simulation
 *   5. Make sure to run at least 100 steps during the simulation (usually 100ns)
 *   6. You can see the results in `Tcl console'
 *
 */

module adder_one_bit (
	input A,
	input B,
	input C,
	output sum,
	output P,
	output G
);

assign sum = A ^ B ^ C;
assign P = A | B;
assign G = A & B;

endmodule

module CLA_four_bit (
	input C_last,
	input [3:0] P,
	input [3:0] G,
	output P_all,
	output G_all,
	output [3:0] C_now
);

assign C_now[0] = G[0] | P[0] & C_last;
assign C_now[1] = G[1] | P[1] & G[0] | P[1] & P[0] & C_last;
assign C_now[2] = G[2] | P[2] & G[1] | P[2] & P[1] & G[0] | P[2] & P[1] & P[0] & C_last;
assign C_now[3] = G[3] | P[3] & G[2] | P[3] & P[2] & G[1] | P[3] & P[2] & P[1] & G[0] | P[3] & P[2] & P[1] & P[0] & C_last;
// 等效P/G
assign P_all = P[3] & P[2] & P[1] & P[0];
assign G_all = G[3] | P[3] & G[2] | P[3] & P[2] & G[1] | P[3] & P[2] & P[1] & G[0];

endmodule

module adder_four_bit (
	input [3:0] A,
	input [3:0] B,
	input C_last,
	output [3:0] sum,
	output P,
	output G
);

	wire [3:0] P_in;
	wire [3:0] G_in;
	wire [3:0] C_in;

adder_one_bit a0( .A(A[0]), .B(B[0]), .C(C_last), .sum(sum[0]), .P(P_in[0]), .G(G_in[0]));
adder_one_bit a1( .A(A[1]), .B(B[1]), .C(C_in[0]), .sum(sum[1]), .P(P_in[1]), .G(G_in[1]));
adder_one_bit a2( .A(A[2]), .B(B[2]), .C(C_in[1]), .sum(sum[2]), .P(P_in[2]), .G(G_in[2]));
adder_one_bit a3( .A(A[3]), .B(B[3]), .C(C_in[2]), .sum(sum[3]), .P(P_in[3]), .G(G_in[3]));

CLA_four_bit cla( .C_last(C_last), .P(P_in), .G(G_in), .P_all(P), .G_all(G), .C_now(C_in));

assign C_now = C_in[3];

endmodule

module adder_sixteen_bit (
	input [15:0] A,
	input [15:0] B,
	input C_last,
	output [15:0] sum,
	output P,
	output G
);

	wire [3:0] P_in;
	wire [3:0] G_in;
	wire [3:0] C_in;

adder_four_bit a0( .A(A[3:0]), .B(B[3:0]), .C_last(C_last), .sum(sum[3:0]), .P(P_in[0]), .G(G_in[0]));
adder_four_bit a1( .A(A[7:4]), .B(B[7:4]), .C_last(C_in[0]), .sum(sum[7:4]), .P(P_in[1]), .G(G_in[1]));
adder_four_bit a2( .A(A[11:8]), .B(B[11:8]), .C_last(C_in[1]), .sum(sum[11:8]), .P(P_in[2]), .G(G_in[2]));
adder_four_bit a3( .A(A[15:12]), .B(B[15:12]), .C_last(C_in[2]), .sum(sum[15:12]), .P(P_in[3]), .G(G_in[3]));

CLA_four_bit cla( .C_last(C_last), .P(P_in), .G(G_in), .P_all(P), .G_all(G), .C_now(C_in));

assign C_now = C_in[3];

endmodule

module Add(
	// TODO: Write the ports of this module here
	//
	// Hint: 
	//   The module needs 4 ports, 
	//     the first 2 ports are 16-bit unsigned numbers as the inputs of the adder
	//     the third port is a 16-bit unsigned number as the output
	//	   the forth port is a one bit port as the carry flag
	// 
	input [15:0] a,
	input [15:0] b,
	output reg[15:0] sum
);
	// TODO: Implement this module here
	wire P;
	wire G;
	wire [15:0] ans_16; // otherwise it would print during every clock circle
	adder_sixteen_bit first( .A(a[15:0]), .B(b[15:0]), .C_last(1'b0), .sum(ans_16[15:0]), .P(P), .G(G));

	always @(*) begin
		sum <= ans_16;
	end
	
endmodule
