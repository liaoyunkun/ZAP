## The ZAP Soft Processor (ARMv4T Compatible)

#### Author        : Revanth Kamaraj (revanth91kamaraj@gmail.com)

### Description 

ZAP is a pipelined soft processor for FPGA that integrates:
* A 10-stage pipelined ARMv4T software compliant core (ZAP core)
* A (CP15 software compliant) cache controller with integrated cache RAMs (inference, block RAMs)
* A (CP15 software compliant) VM controller with integrated cache RAMs (inference, block RAMs)

### Top Level Modules

* Note that zap_top.v is the processor top level (What you probably need i.e., integrates the core, cache and MMU).
* chip_top.v is the SOC top level that integrates the ZAP processor, 2 x timers, a UART and a VIC. The SOC fabric is extendable.

### Instruction Sets Supported

* 16/32-bit ARM v4T ISA support 
* Integrated CP15 coprocessor (v4T compliant Cache Controller and MMU)
* Limited v5T support. 
  * From the v5T ISA, only supports CLZ and BLX instructions.

### CPU Configuration (zap_top.v)
```C
// BP entries, FIFO depths

parameter        BP_ENTRIES              = 1024, // Predictor RAM depth. Must be 2^n and > 2.
parameter        FIFO_DEPTH              = 4,    // Command FIFO depth. Must be 2^n and > 2.
parameter        STORE_BUFFER_DEPTH      = 16,   // Depth of the store buffer. Must be 2^n and > 2.

// Data MMU/Cache configuration.

parameter [31:0] DATA_SECTION_TLB_ENTRIES =  4,    // Section TLB entries. Must be 2^n (n > 0).
parameter [31:0] DATA_LPAGE_TLB_ENTRIES   =  8,    // Large page TLB entries. Must be 2^n (n > 0).
parameter [31:0] DATA_SPAGE_TLB_ENTRIES   =  16,   // Small page TLB entries. Must be 2^n (n > 0).
parameter [31:0] DATA_CACHE_SIZE          =  1024, // Cache size in bytes. Must be at least 256B and 2^n.

// Code MMU/Cache configuration.

parameter [31:0] CODE_SECTION_TLB_ENTRIES =  4,    // Section TLB entries. Must be 2^n (n > 0).
parameter [31:0] CODE_LPAGE_TLB_ENTRIES   =  8,    // Large page TLB entries. Must be 2^n (n > 0).
parameter [31:0] CODE_SPAGE_TLB_ENTRIES   =  16,   // Small page TLB entries. Must be 2^n (n > 0).
parameter [31:0] CODE_CACHE_SIZE          =  1024  // Cache size in bytes. Must be at least 256B and 2^n.
```

### Bus Interface 
 
Wishbone B3 compatible 32-bit bus.

### Getting Started (Tested on Ubuntu 16.04 LTS/18.04 LTS)

Let the variable $test_name hold the name of the test. See the src/ts directory for some basic tests pre-installed. Available test names are: factorial, arm_test, thumb_test, uart. New tests can be added using these as starting templates. Please note that these will be run on the SOC platform (chip_top) that consist of the ZAP processor, 2 x UARTs, a VIC and a timer.

```bash
sudo apt-get install sudo apt-get install gcc-arm-none-eabi binutils-arm-none-eabi gdb openocd iverilog gtkwave
cd $PROJ_ROOT/src/ts/$test_name # $PROJ_ROOT is the project directory.
make # Runs the test using IVerilog.
cd $PROJ_ROOT/obj/ts/$test_name
gvim zap.log.gz    # View the log file
gtkwave zap.vcd.gz # Exists if selected by Config.cfg. See PDF document for more information.
```
To use this processor in your SOC, instantiate this top level CPU module in your project: [CPU top file](/src/rtl/cpu/zap_top.v)

### Running FPGA Synthesis (Requires Vivado toolchain to be installed, Tested on Ubuntu 16.04 LTS/18.04 LTS)

Download and install Vivado WebPACK from https://www.xilinx.com/member/forms/download/xef-vivado.html?filename=Xilinx_Vivado_SDK_Web_2018.3_1207_2324_Lin64.bin 
```bash
cd $PROJ_ROOT/src/synth/vivado/  # $PROJ_ROOT is the project directory.
source run_synth.sh              # Targets 80MHz on Xiling FPGA part xc7a35tiftg256-1L.
```

### Timing Performance

| FPGA Part          | Speed |  Critical Path |
|--------------------|-------|----------------|
| xc7a35tiftg256-1L  | 80MHz | Cache access   |

### Specifications 

| Property              | Description             |
|-----------------------|-------------------------|
|HDL                    | Verilog-2001            |
|ARM v4T ISA Support    | Fully compatible        |
|ARM v5T ISA Support    | Only BLX, CLZ supported |
|L1 Code Cache          | Direct mapped virtual   |
|L1 Data Cache          | Direct mapped virtual   |
|Cache Write Policy     | Writeback               |
|Branch Predictor       | Direct mapped bimodal   |
|L1 Code TLB            | Direct mapped           |
|L1 Data TLB            | Direct mapped           |
|Cache/TLB Lock Support | No                      |
|Write Buffer           | Yes                     |
|Memory Interface       | 32-bit Wishbone B3      |
|Abort Model            | Base Restored           |
|Integrated v4T CP15    | Yes                     |
|External Coproc. Bus   | No                      |

 * 10-stage pipeline design. Pipeline has bypass network to resolve dependencies. Most operations execute at a rate of 1 operation per clock.
 * 2 write ports for the register file to allow LDR/STR with writeback to execute as a single instruction.

                                                                    

