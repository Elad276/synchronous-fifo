`ifndef FIFO_TEST_SV
`define FIFO_TEST_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

typedef class fifo_environment;
typedef class fifo_sequence;

class fifo_test #(parameter WIDTH = 8, parameter DEPTH = 16) extends uvm_test;
    `uvm_component_param_utils(fifo_test #(WIDTH, DEPTH))

    fifo_environment #(WIDTH, DEPTH) env;
    virtual fifo_if #(WIDTH) vif;

    function new(input string name = "fifo_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(virtual fifo_if #(WIDTH))::get(this, "", "vif", vif)) begin
            `uvm_fatal("TEST_BUILD", "Could not get virtual interface from config_db")
        end

        env = fifo_environment #(WIDTH, DEPTH)::type_id::create("env", this);
        uvm_config_db  #(virtual fifo_if #(WIDTH))::set(this, "*", "vif", vif);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        fifo_sequence fifo_seq;
        fifo_seq = fifo_sequence #(WIDTH)::type_id::create("fifo_seq");

        phase.raise_objection(this, "Running test");
        $display("Starting Sequence at time %t", $time);
        fifo_seq.start(env.agent.sqr);
        phase.drop_objection(this, "Finished test");
    endtask

endclass

`endif