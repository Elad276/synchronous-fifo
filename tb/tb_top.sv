`timescale 1ns/1ps

`include "uvm_macros.svh"

`include "fifo_item.sv"
`include "fifo_sequence.sv"
`include "fifo_environment.sv"
`include "fifo_test.sv"

module tb_top;
    import uvm_pkg::*;
    //import fifo_pkg::*;
    
    // Parameters
    parameter WIDTH = 8;
    parameter DEPTH = 16;

    // Signals
    logic clk = 0;
    logic rst_n = 0;

    // Clock generation - 100MHz clock
    always #5 clk = ~clk;

    // Reset generation
    initial begin
        rst_n = 0;
        #20;
        rst_n = 1;
    end
    
    // Interface Instantiation
    fifo_if #(WIDTH) f_if(clk, rst_n);

    // DUT Instantiation - Match exactly the design1 order
    design1 #(WIDTH, DEPTH) dut (
        .data_in (f_if.data_in),
        .w_en    (f_if.w_en),
        .r_en    (f_if.r_en),
        .clk     (f_if.clk),      
        .rst_n   (f_if.rst_n),
        .data_out(f_if.data_out),
        .is_full    (f_if.is_full),
        .is_empty   (f_if.is_empty)
    );

    // UVM Configuration and Test Start
    initial begin
        uvm_config_db #(virtual fifo_if #(WIDTH))::set(null, "*", "vif", f_if);
        run_test("fifo_test");
        //#100;
        //$finish;
    end

endmodule