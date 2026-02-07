# Simon: Two‑Player Memory Circuit

Two‑player Simon memory game implemented in Verilog, with separate datapath and controller, 64‑entry pattern memory, mode LEDs for Input/Playback/Repeat/Done, and testbenches that verify memory, LED behavior, and full hard‑mode gameplay. [file:117][file:118]

## Overview

This project implements a digital version of the classic Simon memory game as a synchronous RTL design. The circuit supports two players who alternately extend and repeat an ever‑growing sequence of 4‑bit patterns, with the game ending as soon as a player makes an incorrect guess. [file:117]

The design is split into a datapath (memory, registers, comparators, LED logic) and a controller FSM that encodes the game rules and mode transitions, following a high‑level state machine specification from the course lab. [file:117][file:118]

## Game behavior

- Supports **up to 64 stored 4‑bit patterns** in on‑chip memory. [file:117]  
- Two difficulty levels:  
  - Easy – only one‑hot patterns (0001, 0010, 0100, 1000) are legal.  
  - Hard – any 4‑bit pattern is allowed. [file:117]  
- Four main modes, indicated by dedicated mode LEDs:  
  - **Input** – active player appends a new pattern to the sequence.  
  - **Playback** – circuit replays the stored sequence to the other player.  
  - **Repeat** – player attempts to re‑enter the full sequence; a wrong guess ends the game.  
  - **Done** – game is over; players can cycle through the correct stored sequence. [file:117]

## Design structure

- **Datapath:**  
  - 64‑entry, 4‑bit memory module for storing the pattern sequence.  
  - Registers and counters for current index, sequence length, and mode‑dependent behavior.  
  - Logic for switching pattern LEDs between live switch input and stored sequence output. [file:117][file:118]

- **Controller (FSM):**  
  - Encodes the high‑level state machine for Input, Playback, Repeat, and Done modes.  
  - Generates control signals for memory access, counters, legality checking, and LED selection.  
  - Handles synchronous reset, level capture at game start, and all transitions on button presses. [file:117][file:118]

## Testing

- **Module‑level testbenches** for the datapath and controller:  
  - Datapath tests verify correct pattern writes/reads and LED output selection.  
  - Controller tests cover reset behavior, state transitions, and control outputs per state. [file:118]  

- **Top‑level Simon testbench:**  
  - Drives clock, reset, level, and pattern inputs to exercise complete games in hard mode.  
  - Checks correct operation in Input, Playback, Repeat, and Done modes, including both correct and incorrect guesses. [file:118]
