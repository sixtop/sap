# SAP v1 architecture

## Ring Counter
#### These are the schematics for the ring counter. It produces 6 different T-states (3 for the fetch cycle, 3 for execution cycle).
![Schematics](img/ring_counter_2.PNG "Ring counter schematics")


#### Timing signals
![Timing signals](img/ring_counter.PNG "Timing signals")



## Instruction Set
* LDA - Load the accumulator
* ADD - Add
* SUB - Substraction
* OUT - Output
* HLT - Halt

## Fetch cycle
Fetch cycle is composed of 3 T-states:
### Address State (T1)
During this state, the Program Counter (PC) is transferred to the Memory Address Register (MAR) via the system bus. Both Ep and ~Lm are active in this state.

### Increment State (T2)
The program counter (PC) is incremented. Only the Cp bit is active.

### Memory State (T3)
The addressed RAM instruction (currently on the bus) is transferred from the memory to the instruction register. The active control bits are ~CE and ~Li.

## Execution cycle
### LDA routine
### ADD routine
### SUB routine
### HLT routine

## Control Word CON
* Cp - Increments program counter. Only active in Increment State (T2)
* Ep - Enables output for the Program Counter module. Only active in Address State (T1)
* ~Lm
* ~CE

* ~Li
* ~Ei
* ~La
* Ea

* Su
* Eu
* ~Lb
* ~Lo
