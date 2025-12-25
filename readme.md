2×2 Systolic Array Matrix Multiplier (Verilog)
Overview

This project implements a 2×2 matrix–vector multiplier using a Systolic Array architecture in Verilog HDL.

The design focuses on demonstrating:

Hardware acceleration for linear algebra operations

Fundamental building blocks used in AI accelerators and quantum computing pipelines

Practical techniques for pipelining, parallel processing, and dataflow-oriented design on FPGA

The operation performed is:
```text
| a  b |   | x |   | a*x + b*y |
| c  d | × | y | = | c*x + d*y |
````
System Architecture

The system is composed of a 2×2 grid of Processing Elements (PEs) arranged as a systolic array.

Key Characteristics

Fully parallel computation

Local data reuse

Deterministic data movement

Computation Model

The multiplication is implemented using linear combination of matrix columns:

Each input vector element is multiplied with one column of the weight matrix

Partial sums are accumulated across rows

This avoids centralized accumulation logic and matches systolic design principles.

Weight Loading & Data Flow
Weight Loading (Daisy Chain)

Weights are loaded serially through the array using a daisy-chain mechanism:

PE(0,0) → PE(0,1) → PE(1,0) → PE(1,1)

Advantages

Reduced routing complexity

No address decoder required

Scales naturally for larger arrays

Trade-off

Initialization latency increases with array size

Input Data Streaming

Input vector elements are broadcast to all PEs

One element is processed per clock cycle

Each PE performs a MAC operation every cycle

Processing Element (PE)

Each PE is a self-contained computation unit consisting of:

Weight Register
Stores the matrix coefficient for that PE

Multiply–Accumulate (MAC) Unit
Performs:

sum_out = sum_in + (data_in × weight)

Control Logic

Load mode: shifts and stores weights

Compute mode: performs MAC operations

The PE is fully modular and reusable.

Top Module: 2×2 Systolic Array
Inputs

Clock and reset

Serial weight input

Streamed vector input

Load enable signal

Outputs

Two parallel outputs corresponding to:

Result Row 0

Result Row 1

Data Movement Summary

Input Vector  → Broadcast to all PEs
Weights       → Shifted serially (daisy chain)
Partial Sums  → Accumulated left-to-right per row

Verification & Simulation

The design is verified using ModelSim with an automated testbench.

Test Case

Matrix:
```text
| 2  3 |
| 4  5 |
````
Vector:
```text
| 10 |
| 20 |
````
Expected result:
```text
|  80 |
| 140 |
````
Simulation Procedure

1. Loading Phase

Assert load_en

Stream weights in order:

2 → 3 → 4 → 5

2. Streaming Phase

Apply input vector:
x = 10
y = 20

3. Checking Phase

Sample outputs immediately after the final input

Expected:
Row 0 =  80
Row 1 = 140

Key Insights & Design Notes
Pipeline Latency

The architecture is fully pipelined

Valid output appears immediately after the last input element

Introducing idle cycles without valid/hold control may cause:

Garbage data propagation

Partial sum corruption

Daisy Chain Efficiency

Saves routing resources on FPGA

Ideal for systolic and array-based designs

Initialization latency is linear with array size

Scalability

PE is fully modular

Architecture can be extended to:

4×4

8×8

Larger systolic arrays

Only requires PE replication and structured interconnect

File Structure
.
├── mini_systolic_pe.v     # RTL for a single Processing Element
├── systolic_2x2.v         # Top module (2×2 systolic array)
├── tb_systolic_2x2.v      # Testbench for functional verification

Conclusion

This project presents a clean and scalable implementation of a systolic array matrix multiplier in Verilog.
It serves as a solid foundation for:

FPGA-based matrix accelerators

CNN and linear algebra hardware

Advanced systolic architectures used in modern AI chips

The design emphasizes modularity, dataflow clarity, and scalability, making it suitable for both learning and extension.