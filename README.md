# Traffic Light System

## Overview
This VHDL project implements a traffic light control system, simulating pedestrian crossing and vehicle traffic signals. The design is targeted for FPGA with a primary focus on state machine implementation for traffic light sequencing.

## Key Features
- 🚦 Simulates traffic lights for East-West and North-South directions.
- 🚶 Supports pedestrian crossing requests.
- 🕹️ Includes push-button inputs for pedestrian requests and system reset.
- 🚥 Uses LEDs to display traffic light states.
- 📟 Incorporates a 7-segment display for additional status information.
- ⏱️ Utilizes a clock generator for timing control.

## Entity Description
- `TrafficLightSystem_top`: The top-level entity that defines the input/output ports including the FPGA clock (`clkin_50`), reset (`rst_n`), push-buttons (`pb_n`), switches (`sw`), LED outputs (`leds`), and 7-segment display outputs (`seg7_data`, `seg7_char1`, `seg7_char2`).

## Architecture
- `SimpleCircuit`: Contains the main architecture with component declarations and signal mappings.
- Components:
  - `segment7_mux`: Manages the multiplexing for the 7-segment display.
  - `clock_generator`: Generates clock enable and blink signals.
  - `pb_inverters`: Inverts the active-low push-button signals.
  - `synchronizer`: Synchronizes the push-button signals with the system clock.
  - `holding_register`: Maintains the state of the push-button signals.
  - `Moore_State_Machine`: Implements the traffic light control logic.

- Verify the functionality by simulating various pedestrian requests and observing the state transitions.

## Note
- The project is designed to be modular, allowing easy modifications and extensions.
- Ensure the FPGA pin assignments are correctly configured according to the development board used.
