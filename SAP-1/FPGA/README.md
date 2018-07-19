# FPGA Design for SAP-1

There are few architectural changes to make SAP-1 architecture FPGA compliant. One of them is that we cannot have 3-state buses in our FPGA design. to overcome this limitation, we use multiplexed inputs using the appropiate Control Word signals.
