module alu (a, b, alu_op, result, zero, carry, overflow);
    input [7:0] a, b;
    input [3:0] alu_op;
    output reg [7:0] result;
    output reg zero, carry, overflow;

    parameter ADD = 4'b0000, SUB = 4'b0001, AND = 4'b0010, OR = 4'b0011, XOR = 4'b0100, NOT = 4'b0101, INC = 4'b0110, DEC = 4'b0111;

    wire [8:0] sum, diff;  // one extra bit to detect overflow and carry


    assign diff = a - b;
    assign sum = a + b;

    always @(* ) 
    begin
        case (alu_op)
            ADD :   begin 
                        result = sum[7:0];
                        carry = sum[8];
                        overflow = (~a[7] & ~b[7] & result[7]) | (a[7] & b[7] & ~result[7]);
                    end
            SUB :   begin
                        result = diff[7:0];
                        carry = diff[8];
                        overflow = (~a[7] & b[7] & result[7]) | (a[7] & ~b[7] & ~result[7]);
                     end
            AND :   result = a & b;
            OR :    result = a | b;
            XOR :   result = a ^ b;
            NOT :   result = ~a;
            INC :   result = a + 1;
            DEC:    result = a - 1;
            default: result = 8'b00000000;
        endcase


        // set zero flag and give default values of carry, overflow for 
        zero = (result == 8'b00000000);

         if (alu_op > 4'b0001) begin
            carry = 0;
            overflow = 0;
        end
    
    end


endmodule