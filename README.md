# Prioritized Tasks

    Features

    [ ] apply repeat for all patterns
    [ ] implement color cycle pattern
    [x] fadeOut pattern
    [x] fadeIn pattern
    [x] colorCycle pattern
    [x] phase parameter
    [x] color setting limits high and low
    [x] create parameters for pattern coefficients
    [x] repeat parameter
    [x] implement command parameter parser

    Code Quality

    [x] refactor light manager, breakout to more classes
    [x] improve twi feature encapsulation with light manager
    
    Documentation

    [ ] update interface contract document
    [ ] replace magic numbers

# Issues

    General 

    [x] pattern speed parameter overflows TOP limit in pattern 
        implementation of theta
    [x] devices in sync, but not steady frequency
        - fixed phase signal from arduino; set to correct period
    [x] un-addressed devices are activating SIREN pattern
        - fixed logic error in refactored TWI addressing code

    Blue LED Fidelity

    [x] turn off lights completely at zero intensity
        - threshold created in wavegen
    [x] change pwm freq to improve low end dithering?
        - actually more of an issue with PWM register resolution
          increasing clock rate (inc instruction time and pwm freq) did not help
    [ ] LEDs flickering every 4 sec, seems to be result of synchro
        clock theta updates, possibly the comparison operation itself
    [x] units have a default pattern, should be off
        - set to off, also added reset values for pattern gen Amp and Bias values
    [x] blue channel still pegs to 100% at commanded values under 20
        although performs better with a slower PWM cycle speed
        - threshold and re-scaling adjusted to avoid PWM latching issue

    Phase Signal

    [ ] i2c general call signal is not being transmitted by arduino
        - this may have been identified as an instrumentation error
    [ ] verify synchronization is working with a solid phase signal

    I2C Bus

    [ ] slave holds sda line high and stops all communication
    [ ] slaves freeze after a sequential phase offset command to each unit

# Deferred

    [ ] create fake pixhawk, controlled via serial application
    [ ] make proportional adjustments to phase error
    [ ] hue parameters
    [ ] implement parameter reading function
    [ ] physical lines need to set I2C address
    [x] use physical i2c addresses, remove subaddr
    [ ] implement all patterns in SWF file as macros



