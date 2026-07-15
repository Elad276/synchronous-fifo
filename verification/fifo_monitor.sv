import uvm_pkg::*;
`include "uvm_macros.svh"

`include "fifo_item.sv"

class fifo_monitor #(parameter WIDTH = 8) extends uvm_monitor;
    `uvm_component_param_utils(fifo_monitor #(WIDTH))
    
    virtual fifo_if #(WIDTH) vif;
    // component that sends transaction to scoreboard
    uvm_analysis_port #(fifo_item #(WIDTH)) monitor_ap;
    
    function new(input string name = "fifo_monitor", uvm_component parent);
        super.new(name, parent);
        monitor_ap = new("monitor_ap", this); 
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_if #(WIDTH))::get(this, "", "vif", vif)) begin
            `uvm_fatal("MON", "Could not get virtual interface for monitor!")
        end
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        fifo_item #(WIDTH) item;
        
        super.run_phase(phase);
 
        forever begin
            // Sample the interface once per clock via the monitor clocking block
            @(vif.mon_cb);
            
            if(!vif.rst_n) begin
                continue;
             end
             
            // Create one transaction per cycle capturing both write/read info
            item = fifo_item#(WIDTH)::type_id::create("mon_item");
            item.w_en     = vif.mon_cb.w_en;
            item.r_en     = vif.mon_cb.r_en;
            item.data_in  = vif.mon_cb.data_in;
            item.data_out = vif.mon_cb.data_out;
            item.is_full  = vif.mon_cb.is_full;
            item.is_empty = vif.mon_cb.is_empty;

            monitor_ap.write(item);
        end
    endtask
endclass