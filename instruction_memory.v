module instruction_memory (address, instruction);

    input [7:0] address;
    output [7:0] instruction;

    reg [7:0] memory [0:255];
    integer i;

    initial begin
        // Format: [opcode][rdest][rsrc] or [opcode][rdest][imm4]

        memory[0] = 8'b01011010;
        memory[1] = 8'b01011100;
        memory[2] = 8'b01000110;
        memory[3] = 8'b00001101;
        memory[4] = 8'b00010111;
        memory[5] = 8'b00101100;
        memory[6] = 8'b00110100;
        memory[7] = 8'b01110010;
        memory[8] = 8'b11110000;

        // Fill the rest with NOPs

        
        for (i = 9; i < 256; i = i + 1) begin
            memory[i] = 8'b11110000;
        end
    end

    assign instruction = memory[address];

endmodule
