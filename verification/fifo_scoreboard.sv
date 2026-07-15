import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_scoreboard #(parameter WIDTH = 8, parameter DEPTH = 16) extends uvm_scoreboard;
        `uvm_component_param_utils(fifo_scoreboard #(WIDTH, DEPTH))

        uvm_analysis_imp #(fifo_item #(WIDTH), fifo_scoreboard #(WIDTH, DEPTH)) scoreboard_ap;
        
        logic [WIDTH-1:0] e_que[$];    // expected queue
        logic [WIDTH-1:0] pending_data;
        bit read_active = 0;     // flag to indicate read happened last cycle
        
        function new(input string name = "fifo_scoreboard", uvm_component parent);
            super.new(name, parent);
            scoreboard_ap = new("scoreboard_ap", this);
        endfunction
        
        function void write(fifo_item #(WIDTH) item);
            logic [WIDTH-1:0] e_data;    // expected data
            int unsigned depth_before;
            bit expected_full_before;
            bit expected_empty_before;
            
            // Compute expected flags based on model state *before* this cycle,
            // to match DUT use of count for is_full/is_empty.
            depth_before          = e_que.size();
            expected_full_before  = (depth_before == DEPTH);
            expected_empty_before = (depth_before == 0);
            
            // Write Logic (model from expected flags, not DUT flags)
            if (item.w_en && !expected_full_before) begin
                e_que.push_back(item.data_in);
                `uvm_info("SCB_WRITE", $sformatf("Stored: %0h. Queue size: %0d", item.data_in, e_que.size()), UVM_LOW)
            end
            
            // Read Logic (also based on expected_empty_before)
            if (item.r_en && !expected_empty_before) begin
                if (e_que.size() > 0) begin
                    e_data = e_que.pop_front();
                    if(item.data_out === e_data) begin
                        pending_data = e_que.pop_front();
                        read_active = 1;
                        `uvm_info("SCB_PASS", $sformatf("Match! Data: %0h", item.data_out), UVM_LOW)
                    end else begin
                        `uvm_error("SCB_FAIL", $sformatf("Mismatch! RTL: %0h, Expected: %0h", item.data_out, e_data))
                    end
                end else begin
                    // if read enable and rtl queue is not empty but scoreboard queue IS empty
                    `uvm_error("SCB_EMPTY", "RTL performed read but Scoreboard queue is empty!")
                end
            end
            
            check_status(item, expected_full_before, expected_empty_before);
        endfunction
        
        virtual function void check_status(fifo_item #(WIDTH) item,
                                           bit expected_full_before,
                                           bit expected_empty_before);
            if(item.is_full !== expected_full_before)
                `uvm_error("SCB_FULL", "Full flag mismatch")
            if(item.is_empty !== expected_empty_before)
                `uvm_error("SCB_EMPTY", "Empty flag mismatch")
        endfunction
endclass
