`ifndef FIFO_SEQUENCER_SV
`define FIFO_SEQUENCER_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

typedef class fifo_item;

class fifo_sequencer #(parameter WIDTH = 8) extends uvm_sequencer #(fifo_item #(WIDTH));
    `uvm_component_param_utils(fifo_sequencer #(WIDTH))

    function new(input string name = "fifo_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

`endif