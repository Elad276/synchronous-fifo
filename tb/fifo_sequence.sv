`ifndef FIFO_SEQUENCE_SV
`define FIFO_SEQUENCE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

typedef class fifo_item;

class fifo_sequence #(parameter WIDTH = 8) extends uvm_sequence #(fifo_item #(WIDTH));
    `uvm_object_param_utils(fifo_sequence #(WIDTH))

    function new(string name = "fifo_sequence");
        super.new(name);
    endfunction

    task body();
        fifo_item #(WIDTH) item;
        repeat(20) begin
            item = fifo_item #(WIDTH)::type_id::create("item");
            start_item(item);
            if (!item.randomize()) begin
                `uvm_fatal("SEQ", "Randomization failed!")
            end
            finish_item(item);
        end
    endtask
endclass

`endif