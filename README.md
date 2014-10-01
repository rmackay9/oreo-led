Prioritized TODOs

    [x] fadeOut pattern
    [x] fadeIn pattern
    [x] colorCycle pattern
    [x] phase parameter
    [x] color setting limits high and low

    [ ] create fake pixhawk, controlled via serial application
    [ ] create parameters for pattern coefficients
    [ ] repeat parameter
    [ ] refactor light manager, breakout to more classes
    [ ] improve twi feature encapsulation with light manager

    [x] implement command parameter parser
    [x] pattern speed parameter overflows TOP limit in pattern implementation of theta

Bugs:

    [x] devices in sync, but not steady frequency
        - fixed phase signal from arduino; set to correct period
    [x] un-addressed devices are activating SIREN pattern
        - fixed logic error in refactored TWI addressing code
    [ ] slave holds sda line high and stops all communication
    [ ] slaves freeze after a sequenctial phase offset command to each unit
    [x] turn off lights completely at zero intensity
    [ ] increase pwm freq to improve low end dithering

Deferred:

    [ ] hue parameters
    [ ] implement parameter read functions
    [ ] physical lines need to set I2C address
    