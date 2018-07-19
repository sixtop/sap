# FPGA Design for SAP-1

There are few architectural changes to make SAP-1 architecture FPGA-compliant. One of them is that we cannot have 3-state buses in our FPGA design. To overcome this limitation, we use multiplexed inputs using the appropiate Control Word signals.

### Makefile
We use the [VCS simulator](https://www.synopsys.com/verification/simulation/vcs.html) from Synopsys. Compiling and launching the simulation with standard 

