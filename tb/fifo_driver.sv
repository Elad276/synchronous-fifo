`include "uvm_macros.svh"
import uvm_pkg::*;

class fifo_driver #(parameter WIDTH = 8) extends uvm_driver #(fifo_item #(WIDTH));
    `uvm_component_param_utils(fifo_driver #(WIDTH))
    
    virtual fifo_if #(WIDTH) vif;
    fifo_item #(WIDTH) item;
    
    function new(input string name = "fifo_driver", input uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_if #(WIDTH))::get(this, "", "vif", vif)) begin
            `uvm_fatal("DRV", "Could not get virtual interface!")
        end
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        $display("Start driver run phase");
        
        forever begin
            seq_item_port.get_next_item(item);
            
            @(posedge vif.drv_cb)
            vif.drv_cb.w_en <= item.w_en;
            vif.drv_cb.r_en <= item.r_en;
            vif.drv_cb.data_in <= item.data_in;
             
             seq_item_port.item_done(item);
        end
    endtask
endclass