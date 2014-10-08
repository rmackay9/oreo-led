Lighting Module Driver Firmware
===

Firmware implementation of the aircraft lighting system. 
Commands to the system are transmitted via a common I2C bus, 
connecting all lighting units (slave devices) with the 
Pixhawk (as master transmitter). 

Overview
---

### Hardware
This firmware is designed to run on the Atmel ATTiny88 and was
programmed via the Dragon ISP programmer. See the `/doc` folder for
more information.

### System Architecture 
The software is broken into modules and their interaction is depicted by the
following diagram:

        +------------------+        +----------------+
        |                  |  tick  |                |
        |                  < - - - -+  Waveform Gen  |---> To LEDs
        |                  |        |                |
        |                  |        +--------^-------+
        |                  |                 |        
        |   Synchronized   |                 |        
        |   Clock          |                 |        
        |                  |        +--------+-------+
        |                  |  theta |                |
        |                  +-------->  Pattern       |
        |                  |        |  Generator     |
        |                  |        |                |
        +--------^---------+        +--------^-------+
                 |                           |        
                 |                           |        
                 |                           |        
                 |                  +--------+-------+
                 |                  |                |
                 |                  |  Lighting      |
                 |                  |  Interface     |
                 |                  |  Protocol      |
                 |                  |                |
                 |                  +--------^-------+
                 |                           |        
                 |                           |        
                 |                           |        
        +--------+---------------------------+-------+
        |                                            |
        |                TWI Manager                 |
        |                                            |
        +--------------------------------------------+

#### Lighting Interface Protocol 
Implementation of communications interface
agreed upon by lighting system users. This is the module which will be 
updated when interface changes are required, and is not meant to be
portable, but rather a very application-specific implementation.

#### Pattern Generator 
A set of utilities to generate parametrically
driven patterns. The time domain for the pattern must be updated
via the theta parameter, which is supplied by the Synchro Clock
in this implementation.

#### Syncrhonized Clock 
Keep time (at a configurable speed) that is 
synchronizable to a phase correction signal. This means that if an
external signal is supplied at some interval, this clock will
temporarily adjust its speed to synchronize with the phase signal.

#### TWI Manager 
I2C/TWI wrapper methods to asynchronously handle 
transmission events. A maximum buffer size and slave address must
be specified.

#### Waveform Generator 
Interacts with hardware timers and pwm
generators to output a waveform as specified by the input 
channel registers. This module directly controls the LEDs.

Build Instructions
---

