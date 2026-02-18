interface fifo_if
    #(parameter WIDTH = 8)
    (input logic clk, rst_n);
    logic [WIDTH-1:0] data_in;
    logic [WIDTH-1:0] data_out;
    logic w_en;
    logic r_en;
    logic empty;
    logic full;
    
    clocking drv_cb @(posedge clk);
        default input #1ns output #1ns;  //sample input 1 unit time before clock event and push output 1 unit time after clock event  
        output data_in, w_en, r_en;
        input data_out, empty, full;        
    endclocking
    
    clocking mon_cb @(posedge clk);
    default input #1ns output #1ns;
        input data_in,data_out,w_en,r_en, empty,full;
    endclocking
    
    // modports for driver and monitor
    modport drv_mp(clocking drv_cb, input rst_n);
    modport mon_mp(clocking mon_cb, input rst_n);
    
endinterface
    