`ifndef FIFO_AGENT_SV
`define FIFO_AGENT_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_agent #(parameter WIDTH = 8) extends uvm_agent; 
    `uvm_component_param_utils(fifo_agent #(WIDTH))

    fifo_sequencer #(WIDTH) sqr;
    fifo_driver    #(WIDTH) drv;
    fifo_monitor   #(WIDTH) mon;

 
    uvm_analysis_port #(fifo_item #(WIDTH)) agent_ap;

    function new(input string name = "fifo_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        mon = fifo_monitor #(WIDTH)::type_id::create("mon", this);
        agent_ap = new("agent_ap", this);

        if (get_is_active() == UVM_ACTIVE) begin
            sqr = fifo_sequencer #(WIDTH)::type_id::create("sqr", this);
            drv = fifo_driver    #(WIDTH)::type_id::create("drv", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if (get_is_active() == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);    
        end
        
        mon.monitor_ap.connect(this.agent_ap);
    endfunction
endclass

`endif