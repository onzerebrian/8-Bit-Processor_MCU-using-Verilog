module datapath (
    input clk,
    input reset,

    // Control Signals
    input reg_write,
    input [3:0] alu_op,
    input [1:0] mux1_sel,
    input load_a,
    input load_b,
    input load_c,
    input load_ir,
    input load_flags,
    input load_data_reg,
    input mem_write,
    input load_pc,
    input inc_pc,
    input pc_sel,
    input io_enable,
    input io_write_enable,

    // Register Addresses
    input [2:0] read_addr1,
    input [2:0] read_addr2,
    input [2:0] write_addr,

    // Immediate and jump values
    input [7:0] jump_address,

    // I/O Input
    input [7:0] io_input,

    // Outputs
    output [7:0] pc_out,
    output [7:0] instruction,
    output [7:0] io_output,
    output wire zero,
    output wire carry,
    output wire overflow
);

    // === Internal Wires ===
    wire [7:0] reg_read_data1, reg_read_data2;
    wire [7:0] reg_a_out, reg_b_out, reg_c_out;
    wire [7:0] alu_result;
    wire [7:0] data_register_out;
    wire [7:0] mem_data_out;
    wire [7:0] write_back_data;
    wire [7:0] instruction_in;
    wire [7:0] pc_plus_1;
    wire [7:0] pc_mux_out;

    // === Register File ===
    register_file rf (
        .clk(clk),
        .reg_write(reg_write),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(write_back_data),
        .read_data1(reg_read_data1),
        .read_data2(reg_read_data2)
    );

    // === Reg A ===
    reg_a regA (
        .clk(clk),
        .reset(reset),
        .load_a(load_a),
        .data_in(reg_read_data1),
        .data_out(reg_a_out)
    );

    // === Reg B ===
    reg_b regB (
        .clk(clk),
        .reset(reset),
        .load_b(load_b),
        .data_in(reg_read_data2),
        .data_out(reg_b_out)
    );

    // === ALU ===
    alu alu_unit (
        .a(reg_a_out),
        .b(reg_b_out),
        .alu_op(alu_op),
        .result(alu_result),
        .zero(zero),
        .carry(carry),
        .overflow(overflow)
    );

    // === Reg C ===
    reg_c regC (
        .clk(clk),
        .reset(reset),
        .load_c(load_c),
        .data_in(alu_result),
        .data_out(reg_c_out)
    );

    // === Flags Register ===
    flags flags_reg (
        .clk(clk),
        .reset(reset),
        .load_flags(load_flags),
        .zero_in(zero),
        .carry_in(carry),
        .overflow_in(overflow),
        .zero(zero),
        .carry(carry),
        .overflow(overflow)
    );

    // === Data Memory ===
    data_memory ram (
        .clk(clk),
        .address(reg_b_out),           // Address comes from Reg B
        .write_enable(mem_write),
        .data_in(data_register_out),
        .data_out(mem_data_out)
    );

    // === Data Register ===
    data_register data_reg (
        .clk(clk),
        .reset(reset),
        .load_data(load_data_reg),
        .data_in(mem_data_out),
        .data_out(data_register_out)
    );

    // === MUX1: Write-back selector (Reg C, RAM, I/O) ===
    mux1 mux_writeback (
        .sel(mux1_sel),
        .alu_data(reg_c_out),
        .mem_data(data_register_out),
        .io_data(io_input),
        .out_data(write_back_data)
    );

    // === Instruction Register ===
    instruction_register ir (
        .clk(clk),
        .reset(reset),
        .load_ir(load_ir),
        .instr_in(instruction_in),
        .instr_out(instruction)
    );

    // === Program Counter ===
    program_counter pc (
        .clk(clk),
        .reset(reset),
        .load_pc(load_pc),
        .inc_pc(inc_pc),
        .pc_in(pc_mux_out),
        .pc_out(pc_out)
    );

    // === PC + 1 Adder ===
    assign pc_plus_1 = pc_out + 1;

    // === PC MUX: Selects PC+1 or jump address ===
    pc_mux pc_selector (
        .pc_plus_1(pc_plus_1),
        .jump_address(jump_address),
        .sel(pc_sel),
        .pc_in(pc_mux_out)
    );

    // === Instruction Memory ===
    instruction_memory rom (
        .address(pc_out),
        .instruction(instruction_in)  
    );

    // === I/O Module ===
    io_module io_block (
        .clk(clk),
        .reset(reset),
        .io_enable(io_enable),
        .write_enable(io_write_enable),
        .data_in(data_register_out),
        .io_input(io_input),
        .data_out(), 
        .io_output(io_output)
    );

endmodule
