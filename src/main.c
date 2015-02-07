/**********************************************************************

  main.c - implementation of aircraft lighting system. Commands to the 
   system are transmitted via a common I2C bus, connecting all lighting 
   units (slave devices) with the Pixhawk (as master transmitter). 


    Clock parameters are set in synchro_clock.h and implemented in the
    wave generator source file, under _WG_configureHardware(). This 
    firmware currently anticipates an Atmel ATTiny88 target platform 
    with fuses set to enable the 8MHz internal calibrated oscillator. 
    Additionally, the clock prescalar bits are not set, defaulting the 
    internal system clock to full 8MHz operation.

    PWM output occues at PB0, PB1, and PB2. PB0 is a bit-banged signal
    whereas PB1/PB2 utilize the output compare hardware (the pins are
    known as OC1A and OC1B, respectively).

  Authors: 
    Nate Fisher

  Created: 
    Wed Oct 1, 2014

**********************************************************************/

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/cpufunc.h>
#include <util/delay.h>

#include "math.h"

#include "pattern_generator.h"
#include "light_pattern_protocol.h"
#include "synchro_clock.h"
#include "twi_manager.h"
#include "waveform_generator.h"
#include "node_manager.h"


int main(void) {
    
    // init synchro node singleton
    SYNCLK_init();

    // delay to acquire hardware pin settings
    _delay_ms(200);

    // init TWI node singleton with device ID
    TWI_init(NODE_getId());

    // register TWI event callbacks
    TWI_onGeneralCall(SYNCLK_recordPhaseError);
    TWI_onDataReceived(LPP_setCommandRefreshed);

    // create pattern generators for all
    //  three LED channels
    PatternGenerator pgRed;
    PatternGenerator pgGreen;
    PatternGenerator pgBlue;

    // init the generators
    PG_init(&pgRed);
    PG_init(&pgGreen);
    PG_init(&pgBlue);

    // register pattern generators with the
    //  lighting pattern protocol interface
    LPP_setRedPatternGen(&pgRed);
    LPP_setGreenPatternGen(&pgGreen);
    LPP_setBluePatternGen(&pgBlue);

    // register the pattern generator calculated values
    //  with hardware waveform outputs
    uint8_t* wavegen_inputs[3] = {&(pgRed.value), &(pgGreen.value), &(pgBlue.value)};
    WG_init(wavegen_inputs, 3);

    // attach clock input to the synchroniced timing
    //  module, to ultimately drive the pattern generator
    //  updates in a coordinated way
    WG_onOverflow(SYNCLK_updateClock);

    // enable interrupts 
    sei();

    // application mainloop 
    while(1) {

        // run light effect calculations based
        //  on synchronized clock reference
        double clockPosition = SYNCLK_getClockPosition();
        PG_calc(&pgRed, clockPosition);
        PG_calc(&pgGreen, clockPosition);
        PG_calc(&pgBlue, clockPosition);

        // update LED PWM duty cycle
        //  with values computed in pattern generator
        WG_updatePWM();

        // calculate time adjustment needed to 
        //  sync up with system clock signal
        SYNCLK_calcPhaseCorrection();

        // parse commands per interface contract
        //  and update pattern generators accordingly
        LPP_processBuffer(TWI_getBuffer(), TWI_getBufferSize());

    }

}
