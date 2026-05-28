# Design-and-FPGA-Implementation-of-Approximate-Wallace-Tree-Multipliers-for-Error-Tolerant-Applications

This project implements and compares **20 approximate 8×8 Wallace tree multiplier architectures** on the **Xilinx Zynq-7000 SoC (ZedBoard)** for error-tolerant image processing. Each architecture trades off arithmetic accuracy for gains in power and area — a classic approximate computing tradeoff.

The full evaluation pipeline runs end-to-end in hardware: images are streamed from MATLAB to the FPGA over UART, multiplied using the deployed approximate architecture, and the results are sent back to MATLAB for quality analysis using PSNR and SSIM metrics.

-----

## Why Approximate Multipliers?

Multiplication is one of the most power-hungry and area-intensive operations in digital hardware. In applications like image processing, neural network inference, and signal processing, outputs are either human-perceived or inherently noisy — which means a small amount of arithmetic error is often completely acceptable.

Approximate computing exploits this tolerance. By relaxing the exactness of computation in the least significant bits, we can design multipliers that are significantly cheaper in hardware while producing results that are visually or statistically indistinguishable from exact computation.

This project evaluates how far that tradeoff can be pushed across architectures proposed in recent literature.

-----

## System Overview

```
MATLAB (PC)
    │
    │  sends image pixel pairs over UART
    ▼
ZedBoard (Zynq-7000 SoC)
    │
    ├── uart_rx  →  receives pixel data
    ├── image_multiplier  →  approximate/exact 8×8 multiplication
    └── uart_tx  →  sends 16-bit result back
    │
    ▼
MATLAB (PC)
    │
    └── reconstructs output image → computes PSNR / SSIM → displays comparison
```
The `image_multiplier.v` wrapper instantiates one architecture at a time. Switching architectures requires changing a single line — the rest of the system stays identical.

-----

## Hardware Setup

|Parameter  |Value                           |
|-----------|--------------------------------|
|Board      |Xilinx ZedBoard (Zynq-7000 SoC) |
|Tool       |Vivado 2025.1                   |
|UART TX Pin|PMOD JA Pin 1 (Y11) — FPGA → PC |
|UART RX Pin|PMOD JA Pin 2 (AA11) — PC → FPGA|
|IO Standard|LVCMOS33                        |

-----



## Author

**Shrutipriya Hosmani**  
B.E. Electronics & Communication, Ramaiah Institute of Technology  
[linkedin.com/in/shrutipriyah](https://linkedin.com/in/shrutipriyah) · [github.com/srpah](https://github.com/srpah)