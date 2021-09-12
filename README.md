## The ZAP Soft Processor (ARMv5T Compatible)

#### Author        : Revanth Kamaraj (revanth91kamaraj@gmail.com)

### Introduction 

The ZAP processor is a 10 stage pipelined processor for FPGA with support for cache and MMU (ARMv5T compliant). 

#### Features 

##### ZAP Processor (zap_top.v)

The ZAP core is a pipelined ATMv5T processor for FPGA.

| Property              | Description             |
|-----------------------|-------------------------|
|HDL                    | Verilog-2001            |
|Author                 | Revanth Kamaraj         |
|ARM v5T ISA Support    | Fully compatible        |
|Branch Predictor       | Direct mapped bimodal   |
|Write Buffer           | Yes                     |
|Abort Model            | Base Restored           |
|Integrated v5T CP15    | Yes                     |
|External Coproc. Bus   | No                      |
|Cache Interface        | 128-Bit custom interface|
|26-Bit Support         | No                      |
|L1 Code Cache          | Direct mapped virtual   |
|L1 Data Cache          | Direct mapped virtual   |
|Cache Write Policy     | Writeback               |
|L1 Code TLB            | Direct mapped           |
|L1 Data TLB            | Direct mapped           |
|Bus Interface          | 32-bit Wishbone B3 Linear incrementing burst |
|Cache/TLB Lock Support | No                      |
|CP15 Compliance        | v5T (No fine pages)     |
|FCSE Support           | Yes                     |

 * 10-stage pipeline design. Pipeline has bypass network to resolve dependencies. Most operations execute at a rate of 1 operation per clock.
 * 2 write ports for the register file to allow LDR/STR with writeback to execute as a single instruction.

#### CPU Configuration (zap_top.v)

| Parameter                | Default| Description |
|--------------------------|--------|-------------|
| BP_ENTRIES               |  1024 | Branch Predictor Settings. Predictor RAM depth. Must be 2^n and > 2 |
| FIFO_DEPTH               |  4    | Branch Predictor Settings. Command FIFO depth. Must be 2^n and > 2  |
| STORE_BUFFER_DEPTH       | 16    | Branch Predictor Settings. Depth of the store buffer. Must be 2^n and > 2 |
| DATA_SECTION_TLB_ENTRIES |  4    | Data Cache/MMU Configuration. Section TLB entries. Must be 2^n (n > 0) |
| DATA_LPAGE_TLB_ENTRIES   |  8    | Data Cache/MMU Configuration. Large page TLB entries. Must be 2^n (n > 0) |
| DATA_SPAGE_TLB_ENTRIES   |  16   | Data Cache/MMU Configuration. Small page TLB entries. Must be 2^n (n > 0) |
| DATA_CACHE_SIZE          |  1024 | Data Cache/MMU Configuration. Cache size in bytes. Must be at least 256B and 2^n |
| CODE_SECTION_TLB_ENTRIES |  4    | Instruction Cache/MMU Configuration. Section TLB entries. Must be 2^n (n > 0) |
| CODE_LPAGE_TLB_ENTRIES   |  8    | Instruction Cache/MMU Configuration. Large page TLB entries. Must be 2^n (n > 0) |
| CODE_SPAGE_TLB_ENTRIES   |  16   | Instruction Cache/MMU Configuration. Small page TLB entries. Must be 2^n (n > 0) |
| CODE_CACHE_SIZE          |  1024 | Instruction Cache/MMU Configuration. Cache size in bytes. Must be at least 256B and 2^n |

#### CPU IO Interface (zap_top.v)
 
Wishbone B3 compatible 32-bit bus.

|        Dir    | Size     | Port               | Description                      | 
|---------------|----------|--------------------|----------------------------------|
|        input  |          | i_clk              |  Clock                           |     
|        input  |          | i_reset            |  Reset                           |
|        input  |          | i_irq              |  Interrupt. Level Sensitive.     |
|        input  |          | i_fiq              |  Fast Interrupt. Level Sensitive.|
|        output |          |  o_wb_cyc          |  Wishbone B3 Signal              |
|        output |          |  o_wb_stb          |  WIshbone B3 signal              |
|        output | [31:0]   |  o_wb_adr          |  Wishbone B3 signal.             |
|        output |          |  o_wb_we           |  Wishbone B3 signal.             |
|        output | [31:0]   |  o_wb_dat          |  Wishbone B3 signal.             |
|        output | [3:0]    |  o_wb_sel          |  Wishbone B3 signal.             |
|        output | [2:0]    |  o_wb_cti          |  Wishbone B3 signal. Cycle Type Indicator (Supported modes: Incrementing Burst, End of Burst)|
|        output | [1:0]    |  o_wb_bte          |  Wishbone B3 signal. Burst Type Indicator (Supported modes: Linear)                          |
|        input  |          |  i_wb_ack          |  Wishbone B3 signal.             |
|        input  | [31:0]   |  i_wb_dat          |  Wishbone B3 signal.             |
|        output |          |   o_wb_stb_nxt     | IGNORE THIS PORT. LEAVE OPEN.    |  
|        output |          |   o_wb_cyc_nxt     | IGNORE THIS PORT. LEAVE OPEN.    |
|        output |   [31:0] |   o_wb_adr_nxt     | IGNORE THIS PORT. LEAVE OPEN.    |


