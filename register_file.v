module register_file (
    input clk, 
    input reg_write, 
    input [2:0] read_addr1,  // Address for Reg A
    input [2:0] read_addr2,  // Address for Reg B
    input [2:0] write_addr,  // Address for writing (Reg C)
    input [7:0] write_data,  // Data to write
    output [7:0] read_data1, // Data from Reg A (R1)
    output [7:0] read_data2  // Data from Reg B (R2)
);

    // Define the register bank (8 registers, each 8 bits wide)
    reg [7:0] registers [7:0];

    // Read operation
    assign read_data1 = registers[read_addr1];  // Reading from the selected register
    assign read_data2 = registers[read_addr2];  // Reading from the selected register

    // Write operation (Triggered on the positive edge of the clock)
    always @(posedge clk) begin
        if (reg_write) begin
            registers[write_addr] <= write_data;  // Write to the selected register
        end
    end
endmodule
