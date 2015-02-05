Prioritized Tasks
======

## Features

    [x] repeat parameter for non-fade patterns
    [x] fadeOut pattern
    [x] fadeIn pattern
    [x] phase parameter
    [x] colorCycle pattern

    [x] implement all patterns in SWF file as high-level macros
        - PATTERN_MACRO_FWUPDATE, PATTERN_MACRO_AUTOPILOT, 
        - PATTERN_MACRO_TOLAND, PATTERN_MACRO_CALIBRATE,
        - PATTERN_MACRO_POWERON, PATTERN_MACRO_POWEROFF,
        - PATTERN_MACRO_RED, PATTERN_MACRO_GREEN, PATTERN_MACRO_BLUE, 
        - PATTERN_MACRO_AMBER, PATTERN_MACRO_WHITE

    [x] color setting limits: high and low
    [x] create parameters for pattern coefficients
    [x] implement command parameter parser
    [x] physical lines to set I2C address

## Code Quality

    [x] refactor light manager, breakout to more classes
    [x] improve twi feature encapsulation with light manager
    
## Documentation

    [x] update interface contract document
        - removing external documentation, keeping all docs in this repo under vcs
    [x] replace magic numbers
    [x] document examples as usage instructions
    [x] document instructions for programming
    [x] document known limitations, issues, notes

# Checkout

    [ ] verify multi-ESC operation
    [ ] verify synchronzation
    [ ] verify all pattern protocol features, including phase offset
    [ ] validate all requested (SWF) features with actual pixhawk 
    [ ] macro sequence power-on followed by breath not working correctly
    [ ] double power-on macro animation speed 

Known Issues
======

## General 

    [x] pattern speed parameter overflows TOP limit in pattern 
        implementation of theta
    [x] devices in sync, but not steady frequency
        - fixed phase signal from fake master; set to correct period
    [x] un-addressed devices are activating SIREN pattern
        - fixed logic error in refactored TWI addressing code
    [x] fadein/fadeout are not fading correctly, likely issue with repeat param
        - fixed issue with repeat parameter for fades, needs more work for other patterns
    [x] fadein/fadeout does not transition at some speeds, ie speed=3000 or speed=1000
        - speeds must be a (higher) harmonic of the fundamental 4s period for continous animations

## Blue LED Fidelity

    [x] turn off lights completely at zero intensity
        - threshold created in wavegen
    [x] change pwm freq to improve low end dithering?
        - actually more of an issue with PWM register resolution
          increasing clock rate (inc instruction time and pwm freq) did not help
    [x] LEDs flickering every 4 sec, seems to be result of synchro
        clock theta updates, possibly the comparison operation itself
        or even all TWI interrupts blocking PWM timer interrupts. Not critical
        at sufficiently large intensity values or animations with fast enough speed
        - may have been addressed with slower PWM divider on blue channel
        - may have been addressed with increased clock speed fuse setting 
    [x] units have a default pattern, should be off
        - set to off, also added reset values for pattern gen Amp and Bias values
    [x] blue channel still pegs to 100% at commanded values under 20
        although performs better with a slower PWM cycle speed
        - threshold and re-scaling adjusted to avoid PWM latching issue

## Phase Signal

    [x] i2c general call signal is not being transmitted by fake master
        - this may have been identified as an instrumentation error
    [x] verify synchronization is working with a solid phase signal
    [ ] verify working on actual hardware

## I2C Bus 

    [ ] slave holds sda line high and stops all communication
        - appears to be side effect of fake master simulation
        - could also have been due to the software sub addresses (removed)
    [ ] slaves freeze after a sequential phase offset command to each unit
        - appears to be side effect of fake master simulation
    [ ] verify fixed on actual hardware

Future Development
======

    [ ] implement parameter reading function
    [ ] wait to start pattern animation until current value is reached for smoother transition
    [ ] investigate proportional adjustments to phase error for faster correction
    [ ] hue parameters
    [ ] buffer parameters and apply at end of transmission
