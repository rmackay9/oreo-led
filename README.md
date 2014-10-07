Prioritized Tasks
======

## Features

    [ ] repeat parameter for non-fade patterns
    [x] fadeOut pattern
    [x] fadeIn pattern

    [ ] colorCycle pattern
    [x] phase parameter

    [x] color setting limits: high and low
    [x] create parameters for pattern coefficients
    [x] implement command parameter parser

## Code Quality

    [x] refactor light manager, breakout to more classes
    [x] improve twi feature encapsulation with light manager
    
## Documentation

    [ ] update interface contract document
    [ ] replace magic numbers

Issues
======

## General 

    [x] pattern speed parameter overflows TOP limit in pattern 
        implementation of theta
    [x] devices in sync, but not steady frequency
        - fixed phase signal from arduino; set to correct period
    [x] un-addressed devices are activating SIREN pattern
        - fixed logic error in refactored TWI addressing code
    [ ] fadein/fadeout are not fading correctly, likely issue with repeat param
        - fixed issue with repeat parameter for fades, needs more work for other patterns
    [ ] fadein/fadeout does not transition at some speeds, ie speed=3000 or speed=1000

## Blue LED Fidelity

    [x] turn off lights completely at zero intensity
        - threshold created in wavegen
    [x] change pwm freq to improve low end dithering?
        - actually more of an issue with PWM register resolution
          increasing clock rate (inc instruction time and pwm freq) did not help
    [ ] LEDs flickering every 4 sec, seems to be result of synchro
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

    [x] i2c general call signal is not being transmitted by arduino
        - this may have been identified as an instrumentation error
    [x] verify synchronization is working with a solid phase signal

## I2C Bus

    [ ] slave holds sda line high and stops all communication
        - appears to be side effect of arduino simulation
        - could also have been due to the software sub addresses (removed)
    [ ] slaves freeze after a sequential phase offset command to each unit
        - appears to be side effect of arduino simulation

Deferred
======

    [ ] verify all requested features with actual pixhawk 
    [ ] investigate proportional adjustments to phase error
    [ ] hue parameters
    [ ] implement parameter reading function
    [ ] physical lines to set I2C address
    [ ] implement all patterns in SWF file as macros



