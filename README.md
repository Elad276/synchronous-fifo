# FIFO Verification using UVM

## Project Overview

This project implements a complete **UVM (Universal Verification Methodology)** verification environment for a parameterized synchronous FIFO written in SystemVerilog.

The project was developed as a personal learning project with the goal of gaining practical experience in modern ASIC Design Verification methodologies used throughout the semiconductor industry.

The verification environment was built from scratch and demonstrates a modular, reusable UVM architecture including constrained-random stimulus generation, transaction-level modeling, monitoring, functional checking, and scoreboarding.

> **Note:** This project is still under development. Additional verification features and improvements are planned.

---

# Verification Goals

The primary verification objectives are:

- Verify FIFO write operations
- Verify FIFO read operations
- Verify simultaneous read and write transactions
- Verify correct Full and Empty flag behavior
- Compare DUT outputs against an independent reference model
- Build a reusable and scalable UVM verification environment

---

# DUT Description

The Design Under Test (DUT) is a parameterized synchronous FIFO.

### Features

- Parameterized data width
- Parameterized FIFO depth
- Asynchronous active-low reset
- Write operation
- Read operation
- Simultaneous Read + Write support
- Full flag generation
- Empty flag generation
- Internal memory array
- Read pointer
- Write pointer
- FIFO occupancy counter

---

# Verification Architecture

```
                 +----------------------+
                 |      fifo_test       |
                 +----------+-----------+
                            |
                            v
                 +----------------------+
                 |   fifo_environment   |
                 +----------+-----------+
                            |
          +-----------------+----------------+
          |                                  |
          v                                  v
 +------------------+              +-------------------+
 |    fifo_agent    |              | fifo_scoreboard   |
 +--------+---------+              +-------------------+
          |
  +-------+-------+
  |               |
  v               v
Driver         Monitor
  |               |
  +-------+-------+
          |
      fifo_if
          |
          v
        DUT FIFO
```

The verification environment follows the standard layered UVM architecture, separating stimulus generation, driving, monitoring, and checking into independent reusable components.

---

# Project Structure

```
project_root/
│
├── rtl/
│   └── design.sv
│
├── interface/
│   └── fifo_if.sv
│
├── verification/
│   ├── fifo_agent.sv
│   ├── fifo_driver.sv
│   ├── fifo_environment.sv
│   ├── fifo_item.sv
│   ├── fifo_monitor.sv
│   ├── fifo_pkg.sv
│   ├── fifo_scoreboard.sv
│   ├── fifo_sequence.sv
│   ├── fifo_sequencer.sv
│   └── fifo_test.sv
│
└── tb/
    └── tb_top.sv
```

---

# Implemented Features

### UVM Components

- Test
- Environment
- Agent
- Driver
- Monitor
- Sequencer
- Sequence
- Transaction (Sequence Item)
- Scoreboard
- Interface

### Constrained-Random Verification

Random FIFO transactions are generated using SystemVerilog constraints.

Supported transaction types include:

- Write
- Read
- Simultaneous Read & Write

Weighted randomization is used to improve scenario diversity during simulation.

---

### Reference Model

The scoreboard contains an independent FIFO reference model implemented using a SystemVerilog queue.

It performs:

- Expected data tracking
- Output comparison
- Full flag verification
- Empty flag verification

Whenever a mismatch is detected, the scoreboard reports an error indicating the expected and actual behavior.

---

### Transaction Monitoring

The monitor samples DUT activity through the virtual interface and publishes transactions using UVM Analysis Ports.

This allows the scoreboard to perform functional checking without directly interacting with the DUT.

---

# Current Status

## Completed

- FIFO RTL implementation
- Complete UVM verification environment
- Constrained-random sequence generation
- Driver implementation
- Monitor implementation
- Scoreboard with independent reference model
- Data comparison
- Full/Empty flag verification
- Modular package organization

## Work In Progress

The project is currently being expanded with additional verification capabilities.

Planned improvements include:

- Functional Coverage
- SystemVerilog Assertions (SVA)
- Directed test scenarios
- Multiple UVM test classes
- Corner-case verification
- Regression support
- Improved constrained-random stimulus

---

# Skills Demonstrated

This project demonstrates practical experience with:

- SystemVerilog
- Universal Verification Methodology (UVM)
- Constrained-Random Verification
- Transaction-Level Modeling (TLM)
- Driver/Monitor architecture
- Scoreboard development
- Reference model implementation
- Functional checking
- Modular verification environment design
- RTL verification methodology

---

# Future Improvements

The long-term goal is to extend the project toward a more complete industry-style verification environment by adding:

- Functional Coverage
- Coverage-driven verification
- SystemVerilog Assertions (SVA)
- Additional directed and random tests
- Virtual Sequences
- Factory Overrides
- Automated regression flow
- Improved documentation

---

# About

This project was developed as part of my self-learning journey of Design Verification and UVM.

The objective is to gain practical experience with verification methodologies commonly used in the semiconductor industry while building a reusable verification environment that can continue to evolve over time.