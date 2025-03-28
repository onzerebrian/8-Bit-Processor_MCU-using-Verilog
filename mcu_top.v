module mcu_top (
    clk,
    reset,
    io_input,
    io_output );
    
    input clk, reset;
    input [7:0] io_input;
    output [7:0] io_output;


    // === Internal wires ===
    wire [7:0] instruction;
    wire [3:0] opcode;
    wire [1:0] rdest, rsrc;
    wire [3:0] imm;
    wire imm_mode;

    // Control signals from control unit
    wire reg_write, load_a, load_b, load_c, load_ir, load_flags;
    wire load_data_reg, mem_write, load_pc, inc_pc, pc_sel;
    wire io_enable, io_write_enable;
    wire [3:0] alu_op;
    wire [1:0] mux1_sel;
    wire [2:0] write_addr, read_addr1, read_addr2;
    wire [7:0] jump_address;
    wire [7:0] pc_out;

    // === Decoder ===
    decoder decoder_inst (
        .instruction(instruction),
        .opcode(opcode),
        .rdest(rdest),
        .rsrc(rsrc),
        .imm(imm),
        .imm_mode(imm_mode)
    );

    assign read_addr1 = rdest;
    assign read_addr2 = rsrc;
    assign write_addr = rdest;
    assign jump_address = {4'b0000, imm};  // simple expansion

    // === Control Unit ===
    control_unit cu (
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .imm_mode(imm_mode),
        .reg_write(reg_write),
        .load_a(load_a),
        .load_b(load_b),
        .load_c(load_c),
        .load_ir(load_ir),
        .load_flags(load_flags),
        .load_data_reg(load_data_reg),
        .mem_write(mem_write),
        .load_pc(load_pc),
        .inc_pc(inc_pc),
        .pc_sel(pc_sel),
        .mux1_sel(mux1_sel),
        .alu_op(alu_op),
        .io_enable(io_enable),
        .io_write_enable(io_write_enable)
    );

    // === Datapath ===
    datapath dp (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .alu_op(alu_op),
        .mux1_sel(mux1_sel),
        .load_a(load_a),
        .load_b(load_b),
        .load_c(load_c),
        .load_ir(load_ir),
        .load_flags(load_flags),
        .load_data_reg(load_data_reg),
        .mem_write(mem_write),
        .load_pc(load_pc),
        .inc_pc(inc_pc),
        .pc_sel(pc_sel),
        .io_enable(io_enable),
        .io_write_enable(io_write_enable),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .jump_address(jump_address),
        .io_input(io_input),
        .pc_out(pc_out),
        .instruction(instruction),
        .io_output(io_output),
        .zero(),
        .carry(),
        .overflow()
    );



endmodule