module control_unit (
    input clk,
    input reset,
    input [3:0] opcode,
    input imm_mode,
    output reg reg_write,
    output reg load_a,
    output reg load_b,
    output reg load_c,
    output reg load_ir,
    output reg load_flags,
    output reg load_data_reg,
    output reg mem_write,
    output reg load_pc,
    output reg inc_pc,
    output reg pc_sel,
    output reg [1:0] mux1_sel,
    output reg [3:0] alu_op,
    output reg io_enable,
    output reg io_write_enable
);

    reg [2:0] state, next_state;
    reg [3:0] alu_op_reg;  // Register to hold alu_op across EXEC1, EXEC2, and WRITEBACK

    parameter FETCH = 0, DECODE = 1, EXEC1 = 2, EXEC2 = 3, WRITEBACK = 4,
              OUT_LOAD = 5, OUT_WRITE = 6;

    parameter NOP = 4'h0, ADD = 4'h1, SUB = 4'h2, AND_OP = 4'h3, OR_OP = 4'h4,
              XOR_OP = 4'h5, MOV = 4'h6, LDI = 4'h7, LOAD = 4'h8, STORE = 4'h9,
              IN = 4'hA, OUT = 4'hB, DEC = 4'hC, JMP = 4'hD, JNZ = 4'hE, HLT = 4'hF;

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= FETCH;
        else
            state <= next_state;
    end

    always @(*) begin
        // Default all signals
        reg_write = 0;
        load_a = 0;
        load_b = 0;
        load_c = 0;
        load_ir = 0;
        load_flags = 0;
        load_data_reg = 0;
        mem_write = 0;
        load_pc = 0;
        inc_pc = 0;
        pc_sel = 0;
        mux1_sel = 2'b00;
        alu_op = alu_op_reg; // Use the stored alu_op from the register
        io_enable = 0;
        io_write_enable = 0;
        next_state = FETCH;

        case (state)
            FETCH: begin
                load_ir = 1;
                inc_pc = 1;
                next_state = DECODE;
            end

            DECODE: begin
                case (opcode)
                    ADD, SUB, AND_OP, OR_OP, XOR_OP, MOV, LDI, LOAD, STORE, DEC, JMP, JNZ:
                        next_state = EXEC1;
                    OUT:
                        next_state = OUT_LOAD;
                    default:
                        next_state = FETCH;
                endcase
            end

            EXEC1: begin
                load_a = 1;
                load_b = 1;
                load_c = 1;
                case (opcode)
                    ADD:    alu_op_reg = 4'b0000;  // ALU operation for ADD (4'b0000)
                    SUB:    alu_op_reg = 4'b0001;  // ALU operation for SUB (4'b0001)
                    AND_OP: alu_op_reg = 4'b0010;  // ALU operation for AND (4'b0010)
                    OR_OP:  alu_op_reg = 4'b0011;  // ALU operation for OR (4'b0011)
                    XOR_OP: alu_op_reg = 4'b0100;  // ALU operation for XOR (4'b0100)
                    MOV:    alu_op_reg = 4'b0101;  // ALU operation for MOV (4'b0101)
                    LDI:    alu_op_reg = 4'b0110;  // ALU operation for LDI (4'b0110)
                    DEC:    alu_op_reg = 4'b0111;  // ALU operation for DEC (4'b0111)
                endcase
                next_state = EXEC2;
            end

            EXEC2: begin
                load_c = 1;
                load_flags = 1;
                next_state = WRITEBACK;
            end

            WRITEBACK: begin
                reg_write = 1;
                mux1_sel = 2'b00;
                next_state = FETCH;
            end

            OUT_LOAD: begin
                load_a = 1;
                alu_op_reg = 4'b0000; // Pass A
                load_c = 1;
                next_state = OUT_WRITE;
            end

            OUT_WRITE: begin
                mux1_sel = 2'b00;
                load_data_reg = 1;
                io_enable = 1;
                io_write_enable = 1;
                next_state = FETCH;
            end
        endcase
    end
endmodule
