`include "uvm_macros.svh"
import uvm_pkg::*;

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
        super.run_phase(phase);
        $display("Start monitor run phase");
        
        // we will use queue to ensure the readability of 2 consecutive read (latency of 1 cycle for data_out)
        fifo_item #(WIDTH) item_to_fill;       // current item
        fifo_item #(WIDTH) item_to_report;     // item that was read in previus clock 
        fifo_item #(WIDTH) read_queue[$];      // queue of items

        forever begin
            @(posedge vif.mon_cb);

        // handels read data from queue
            if (read_queue.size() > 0) begin
                item_to_report = read_queue.pop_front(); // next item in queue
                item_to_report.data_out = vif.mon_cb.data_out;
                monitor_ap.write(item_to_report);
            end
        
        // write is handle immedietly 
            if (vif.mon_cb.w_en && !vif.mon_cb.full) begin
                fifo_item #(WIDTH) write_item;
                write_item = fifo_item#(WIDTH)::type_id::create("write_item");
                write_item.w_en = vif.mon_cb.w_en;
                write_item.data_in = vif.mon_cb.data_in;
                write_item.full = vif.mon_cb.full;
                write_item.empty = vif.mon_cb.empty;

                monitor_ap.write(write_item);
            end

        // read stores in item and send him to queue
            if (vif.mon_cb.r_en && !vif.mon_cb.empty) begin
                item_to_fill = fifo_item#(WIDTH)::type_id::create("item_to_fill");
                item_to_fill.r_en = vif.mon_cb.r_en;
                item_to_fill.full = vif.mon_cb.full;
                item_to_fill.empty = vif.mon_cb.empty;
            
                read_queue.push_back(item_to_fill);
            end
                
            `uvm_info("MON", $sformatf("Captured Item: %s", item.convert2String()), UVM_LOW)
        end
    endtask
endclass
    
    