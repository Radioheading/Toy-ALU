`include "adder-carry.v"

module sign_extend (
    input [15:0] x,
    output [31:0] y
);
    assign y = {{16{x[15]}}, x[15:0]};
endmodule
// unused

module multiplier (
	input signed [15:0] A,
	input signed [15:0] B,
	output reg signed [31:0] mul
);
    reg signed [31:0] ans;
    reg signed [31:0] origin_a;
    reg signed [31:0] minus_a;
    reg signed [31:0] double_a;
    reg signed [31:0] neg_double_a;
    reg [15:-1] extend_b;
    reg[4:0] i;

    always @(A, B) begin
        origin_a = {{16{A[15]}}, A[15:0]};
        minus_a = ~origin_a + 1;
        double_a = origin_a << 1;
        neg_double_a = ~double_a + 1;
        extend_b = {B[15:0], 1'b0};

        ans = 0;
        for (i = 0; i < 16; i = i + 2) begin
            if (extend_b[i + 1] == 1'b0 && extend_b[i] == 1'b0 && extend_b[i - 1] == 1'b0) begin
                // do nothing
            end
            if (extend_b[i + 1] == 1'b0 && extend_b[i] == 1'b0 && extend_b[i - 1] == 1'b1) begin
                ans = ans + (A << i);
            end
            if (extend_b[i + 1] == 1'b0 && extend_b[i] == 1'b1 && extend_b[i - 1] == 1'b0) begin
                ans = ans + (A << i);
            end
            if (extend_b[i + 1] == 1'b0 && extend_b[i] == 1'b1 && extend_b[i - 1] == 1'b1) begin
                ans = ans + (double_a << i);
            end
            if (extend_b[i + 1] == 1'b1 && extend_b[i] == 1'b0 && extend_b[i - 1] == 1'b0) begin
                ans = ans + (neg_double_a << i);
            end
            if (extend_b[i + 1] == 1'b1 && extend_b[i] == 1'b0 && extend_b[i - 1] == 1'b1) begin
                ans = ans + (minus_a << i);
            end
            if (extend_b[i + 1] == 1'b1 && extend_b[i] == 1'b1 && extend_b[i - 1] == 1'b0) begin
                ans = ans + (minus_a << i);
            end
            if (extend_b[i + 1] == 1'b1 && extend_b[i] == 1'b1 && extend_b[i - 1] == 1'b1) begin
                // do nothing
            end
        end
    end



    always @(A, B) begin
        # 20;
        mul = ans;
    end
endmodule
