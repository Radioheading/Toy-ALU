`include "adder-carry.v"

module triple_full_adder (
    input signed [31:0] A,
    input signed [31:0] B,
    input signed [31:0] C,
    output signed [31:0] S,
    output signed [31:0] C_out
);
    assign S = A ^ B ^ C;
    assign C_out = ((A & B) | (B & C) | (A & C)) << 1;
endmodule

/*
 * first layer: (0, 1, 2) -> (w[0], w[1]), (4, 5, 6) -> (w[2], w[3])
 * second layer: (w[0], w[1], 3) -> (w[4], w[5]), (w[2], w[3], 7) -> (w[6], w[7])
 * third layer: (w[4], w[5], w[6]) -> (w[8], w[9])
 * fourth layer: (w[7], w[8], w[9]) -> (w[10], w[11])
 */
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
    reg signed [31:0] cur;
    reg signed [31:0] origin_a;
    reg signed [31:0] minus_a;
    reg signed [31:0] double_a;
    reg signed [31:0] neg_double_a;
    reg [15:-1] extend_b;
    reg signed [4:0] i;
    wire [31:0] w[12];
    reg [31:0] arr[8];

    triple_full_adder tfa0 (arr[0], arr[1], arr[2], w[0], w[1]);
    triple_full_adder tfa1 (arr[4], arr[5], arr[6], w[2], w[3]);
    triple_full_adder tfa2 (w[0], w[1], arr[3], w[4], w[5]);
    triple_full_adder tfa3 (w[2], w[3], arr[7], w[6], w[7]);
    triple_full_adder tfa4 (w[4], w[5], w[6], w[8], w[9]);
    triple_full_adder tfa5 (w[7], w[8], w[9], w[10], w[11]);

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
                cur = A << i;
            end
            if (extend_b[i + 1] == 1'b0 && extend_b[i] == 1'b1 && extend_b[i - 1] == 1'b0) begin
                cur = A << i;
            end
            if (extend_b[i + 1] == 1'b0 && extend_b[i] == 1'b1 && extend_b[i - 1] == 1'b1) begin
                cur = double_a << i;
            end
            if (extend_b[i + 1] == 1'b1 && extend_b[i] == 1'b0 && extend_b[i - 1] == 1'b0) begin
                cur = neg_double_a << i;
            end
            if (extend_b[i + 1] == 1'b1 && extend_b[i] == 1'b0 && extend_b[i - 1] == 1'b1) begin
                cur = minus_a << i;
            end
            if (extend_b[i + 1] == 1'b1 && extend_b[i] == 1'b1 && extend_b[i - 1] == 1'b0) begin
                cur = minus_a << i;
            end
            if (extend_b[i + 1] == 1'b1 && extend_b[i] == 1'b1 && extend_b[i - 1] == 1'b1) begin
                // do nothing
            end
        end
        ans = w[10] + w[11];
    end



    always @(A, B) begin
        # 20;
        mul = ans;
    end
endmodule
