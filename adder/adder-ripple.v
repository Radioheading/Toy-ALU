/* ACM Class System (I) Fall Assignment 1 
 *
 * adder-ripple, bro
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
	output C_out
);

assign sum = A ^ B ^ C;
assign C_out = (A & B) | (C & (A ^ B));

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
	input [31:0] a,
	input [31:0] b,
	output reg [31:0] sum
);
	// TODO: Implement this module here
	wire [31:0] carry;
	wire [31:0] ans_32;
	genvar i;
	adder_one_bit first(.A(a[0]), .B(b[0]), .C(1'b0), .sum(ans_32[0]), .C_out(carry[0]));
	for (i = 1; i < 32; i = i + 1) begin
		adder_one_bit adder_one(.A(a[i]), .B(b[i]), .C(carry[i - 1]), .sum(ans_32[i]), .C_out(carry[i]));
	end
	always @(*) begin
		sum <= ans_32;
	end
endmodule