### Requirements
This software was developed using [CrossPack AVR](https://github.com/obdev/CrossPack-AVR) on OSX.
However, [Atmel's AVR Studio](http://www.atmel.com/microsite/atmel_studio6/) should also work.

Additionally, the build process has been automated using GNU Make. The following 
instructions assume a build environment is properly configured in the Makefile. 
Specifically, the following Makefile definitions must be configured: 
`PROG`, `AVROBJCOPY`, `AVRSIZE`, `AVRGCC` 

### Set Fuses
The microcontroller clock selection bit must be set to allow software selection 
of the full rate clock (8MHz). This required to be run only once and can be 
executed via the Makefile command, `make fuse`.


### Build
Compiling and linking the hex file for target hardware is automated via the 
included Makefile. Simply run `make` to create a target output. 

### Flash
Flashing the ATTiny88 with the hexfile is also automated and can be accomplished
by running `make flash`. 


Client Usage 
---

### Phase Synchronization
Several lighting units on the same I2C bus can be phase-synchronized to 
implement coordinated animations between all units. This is accomplished
by signaling the beginning of the 

| Packet Data                 | Comment
| :-------------------------- | :-------------------------
| `0x00`                      | General call packet will trigger
|                             | a phase correction. No other data is required
|                             | to be sent with this packet.
|                             |
| **Total Size**              | **1 Byte**

### General I2C Messaging Format

### Patterns and Color Mixing

* `PATTERN_OFF`
* `PATTERN_SINE`
* `PATTERN_SOLID`
* `PATTERN_SIREN`
* `PATTERN_STROBE`
* `PATTERN_FADEIN`
* `PATTERN_FADEOUT`

* `PARAM_BIAS_RED`
* `PARAM_BIAS_GREEN`
* `PARAM_BIAS_BLUE`
* `PARAM_AMPLITUDE_RED`
* `PARAM_AMPLITUDE_GREEN`
* `PARAM_AMPLITUDE_BLUE`
* `PARAM_PERIOD`
* `PARAM_REPEAT`
* `PARAM_PHASEOFFSET`
* `PARAM_MACRO`

### Macros

* `PARAM_MACRO_RESET`
* `PARAM_MACRO_FWUPDATE`
* `PARAM_MACRO_AUTOPILOT`
* `PARAM_MACRO_CALIBRATE`
* `PARAM_MACRO_POWERON`
* `PARAM_MACRO_POWEROFF`
* `PARAM_MACRO_RED`
* `PARAM_MACRO_GREEN`
* `PARAM_MACRO_BLUE`
* `PARAM_MACRO_AMBER`
* `PARAM_MACRO_WHITE`

### More Examples


| Packet Data                 | Comment
| :-------------------------- | :-------------------------
| `SLAVE_ADDR`                | Slave address for individual lighting unit
| `PATTERN_FADEIN`            | Change animation pattern to Fade In
|                             |
| **Total Size**              | **2 Bytes**


| Packet Data                 | Comment
| :-------------------------- | :-------------------------
| `SLAVE_ADDR`                | Slave address for individual lighting unit
| `PATTERN_SINE`              | This unit will animate intensity as a sine wave
| `PARAM_BIAS_RED`            | Set the red LED bias
| `100`                       | *(Value)*
| `PARAM_AMPLITUDE_RED`       | Set the red LED amplitude
| `100`                       | *(Value)*
| `PARAM_BIAS_GREEN`          | Set the green LED bias
| `100`                       | *(Value)*
| `PARAM_AMPLITUDE_GREEN`     | Set the green LED amplitude
| `100`                       | *(Value)*
| `PARAM_BIAS_BLUE`           | Set the blue LED bias
| `100`                       | *(Value)*
| `PARAM_AMPLITUDE_BLUE`      | Set the blue LED amplitude
| `100`                       | *(Value)*
| `PARAM_PHASEOFFSET`         | Set the Phase Offset of this unit
| `0`                         | to zero
| `0`                         |
| `PARAM_PERIOD`              | Set the speed of this animation to
| `2000 >> 8`                 | a period of 2000ms. Notice MSB is 
| `2000`                      | sent first, in this 2-byte param.
|                             |
| **Total Size**              | **20 Bytes**


| Packet Data                 | Comment
| :-------------------------- | :-------------------------
| `SLAVE_ADDR`                | Slave address for individual lighting unit
| `PATTERN_PARAMUPDATE`       | Change animation pattern to Fade In
| `PARAM_REPEAT`              |
| `1`                         |
|                             |
| **Total Size**              | **4 Bytes**
    

| Packet Data                 | Comment
| :-------------------------- | :-------------------------
| `SLAVE_ADDR`                | Slave address for individual lighting unit
| `PATTERN_PARAMUPDATE`       | Change animation pattern to Fade In
| `PARAM_REPEAT`              |
| `1`                         |
|                             |
| **Total Size**              | **4 Bytes**


| Packet Data                 | Comment
| :-------------------------- | :-------------------------
| `SLAVE_ADDR`                | Slave address for individual lighting unit
| `PATTERN_FADEOUT`           | This unit will animate intensity as a sine wave
| `PARAM_AMPLITUDE_RED`       | Set the red LED amplitude
| `150`                       | *(Value)*
| `PARAM_AMPLITUDE_GREEN`     | Set the green LED amplitude
| `150`                       | *(Value)*
| `PARAM_AMPLITUDE_BLUE`      | Set the blue LED amplitude
| `150`                       | *(Value)*
| `PARAM_PERIOD`              | Set the speed of this animation to
| `4000 >> 8`                 | a period of 2000ms. Notice MSB is 
| `4000`                      | sent first, in this 2-byte param.
|                             |
| **Total Size**              | **11 Bytes**


Limitations
---

### Speeds

### Synchronization 
