Lighting Module Driver Firmware
===


Overview
---
### Hardware
This firmware is designed to run on the Atmel ATTiny88 and was
programmed via the Dragon ISP programmer. See the `/doc` folder for
more information.


Build Instructions
---
### Requirements
This software was developed using (https://github.com/obdev/CrossPack-AVR)[CrossPack AVR] on OSX.
However, (http://www.atmel.com/microsite/atmel_studio6/)[Atmel's AVR Studio] should also work.

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
### Phase Synch
### Macros
### Examples


Limitations
---
### Speeds
### Synchronization 
