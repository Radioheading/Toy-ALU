/* ACM Class System (I) Fall Assignment 1 
 *
 *
 * This file is used to test your adder. 
 * Please DO NOT modify this file.
 * 
 * GUIDE:
 *   1. Create a RTL project in Vivado
 *   2. Put `adder.v' OR `adder2.v' into `Sources', DO NOT add both of them at the same time.
 *   3. Put this file into `Simulation Sources'
 *   4. Run Behavioral Simulation
 *   5. Make sure to run at least 100 steps during the simulation (usually 100ns)
 *   6. You can see the results in `Tcl console'
 *
 */

`include "multiplier.v"

module test_multiplier;
	wire signed [31:0] answer;
	reg  signed [15:0] a, b;
	reg	 signed [31:0] res;

	multiplier multiplier (a, b, answer);
	
	integer i;
	reg [15:0] right;
	reg [15:0] wrong;
	initial begin
		right = 0;
		wrong = 0;
		# 5;
		for (i = 1; i <= 10000; i = i + 1) begin
			a[15:0] = $random;
			b[15:0] = $random;
			res		= a * b;
			
			#30;
			$display("TESTCASE %d: %d * %d = %d, correct answer is %d", i, a, b, answer, res[31:0]);

			if (answer !== res[31:0]) begin
				$display("Wrong Answer!");
				wrong = wrong + 1;
			end
		end
		right = 10000 - wrong;
		$display("You have passed %d of %d tests.", right, 10000);
		$finish;
	end
endmodule
