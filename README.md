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
more information. The below implementation is meant to drive a series of
RGB LEDs via PWM signals. Because there are only two hardware waveform
generators in the ATTiny88 unit, a third PWM generator was 'bit-bnanged'
using the 8-bit timer (Timer0) and a spare GPIO pin (PB0).

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
by signaling the beginning of the univerally-synchronized period with a 
single I2C general call packet. This packet should be issued on a 4 second
period, by the master transmitter, in this implementation. 

| Packet Data                 | Comment
| :-------------------------- | :-------------------------
| `0x00`                      | General call packet will trigger
|                             | a phase correction. No other data is required
|                             | to be sent with this packet.
|                             |
| **Total Size**              | **1 Byte**


### General I2C Messaging Format
Commands to the aircraft lighting system are transmitted via a common I2C bus, 
connecting all lighting units (slave devices) with the Pixhawk (as master transmitter). 
The following interface description will form as a contract between developers of application 
code running on the Pixhawk unit and those creating driver firmware on the 
individual lighting units. 

In the below examples, SLAVE ADDR is a 7-bit value, assigned to each lighting units. 
The particular value is determined by hardware settings and read from GPIOs on startup. 
The least significant bit is reset to indicate a write operation is to be performed. 

Each message contains some lighting instruction data and is of the following form:  
**SLAVE_ADDR** + **PATTERN IDENTIFIER** [+ **PARAMETER_0** + **VALUE_0** + ... + **PARAMETER_N** + **VALUE_N**]  
The parameter+value segment within square brackets is optional.


### Patterns and Color Mixing
Generally, all patterns follow the convention:  

    Bias + Amplitude x Function(time)  

Where function is the selected pattern and time is the theta value computed by the synchronized
clock, selected speed and phase values. Bias and Amplitude are used to adjust the intensity and color
of the light. Notes in each possible pattern selection follows:

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


### Examples
The following examples show how to accomplish several effects via I2C commands to 
a single lighting system unit. Each of these command sequences would need to be 
repeated (or slightly modified) for each lighting unit to be updated. 

#### Change Pattern
To only change the pattern animation, address the desired unit and send a pattern
enum value, such as the `PATTERN_FADEIN` value depicted below:

| Packet Data                 | Comment
| :-------------------------- | :-------------------------
| `SLAVE_ADDR`                | Slave address for individual lighting unit
| `PATTERN_FADEIN`            | Change animation pattern to Fade In
|                             |
| **Total Size**              | **2 Bytes**

#### Change Pattern and Parameters
To update the animation pattern, as well as one or several parameters, append the
parameter data after the pattern selection. In the below example, the pattern is
commanded to become a sine wave, with the bias and amplitude each set to a value
of 100 for all three colors. In addition, the phase offset for the entire unit is 
set to be 0 degrees and the speed of the sine wave pattern is set to have a period
of 2 seconds. Note the total size of this transaction (per lighting unit) is 20 bytes.

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

#### Update Parameters Only
To avoid changing a pattern while updating parameters of the already selected pattern,
use the same message format but with the pattern enum set to `PATTERN_PARAMUPDATE`. Then
append the desired parameter+value pairs as usual. The below example updates the repeat
count of the currently selected pattern to 1. This technique may be used to stop a pattern
gracefully before applying a new animation.

| Packet Data                 | Comment
| :-------------------------- | :-------------------------
| `SLAVE_ADDR`                | Slave address for individual lighting unit
| `PATTERN_PARAMUPDATE`       | Change animation pattern to Fade In
| `PARAM_REPEAT`              |
| `1`                         |
|                             |
| **Total Size**              | **4 Bytes**
    
#### Example: Fade Out
To implement a fade out, ensure that the amplitude values are non-zero, a sufficiently
slow period is assigned and the fade out pattern is selected:

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
For best results, selected speeds must be an integer multiple of the fundamental speed (0.25Hz). 
Commanded speeds should be lower than the fundamental speed. For example, a valid speeds (given in 
period milliseconds) would be 2000 or 1000. Invalid speeds would be 3000 or 5000. While 'invalid' 
speeds may be interpreted correctly by the lighting units, the results are unverified.

### Synchronization 
The master transmitter must supply a phase synchronization signal (in the form of an I2C general call)
once every 4 seconds. The accuracy of this phase signal period will affect the perceived stability of the
lighting animation. In the absence of this signal, the lighting animations between units will fall out
of synchronization and not be able to provide any coordinated effects reliably. 
