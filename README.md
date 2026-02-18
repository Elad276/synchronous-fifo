# Synchronous FIFO Design
## Overview
Thi s repository contains a professional implementation of a **Synchronous FIFO** (First-In-First-Out) buffer, designed in SystemVerilog. The module is intended to be a reusable building block for digital systems, focusing on robust flag logic and overflow/underflow protection.

## Features
* **Fully Parameterized: Configurable DATA_WIDTH and FIFO_DEPTH.
* **Synchronous Operation: Single clock domain for write and read operations.
* **Status Flags: Includes full and empty indicators.
* **Robust Control: Internal gating logic to prevent data corruption during overflow or underflow conditions.

## Architecture
The design utilizes a circular buffer approach with the following components:
* **Memory Array: Implemented using a register-based array (logic).
* **Pointers: Independent write and read pointers with automatic wrap-around.
* **Counter-Based Logic: A dedicated internal counter manages the status flags to ensure reliability.

## Technical Specifications
| Parameter | Default Value | Description |
| :--- | :--- | :--- |
| WIDTH | 8 | Bit-width of each data word. |
| DEPTH | 16 | Number of words the FIFO can store. |

## Current Status
- [x] **RTL Design:** Completed and optimized.
- [ ] **Functional Verification:** In Progress (Planned to be implemented using UVM).

## Roadmap
1.  **Phase 1 (Done):** RTL implementation and synthesis check in Vivado.
2.  **Phase 2 (Next):** Building a comprehensive verification environment. 
3.  **Phase 3:** Performance analysis and coverage-driven verification.
