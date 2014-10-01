#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/cpufunc.h>
#include "Light_Manager.h"

// blue LED intensity proxy to ensure
// CCM is set at top of every clock cycle
uint8_t LEDIntensityBlue;

int main(void) {
    

    // configure port B pins as output
    DDRB    = 0xFF;
    PORTB   = 0x00;

    // enable interrupts (via global mask)
    sei();



    // init syncro node singleton
    SN_init();

    // init TWI node singleton with device ID
    TWI_init(Device_getId());

    // register callbacks
    TWI_onGeneralCall(SN_recordPhaseError);
    TWI_onDataReceived(PGI_setCommandRefreshed);

    // init timer management singleton
    TM_init();

    // create pattern generators for all
    // three LED channels
    PatternGenerator pgRed;
    PatternGenerator pgGreen;
    PatternGenerator pgBlue;

    // init the generators
    PG_init(&pgRed);
    PG_init(&pgGreen);
    PG_init(&pgBlue);

    // init waveform generation
    WG_init(&OCR1BL, &OCR1AL, &LEDIntensityBlue);


    // mainloop 
    while(1) {

        // run light effect calculations
        PG_calc(&pgRed);
        PG_calc(&pgGreen);
        PG_calc(&pgBlue);

        // update LED PWM duty cycle
        WG_update();

        // adjust time to correct for phase offset
        SN_calcPhaseCorrection();

        // buffer parser per interface contract
        PGI_parseCommand(TWI_getBufffer(), TWI_getBufferSize());

        // TODO implement sleep for duty cycle manangement

    }
    
}




