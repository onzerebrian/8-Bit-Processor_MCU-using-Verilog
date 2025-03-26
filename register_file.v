module register_file  (clk, reg_write, read_addr1,  read_addr2, write_addr, write_data, read_data1, read_data2);
    input clk  , reg_write;
    input [2:0] read_addr1,  read_addr2, write_addr;
    input [7:0] write_data;

    output [7:0] read_data1, read_data2;

    // created the register bank, 8 8-bit registers
    // each the registers can be accessed as registers[0] --> address ooo, registers[1] addrress --> 001 e.t.c.
    reg [7:0] registers [7:0];

    // read operation
    assign read_data1 = registers[read_addr1];
    assign read_data2 = registers[read_addr2];

    // write operation
    always @(posedge clk ) begin
        if (reg_write) begin
            registers[write_addr] = write_data;
        end
    end

endmodule