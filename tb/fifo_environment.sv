`ifndef FIFO_ENVIRONMENT_SV
`define FIFO_ENVIRONMENT_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

typedef class fifo_agent;
typedef class fifo_scoreboard;

class fifo_environment #(parameter WIDTH = 8, parameter DEPTH = 16) extends uvm_env;
    `uvm_component_param_utils(fifo_environment #(WIDTH, DEPTH))

    fifo_agent #(WIDTH) agent;
    fifo_scoreboard #(WIDTH, DEPTH) scoreboard;

    function new(input string name = "fifo_environment", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agent = fifo_agent #(WIDTH)::type_id::create("agent", this);
        scoreboard = fifo_scoreboard #(WIDTH, DEPTH)::type_id::create("scoreboard", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        agent.agent_ap.connect(scoreboard.scoreboard_ap);
    endfunction
endclass

`endif