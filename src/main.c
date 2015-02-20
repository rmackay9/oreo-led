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
#include <avr/wdt.h>

#include "math.h"

#include "pattern_generator.h"
#include "light_pattern_protocol.h"
#include "synchro_clock.h"
#include "twi_manager.h"
#include "waveform_generator.h"
#include "node_manager.h"

// the watchdog timer remains active even after a system reset 
//  (except a power-on condition), using the fastest prescaler 
//  value (approximately 15ms). It is therefore required to turn 
//  off the watchdog early during program startup
//  (taken from wdt.h, avrgcc)
uint8_t mcusr_mirror __attribute__ ((section (".noinit")));
void get_mcusr(void) __attribute__((naked)) __attribute__((section(".init3")));
void get_mcusr(void)
{
    mcusr_mirror = MCUSR;
    MCUSR = 0;
    wdt_disable();
}

// create pattern generators for all
//  three LED channels
PatternGenerator pgRed;
PatternGenerator pgGreen;
PatternGenerator pgBlue;

// main program entry point
int main(void) {
    
    // init synchro node singleton
    SYNCLK_init();

    // delay to acquire hardware pin settings
    // and node initialization
    _delay_ms(200);
    NODE_init();

    // init TWI node singleton with device ID
    TWI_init(NODE_getId());

    // register TWI event callbacks
    TWI_onGeneralCall(SYNCLK_recordPhaseError);
    TWI_onDataReceived(LPP_setCommandRefreshed);

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

    // if previous shutdown was a WDT reset...
    if (mcusr_mirror && 0x08) {

        // do not perform startup check
        NODE_system_status = NODE_STARTUP_SUCCESS;

        // set wdt to 0.5s and system reset mode
        NODE_wdt_setHalfSecResetMode();

        // resume pattern
        if (NODE_isRestoreStateAvailable()) 
            NODE_restoreRGBState(&pgRed, &pgGreen, &pgBlue);


    } else {

        // configure startup health check timer
        //   to enter 'failed' more (all red LEDs)
        //   if device has not received any i2c comms
        //   after NODE_MAX_TIMEOUT_SECONDS
        NODE_wdt_setOneSecInterruptMode();

        // restore state is not available yet, but will
        //   possibly be populated in a graceful wdt reset
        //   by the node manager
        NODE_setRestoreStateUnavailable();

    }

    // reset wdt timer
    NODE_wdt_reset();

    // application mainloop 
    while(1) {

        // run light effect calculations based
        //   on synchronized clock reference
        double clockPosition = SYNCLK_getClockPosition();
        PG_calc(&pgRed, clockPosition);
        PG_calc(&pgGreen, clockPosition);
        PG_calc(&pgBlue, clockPosition);

        // update LED PWM duty cycle
        //   with values computed in pattern generator
        WG_updatePWM();

        // if startup did not fail, enable communications
        if (NODE_system_status != NODE_STARTUP_FAIL) {

            // calculate time adjustment needed to 
            //  sync up with system clock signal
            SYNCLK_calcPhaseCorrection();

            // parse commands per interface contract
            //  and update pattern generators accordingly
            //  set startup condition success if a command rcvd
            if (LPP_processBuffer(TWI_getBuffer(), TWI_getBufferSize()) &&
                NODE_system_status != NODE_STARTUP_SUCCESS) {
                NODE_system_status = NODE_STARTUP_COMMRCVD;
            }

        }

        // reset WDT timer only if node startup status has already 
        //   been determined (if startup status is already determined, 
        //   the wdt is used as a system reset mechanism). this wdt reset
        //   call is to indicate that the system is still functioning
        //   normally and avoids the system reset condition.
        if (NODE_system_status != NODE_STARTUP_PENDING &&
            NODE_system_status != NODE_STARTUP_COMMRCVD) NODE_wdt_reset();

    }

}


// watchdog timer interrupt vector
ISR(WDT_vect) {

    switch (NODE_system_status) {

        // no i2c communications received yet, still waiting
        //  for any command before entering NODE_STARTUP_SUCCESS state
        case NODE_STARTUP_PENDING:

            // increment timeout count
            NODE_startup_timeout_seconds++;

            // node has not received i2c communications in NODE_MAX_TIMEOUT_SECONDS
            //   after startup - enter NODE_STARTUP_FAIL state
            if (NODE_startup_timeout_seconds == NODE_MAX_TIMEOUT_SECONDS) {

                // startup has failed, show all red LEDs
                //   and stop processing further communication
                LPP_setParamMacro(PARAM_MACRO_RED);
                NODE_system_status = NODE_STARTUP_FAIL;

            }

            // reset wdt flag
            MCUSR = 0;

            break;

        // node received communication, switching to normal op mode
        case NODE_STARTUP_COMMRCVD:

            // set wdt to 0.5s and system reset mode
            //   change to normal operation mode, this ISR should
            //   no longer be entered unless a hang occurs
            NODE_wdt_setHalfSecResetMode();
            NODE_system_status = NODE_STARTUP_SUCCESS;
        
            // reset wdt flag
            MCUSR = 0;

            break;

        // a system hang ocurred, this is a failure
        default:

            // save state and reset
            NODE_saveRGBState(&pgRed, &pgGreen, &pgBlue);

    }

    // reset wdt timer
    NODE_wdt_reset();

    return;

}