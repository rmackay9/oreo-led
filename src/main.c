/**********************************************************************

  main.c - implementation of aircraft lighting system. Commands to the 
   system are transmitted via a common I2C bus, connecting all lighting 
   units (slave devices) with the Pixhawk (as master transmitter). 

  Authors: 
    Nate Fisher

  Created: 
    Wed Oct 1, 2014

**********************************************************************/

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/cpufunc.h>

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
        PG_calc(&pgRed, SYNCLK_getClockPosition());
        PG_calc(&pgGreen, SYNCLK_getClockPosition());
        PG_calc(&pgBlue, SYNCLK_getClockPosition());

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
