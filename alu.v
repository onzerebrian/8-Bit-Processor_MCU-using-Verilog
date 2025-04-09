module alu (
    input [7:0] a, b,         // Inputs to ALU (R1 and R2)
    input [3:0] alu_op,       // ALU operation control signal (from Control Unit)
    output reg [7:0] result,  // ALU result
    output reg zero,          // Zero flag
    output reg carry,         // Carry flag (for ADD/SUB)
    output reg overflow       // Overflow flag (for ADD/SUB)
);

    // Define ALU operation codes
    parameter ADD = 4'b0000, 
              SUB = 4'b0001, 
              AND = 4'b0010, 
              OR  = 4'b0011, 
              XOR = 4'b0100, 
              MOV = 4'b0101, 
              LDI = 4'b0110, 
              DEC = 4'b0111;

    wire [8:0] sum, diff;  // Sum and difference with extra bit to check carry and overflow

    // Sum and difference with overflow and carry bits
    assign sum = a + b;  // 9-bit result to capture carry bit
    assign diff = a - b; // 9-bit result to capture borrow bit

    always @(*) begin
        // Default flag values
        carry = 0;
        overflow = 0;
        result = 8'b00000000;

        // ALU operation handling
        case (alu_op)
            ADD: begin
                result = sum[7:0];  // Take the lower 8 bits of the sum
                carry = sum[8];     // The 9th bit indicates carry
                overflow = (~a[7] & ~b[7] & result[7]) | (a[7] & b[7] & ~result[7]);  // Overflow condition
            end
            
            SUB: begin
                result = diff[7:0];  // Take the lower 8 bits of the difference
                carry = diff[8];     // The 9th bit indicates borrow
                overflow = (~a[7] & b[7] & result[7]) | (a[7] & ~b[7] & ~result[7]);  // Overflow condition
            end
            
            AND: begin
                result = a & b;  // Bitwise AND operation
            end
            
            OR: begin
                result = a | b;  // Bitwise OR operation
            end
            
            XOR: begin
                result = a ^ b;  // Bitwise XOR operation
            end
            
            MOV: begin
                result = a;      // MOV operation (move the value of a to result)
            end
            
            LDI: begin
                result = a;      // Load immediate (a) to result
            end
            
            DEC: begin
                result = a - 1;  // Decrement operation (a - 1)
            end
            
            default: begin
                result = 8'b00000000;  // Default case, set result to 0
            end
        endcase

        // Zero flag: Set to 1 if result is zero
        zero = (result == 8'b00000000);

    end

endmodule
