#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/cpufunc.h>
#include "Light_Manager.h"


#define ZERO                0x00

#define TCCR0A_CLOCK_FULL   0b00000001
#define TCCR0A_CLOCK_DIV8   0b00000010

#define TIMSK0_OCIE0B       0b00000100
#define TIMSK0_OCIE0A       0b00000010
#define TIMSK0_TOIE0        0b00000001

#define TCCR1A_PWM_MODE     0b10100000
#define TCCR1A_FAST_PWM8    0b00000001

#define TCCR1B_FAST_PWM8    0b00001000
#define TCCR1B_CLOCK_FULL   0b00000001
#define TCCR1B_CLOCK_DIV8   0b00000010

#define TIMSK1_TOIE1        0b00000001



// blue LED intensity proxy to ensure
// CCM is set at top of every clock cycle
uint8_t LEDIntensityBlue;





int main(void) {
    
    // configure port B pins as output
    DDRB    = 0xFF;
    PORTB   = 0x00;

    // enable interrupts (via global mask)
    sei();

    // create syncro node
    SyncroNode syncroNode;
    SN_init(&syncroNode);

    // setup TWI node
    // with device ID
    TWI_init(Device_getId());

    // setup callbacks
    TWI_onGeneralCall(SN_recordPhaseError, &syncroNode);
    TWI_onDataReceived(PGU_commandAvailable, &pgu);

    // setup all timers
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


    // mainloop 
    while(1) {

        // run light effect calculations
        PG_calc(&pgRed);
        PG_calc(&pgGreen);
        PG_calc(&pgBlue);

        // update LEDs
        LED_set();

        // adjust time to correct for phase offset
        SN_calcPhaseCorrection();

        // buffer parser per interface contract
        LightManager_parseCommand(TWI_Buffer, TWI_Ptr);

        // TODO implement sleep for duty cycle manangement

    }
    
}




