import uvm_pkg::*;
`include "uvm_macros.svh"

typedef enum {IDLE, WRITE, READ, WRITE_READ} fifo_op;

class fifo_item #(parameter WIDTH = 8) extends uvm_sequence_item;
    rand bit [WIDTH-1:0] data_in;
    rand fifo_op op;
    bit w_en;
    bit r_en;
    bit [WIDTH-1:0] data_out;
    bit empty;
    bit full;
    
    function new(string name = "fifo_item");
        super.new(name);
    endfunction
    
    function void post_randomize();
        case(op)
            IDLE:       begin w_en = 0; r_en = 0; end
            WRITE:      begin w_en = 1; r_en = 0; end
            READ:       begin w_en = 0; r_en = 1; end
            WRITE_READ: begin w_en = 1; r_en = 1; end
        endcase
    endfunction
    
    `uvm_object_param_utils_begin(fifo_item #(WIDTH))
        `uvm_field_int(data_in, UVM_ALL_ON)
        `uvm_field_int(w_en,    UVM_ALL_ON) 
        `uvm_field_int(r_en,    UVM_ALL_ON)
        `uvm_field_int(data_out,UVM_ALL_ON)
        `uvm_field_int(empty,   UVM_ALL_ON)
        `uvm_field_int(full,    UVM_ALL_ON)
        //`uvm_field_enum(fifo_op, op, UVM_ALL_ON)
    `uvm_object_param_utils_end
     
endclass
