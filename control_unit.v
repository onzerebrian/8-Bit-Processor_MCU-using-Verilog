module control_unit (
    input clk,
    input reset,
    input [3:0] opcode,
    input imm_mode,  // from decoder

    // Control signals output
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

    // Opcodes (based on earlier discussion)
    localparam ADD   = 4'b0000;
    localparam SUB   = 4'b0001;
    localparam STORE = 4'b0010;
    localparam LOAD  = 4'b0011;
    localparam MOV   = 4'b0100;
    localparam MOVI  = 4'b0101;
    localparam JMP   = 4'b0111;
    localparam NOP   = 4'b1111;

    // Simple FSM: only a fetch-decode-execute cycle
    always @(*) begin
        // Default all signals
        reg_write       = 0;
        load_a          = 0;
        load_b          = 0;
        load_c          = 0;
        load_ir         = 0;
        load_flags      = 0;
        load_data_reg   = 0;
        mem_write       = 0;
        load_pc         = 0;
        inc_pc          = 1;
        pc_sel          = 0;
        mux1_sel        = 2'b00;
        alu_op          = 4'b0000;
        io_enable       = 0;
        io_write_enable = 0;

        case (opcode)
            ADD: begin
                load_a = 1;
                load_b = 1;
                alu_op = ADD;
                load_c = 1;
                mux1_sel = 2'b00;      // ALU result
                reg_write = 1;
                load_flags = 1;
            end

            SUB: begin
                load_a = 1;
                load_b = 1;
                alu_op = SUB;
                load_c = 1;
                mux1_sel = 2'b00;
                reg_write = 1;
                load_flags = 1;
            end

            MOV: begin
                load_a = 1;
                load_b = 1;
                alu_op = 4'b0000;      // Bypass ALU if needed
                load_c = 1;
                mux1_sel = 2'b00;
                reg_write = 1;
            end

            MOVI: begin
                alu_op = 4'b0000;      // Immediate loaded directly
                load_c = 1;
                mux1_sel = 2'b00;
                reg_write = 1;
            end

            STORE: begin
                load_b = 1;            // Address
                load_data_reg = 1;    // Data to be stored
                mem_write = 1;
            end

            LOAD: begin
                load_b = 1;
                load_data_reg = 1;
                mux1_sel = 2'b01;      // Memory data
                reg_write = 1;
            end

            JMP: begin
                load_pc = 1;
                pc_sel = 1;
            end

            NOP: begin

            end

            default: begin

            end
        endcase
    end

endmodule
