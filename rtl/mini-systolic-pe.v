module processing_element #(
    parameter DATA_WIDTH = 16
)(
    input wire clk,
    input wire rst_n,
    input load_en,
    input signed [DATA_WIDTH-1:0] data_in,
    input signed [DATA_WIDTH*2-1:0] sum_in,
    input signed [DATA_WIDTH-1:0] weight_in,
    output signed [DATA_WIDTH-1:0] weight_out,
    output reg signed [DATA_WIDTH*2-1:0] sum_out
);
    // Weight register
    reg signed [DATA_WIDTH:0] weight_reg;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            weight_reg <=0;
            sum_out <=0;
        end else begin
            // Insert Daisy Chain Logic Here
            if(load_en) begin
                weight_reg <= weight_in;
                sum_out <= sum_in;
            end else begin
                sum_out <= sum_in + (data_in * weight_reg);
            end
        end
    end
    assign weight_out = load_en ? weight_reg : 0;
endmodule