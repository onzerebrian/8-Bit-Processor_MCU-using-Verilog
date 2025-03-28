module io_module  (
    clk	, reset, io_enable, write_enable, data_in, io_input, data_out, io_output
);

    input clk, reset,io_enable, write_enable;        
    input [7:0] data_in,io_input;         

    output reg [7:0] data_out, io_output;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
            io_output <= 8'b0;
        end else if (io_enable) begin
            if (write_enable) begin
                io_output <= data_in;      
            end else begin
                data_out <= io_input;     
            end
        end
    end

endmodule
