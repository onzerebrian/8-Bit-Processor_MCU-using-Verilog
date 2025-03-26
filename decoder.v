module decoder (instruction, opcode, rdest,rsrc,imm,imm_mode);

    input [7:0] instruction;

    output reg [3:0] opcode;
    output reg [1:0] rdest,rsrc;

    output reg [3:0] imm;

    // high if this is an immediate instruction
    output reg imm_mode; 


    always @(*) begin
        opcode = instruction[7:4];

        case (opcode)
            4'b0101: begin // MOV Immediate
                imm_mode = 1;
                rdest = instruction[3:2];
                imm   = instruction[3:0];
                rsrc  = 2'b00; // not used
            end
            default: begin
                imm_mode = 0;
                rdest = instruction[3:2];
                rsrc  = instruction[1:0];
                imm   = 4'b0000; // not used
            end
        endcase
    end
endmodule

