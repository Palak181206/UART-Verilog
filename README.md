# UART RTL Design and Simulation using Verilog

## 📌 Project Overview

This project implements a UART (Universal Asynchronous Receiver/Transmitter) using Verilog HDL.

The project was developed and verified through simulation without using an FPGA board. The UART consists of a Baud Rate Generator, Transmitter, Receiver, and Top Module.

## 🚀 Features

- UART communication using Verilog HDL
- 50 MHz system clock
- 9600 baud rate
- 8-bit data transmission
- LSB-first data transmission
- 16× oversampling for UART reception
- Separate TX and RX timing generation
- RTL simulation and waveform verification
- TX-to-RX loopback verification

## 🧩 Project Modules

### 1. Baud Rate Generator

Generates timing ticks required for UART transmission and reception.

- `baud_generator.v`
- `baud_generator_tb.v`

### 2. UART Transmitter

Converts 8-bit parallel data into a serial UART frame.

Frame format:

`START → 8 DATA BITS → STOP`

Files:

- `uart_tx.v`
- `uart_tx_tb.v`

### 3. UART Receiver

Receives serial UART data and converts it back into 8-bit parallel data.

The receiver uses 16× oversampling to sample the incoming data at appropriate timing points.

Files:

- `uart_rx.v`
- `uart_rx_tb.v`

### 4. UART Top Module

Integrates the Baud Rate Generator, UART Transmitter, and UART Receiver into a single UART system.

Files:

- `uart_top.v`
- `uart_top_tb.v`

## 🔗 Final Integration

The complete UART system was integrated and verified using a TX-to-RX loopback connection.

The transmitted data was connected directly to the receiver input and the received output was checked through simulation.

The final integrated simulation was performed using:

- `design.sv`
- `testbench.sv`

## 🧪 Verification

The individual modules were first tested separately using their respective testbenches.

After individual verification, all modules were integrated and the complete UART system was simulated.

The final waveform was verified for:

- UART TX signal
- UART RX signal
- Received data
- Data valid signal
- Correct serial data transmission

## 🛠️ Tools Used

- Verilog HDL
- EDA Playground
- Icarus Verilog
- EPWave

## 📂 Project Structure

```text
UART-Verilog/
│
├── baud_generator.v
├── baud_generator_tb.v
│
├── uart_tx.v
├── uart_tx_tb.v
│
├── uart_rx.v
├── uart_rx_tb.v
│
├── uart_top.v
├── uart_top_tb.v
│
├── design.sv
├── testbench.sv
│
└── README.md




📚 Concepts Used
UART Protocol
Baud Rate Generation
Finite State Machines (FSM)
Serial Communication
Parallel-to-Serial Conversion
Serial-to-Parallel Conversion
16× Oversampling
Verilog RTL Design
Testbench Development
Simulation and Waveform Analysis

AUTHOR :- PALAK SINHA
