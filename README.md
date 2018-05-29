# SAP-1 architecture
![SAP1 Architecture](img/sap1_architecture.PNG "SAP1 architecture")

## Program counter
//TODO
## Input and MAR
//TODO
## RAM
//TODO
## Instruction Register
//TODO
## Controller-Sequencer
The control unit is the key to a computer's automatic operation. It generates the control words that fetch an execute each instruction, and while each instruction is processed, the computer passes through different timing states (T-states) which are preriods during which register contents change.

Notice that a positive CLK edge occurs midway through each T state.

### Ring Counter
These are the schematics for the ring counter. It produces 6 different T-states (3 for the fetch cycle, 3 for execution cycle).
![Schematics](img/ring_counter_2.PNG "Ring counter schematics")


### Timing signals
![Timing signals](img/ring_counter.PNG "Timing signals")

### Control Word CON
The control word determines how the registers will react to the next positive CLK edge.

* Cp - Increments program counter. Only active in Increment State (T2)
* Ep - Enables output for the Program Counter module. Only active in Address State (T1)
* ~Lm - 
* ~CE

* ~Li
* ~Ei
* ~La
* Ea

* Su
* Eu
* ~Lb
* ~Lo

## Accumulator
//TODO
## Adder-Substracter
//TODO
## Display
//TODO
# Instruction Set
| Mnemonic      | Opcode           | Operation  |
| ------------- |:----------------:| ---------- |
| LDA           | 0000              | Load RAM data into accumulator |
| ADD           | 0001              | Add RAM data to accumulator |
| SUB           | 0010              | Subtract RAM data from accumulator |
| OUT           | 1110              | Load accumulator data into ouput register |
| HLT           | 1111              | Stop processing |

# Fetch cycle
### Address State (T1)
During this state, the Program Counter (PC) is transferred to the Memory Address Register (MAR) via the system bus. Both Ep and ~Lm are active in this state.

### Increment State (T2)
The program counter (PC) is incremented. Only the Cp bit is active.

### Memory State (T3)
The addressed RAM instruction (currently on the bus) is transferred from the memory to the instruction register (IR). The active control bits are ~CE and ~Li.

![Fetch cycle](img/fetch_cycle.PNG "")

# Execution cycle
On the next three states (T4, T5, T6), the register transfers during the execution depend on the particular instruction being executed.
### LDA routine
Example instruction being loaded into IR: LDA 9H

 **IR** = 0000 1001

* During the T4 state, the instruction field (0000) goes to the controller-sequencer, where it is decoded. Also, the address field (1001) is loaded into MAR. ~Ei abd ~Lm are both active in this state.
* During T5, ~CE and ~La go low. This means that the addressed data word in the RAM will be loaded into the accumulator on the next positive clock edge.
* T6 is a no-operation state for the LDA routine, in which all registers are inactive.

![LDA routine](img/LDA_routine.PNG "LDA routine")

![LDA routine](img/LDA_routine_timing.PNG "LDA routine")

### ADD routine
Example instruction being loaded into IR: ADD BH

 **IR** = 0001 1011
 
* During the T4 state, the instruction field (0001) goes to the controller-sequencer, where it is decoded. Also, the address field (1011) is loaded into MAR. ~Ei abd ~Lm are both active in this state.
* Control bits ~CE and ~Lb are active during the T5 state, this allows the addressed RAM word to set up the B register.
* During the T6 state, Eu and ~La bits are active; therefore, the adder-subtracter set up the accumulator.

### SUB routine
The SUB routine is similar to the ADD routine, but during the T6 state, a high Su is also sent to the adder-subtracter.

### OUT routine
* T4: The instruction field goes to the controller-sequencer for decoding, then the controller sequencer sends out the control word needed to load the accumulator contents (Ea) into the output register ~Lo.
* T5: No-op
* T6: No-op

### HLT routine



