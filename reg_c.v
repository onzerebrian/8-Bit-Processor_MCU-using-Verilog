module reg_c (clk, reset, load_c, data_in, data_out);
    input clk, reset, load_c;
    input [7:0] data_in;

    output reg [7:0] data_out;



    always @(posedge clk or posedge reset) 
    begin
        if (reset)  begin 
            data_out = 8'b00000000;
        end
        else if (load_c) begin 
            data_out = data_in;
        end
        
    end
endmodule