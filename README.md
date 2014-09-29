Prioritized TODOs

Friday:

    [ ] fadeOut pattern
    [ ] fadeIn pattern
    [ ] colorCycle pattern
    [ ] repeat parameter
    [x] phase parameter
    [x] color setting limits high and low

Monday:

    [ ] implement parameter read functions
    [ ] physical lines need to set I2C address
    [ ] refactor light manager, breakout to more classes
    [ ] improve twi feature encapsulation with light manager
    [ ] hue parameters
    [x] implement command parameter parser
    [x] pattern speed parameter overflows TOP limit in pattern implementation of theta

Bugs:
    [x] devices in sync, but not steady frequency
        - fixed phase signal from arduino; set to correct period
    [x] un-addressed devices are activating SIREN pattern
        - fixed logic error in refactored TWI addressing code
    [ ] slave holds sda line high and stops all communication