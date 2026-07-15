import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_sequencer #(parameter WIDTH = 8) extends uvm_sequencer #(fifo_item #(WIDTH));
    `uvm_component_param_utils(fifo_sequencer #(WIDTH))

    function new(input string name = "fifo_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction
endclass
