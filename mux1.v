module mux1 (sel,alu_data, mem_data, io_data, out_data);
    input [1:0] sel;
    input [7:0] alu_data, mem_data,io_data;

    output reg [7:0] out_data;


    always @(*) 
    begin
        casex (sel)
            2'b00 : out_data = alu_data;
            2'b01 : out_data = mem_data;
            2'b10 : out_data = io_data;
            default: out_data = 8'b0;
        endcase
    end

endmodule