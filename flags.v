module flags (
    input clk,
    input reset,
    input load_flags,
    input zero_in,
    input carry_in,
    input overflow_in,
    output reg zero,
    output reg carry,
    output reg overflow
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            zero <= 0;
            carry <= 0;
            overflow <= 0;
        end
        else if (load_flags) begin
            zero <= zero_in;
            carry <= carry_in;
            overflow <= overflow_in;
        end
        // else hold previous values
    end

endmodule
