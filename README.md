## *ZAP* : An ARMv4T compatible core with cache and MMU

#### Author        : Revanth Kamaraj (revanth91kamaraj@gmail.com)
#### License       : LGPL v2.1

### Description 

ZAP is a pipelined ARM processor core that can execute the ARMv4T instruction
set. It is equipped with ARMv4 compatible split writeback caches and memory 
management capabilities. The processor core uses a 10 stage pipeline.

### Current Status 

*Very experimental. This was a student project and is no longer being actively developed or maintained.*

### Bugs and Known Issues

 - Issues with the compressed instruction format.  
 - SWAP does not bypass cache.

### Bus Interface 
 
Wishbone B3 compatible 32-bit bus.

### Documentation

Please see the PDF file at *doc/ZAP_PROCESSOR_CORE_DATASHEET.pdf*

### Pre-Requisites

  - Linux based machine.
  - ARM baremetal GCC tools. 
  - Icarus Verilog 10.0 or higher.
  - Make utility.

### Features 

 - Fully synthesizable Verilog-2001 core.    
 - Store buffer for improved performance.    
 - Can execute ARMv4T code. Note that compressed instruction support is experimental.
 - Wishbone B3 compatible interface. Cache unit supports burst access.
 - 10-stage pipeline design. Pipeline has bypass network to resolve dependencies.
 - 2 write ports for the register file to allow LDR/STR with writeback to execute as a single instruction.
 - Branch prediction supported.
 - Split I and D writeback cache (Size can be configured using parameters).
 - Split I and D MMUs (TLB size can be configured using parameters).
 - Base restored abort model to simplify data abort handling.

### License
                    GNU LESSER GENERAL PUBLIC LICENSE
                       Version 2.1, February 1999

 Copyright (C) 1991, 1999 Free Software Foundation, Inc.
 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.

[This is the first released version of the Lesser GPL.  It also counts
 as the successor of the GNU Library Public License, version 2, hence
 the version number 2.1.]
                                                                         

