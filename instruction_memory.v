
module instruction_memory (
    input [7:0] address,
    output reg [7:0] instruction
);

    reg [7:0] memory [0:255];

    initial begin
        $readmemh("program.hex", memory);
    end

    always @(*) begin
        instruction = memory[address];
    end

endmodule
