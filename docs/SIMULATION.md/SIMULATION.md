# Simulation Guide

## Prerequisites

### Icarus Verilog (Recommended)
Install on macOS:
```bash
brew install icarus-verilog
```

Install on Linux (Ubuntu/Debian):
```bash
sudo apt-get install iverilog
```

Install on Windows:
Download from [iverilog.icarus.com](http://iverilog.icarus.com)

### GTKWave (for VCD visualization)
```bash
brew install gtkwave  # macOS
sudo apt-get install gtkwave  # Linux
```

## Running the Simulation

### Step 1: Compile
From the repository root:
```bash
iverilog -o simon_sim src/*.v test/SimonTest.v
```

This compiles all source files in `src/` and the testbench `SimonTest.v` into an executable named `simon_sim`.

### Step 2: Run
```bash
vvp simon_sim
```

The simulation will execute and produce output in your terminal showing:
- Mode transitions (INPUT -> PLAYBACK -> REPEAT -> DONE)
- Assertion results (FAILURE messages if tests fail)
- Total error count at the end

### Step 3: View Waveforms (Optional)
If you want to inspect signals in detail:

```bash
vvp simon_sim -vcd
```

This generates a `SimonTest.vcd` file. View it with:
```bash
gtkwave SimonTest.vcd &
```

In GTKWave, expand the module hierarchy on the left and drag signals into the waveform viewer.

## Expected Output

A successful run should show:
```
=====================================
     Starting Simon Testbench
=====================================

Entering Mode: Unknown
Setting rst to 1...
Pressing uclk...

Entering Mode: Input
Setting rst to 0...
Mode should be input after reset!
Pattern LEDs should match switches in input mode!
...

TESTS COMPLETED (0 FAILURES)
```

If you see FAILURE messages, there's a mismatch in the logic or interface.

## File Descriptions

| File | Purpose |
|------|----------|
| src/Simon.v | Top-level module |
| src/SimonDatapath.v | Datapath (memory, counters, comparators) |
| src/SimonControl.v | Controller (FSM) |
| src/SimonMemory.v | 64-entry 4-bit RAM |
| test/SimonTest.v | Testbench driving full game scenarios |
