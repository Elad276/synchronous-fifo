`timescale 1ns/1ps

module design1 #(
    parameter WIDTH = 8, 
    parameter DEPTH = 16 
    )(
       input logic [WIDTH-1:0] data_in,
       input logic w_en, r_en,
       input logic clk, rst_n,
       output logic [WIDTH-1:0] data_out,
       output logic is_full, is_empty
    );

    logic [WIDTH-1:0] fifo_mem [DEPTH-1:0];

    localparam ADDR_WIDTH = $clog2(DEPTH);      //size of DEPTH in binary
    logic [ADDR_WIDTH-1:0] w_ptr;
    logic [ADDR_WIDTH-1:0] r_ptr;
    logic [ADDR_WIDTH:0] count;

    logic can_write;
    logic can_read;

    assign is_full = (count == DEPTH);
    assign is_empty = (count == 0);

    assign can_write = w_en && !is_full;
    assign can_read = r_en && !is_empty;

    // initialize value at reset
    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            w_ptr <= 0;
            r_ptr <= 0;
            count <= 0;
        end

        else begin
            // write to mem
            if(can_write) begin
                fifo_mem[w_ptr] <= data_in;
                w_ptr <= w_ptr + 1'b1;
            end

            // read from mem
            if(can_read) begin
                data_out <= fifo_mem[r_ptr];
                r_ptr <= r_ptr + 1'b1;
            end
            
            // update count
            if(can_write && !can_read)
                count <= count + 1;
            else if (can_read && !can_write)
                count <= count - 1;
        end
    end
endmodule
