module data_memory (clk, address, write_enable, data_in, data_out);

    input clk,write_enable;
    input [7:0] address,data_in;

    output reg [7:0] data_out;

    //create the RAM memory
    reg [7:0] Ram_mem [0:255];

    always @(posedge clk ) 
    begin
        if (write_enable)
        begin
            Ram_mem[address] <= data_in;
        end
        else begin
            data_out <= Ram_mem[address];
        end
    end
    
endmodule