### Getting Started 
*Tested on Ubuntu 16.04 LTS/18.04 LTS*

#### Run Sample Tests

Let the variable $test_name hold the name of the test. See the src/ts directory for some basic tests pre-installed. Available test names are: factorial, arm_test, thumb_test, uart. New tests can be added using these as starting templates. Please note that these will be run on the SOC platform (chip_top) that consist of the ZAP processor, 2 x UARTs, a VIC and a timer.

```bash
sudo apt-get install sudo apt-get install gcc-arm-none-eabi binutils-arm-none-eabi gdb openocd iverilog gtkwave make perl xterm
cd $PROJ_ROOT/src/ts/$test_name # $PROJ_ROOT is the project directory.
make # Runs the test using IVerilog.
cd $PROJ_ROOT/obj/ts/$test_name # Switch to object folder.
gvim zap.log.gz    # View the log file
gtkwave zap.vcd.gz # Exists if selected by Config.cfg. See PDF document for more information.
```
To use this processor in your SOC, instantiate this top level CPU module in your project: [CPU top file](/src/rtl/cpu/zap_top.v)

### Implementation Specific Details

#### FPGA Timing Performance (Vivado, Retime Enabled)

| FPGA Part          | Speed |  Critical Path |
|--------------------|-------|----------------|
| xc7a35tiftg256-1L  | 80MHz | Cache access   |

#### Coprocessor #15 Control Registers

##### Register 0 : ID Register

|Bits | Name    | Description                              |
|-----|---------|------------------------------------------|
|31:0 | Various | Processor ID info.                       |

##### Register 1 : Control

|Bits | Name      | Description                              |
|-----|-----------|------------------------------------------|
|0    | M         | MMU Enable. Active high                  |
|1    | A         | Always 0. Alignment check off            |
|2    | D         | Data Cache Enable. Active high           |
|3    | W         | Always 1. Write Buffer always on.        |
|4    | P         | Always 1. RESERVED                       |
|5    | D         | Always 1. RESERVED                       |
|6    | L         | Always 1. RESERVED                       |
|7    | B         | Always 0. Little Endian                  |
|8    | S         | The S bit                                |
|9    | R         | The R bit                                |
|11   | Z         | Always 1. Branch prediction enabled      |
|12   | I         | Instruction Cache Enable. Active high    |
|13   | V         | Normal Exception Vectors. Always 0       |
|14   | RR        | Always 1. Direct mapped cache.           |
|15   | L4        | Always 0. Normal behavior.               |

##### Register 2 : Translation Base Address

|Bits | Name      | Description                              |
|-----|-----------|------------------------------------------|
|13:0 | M         | Preserve value.                          |
|31:14| TTB       | Upper 18-bits of translation address     |

##### Register 3 : Domain Access Control (X=0 to X=15)

|Bits     | Name      | Description                              |
|---------|-----------|------------------------------------------|
|2X+1:2X  | DX        | DX access permission.                    |

##### Register 5 : Fault Status Register

|Bits | Name      | Description                              |
|-----|-----------|------------------------------------------|
|3:0  | Status    | Status.                                  |
|1:0  | Domain    | Domain.                                  |
|11:8 | SBZ       | Always 0. RESERVED                       |

##### Register 6 : Fault Address Register

|Bits | Name      | Description                              |
|-----|-----------|------------------------------------------|
|31:0 | Addr      | Fault Address.                           |

##### Register 7 : Cache Functions

| Opcode2     |  CRm            | Description                         |
|-------------|-----------------|-------------------------------------|
|         000 |         0111    |         Flush all caches.           |
|         000 |         0101    |         Flush I cache.              |
|         000 |         0110    |         Flush D cache.              |
|         000 |         1011    |         Clean all caches.           |
|         000 |         1010    |         Clean D cache.              |
|         000 |         1111    |         Clean and flush all caches. |
|         000 |         1110    |         Clean and flush D cache.    |
|       Other |        Other    |         Clean and flush ALL caches  |


##### Register 8 : TLB Functions

|Opcode2 |        CRm    |        Description      |
|--------|---------------|-------------------------|
|    000 |        0111   |        Flush all TLBs   |
|    000 |        0101   |        Flush I TLB      |
|    000 |        0110   |        Flush D TLB      |
|   Other|        Other  |        Flush all TLBs   |

##### Register 13 : FCSE Extentions

| Field | Description |
|-------|-------------|
| 31:25 | PID         |

##### Lockdown Support
* CPU memory system does not support lockdown.

##### Tiny Pages
* No support for tiny pages (1KB).
