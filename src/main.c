#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/cpufunc.h>
#include "TWI_Slave.h"
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

char light_pattern;
volatile uint8_t blueIntensity;

int main(void) {

    // TODO: record module position from hardware switches on startup, set I2C slave address accordingly

    // TODO: create synchronization event handler, adjust timer counter accordingly 
    // this will get our current phase, which will then be used in the adjustment event
    // to match the selected pattern phase to the manager's internal patternPhase

    // TODO: create i2c slave message handler, update light pattern accordingly

    // TODO: setup I2C slave
    
    // configure port B pins as output
    DDRB    = 0xFF;
    PORTB   = 0x00;

    // enable interrupts (via global mask)
    sei();

    // TIMER1 Config
    // pwm mode and waveform generation mode
    // timer clock speed
    TCCR1A = ZERO | TCCR1A_PWM_MODE | TCCR1A_FAST_PWM8;
    TCCR1B = ZERO | TCCR1B_FAST_PWM8 | TCCR1B_CLOCK_DIV8;

    // TIMER1 Overflow interrupt enable
    TIMSK1 = 0x01;

    // TIMER0 Config
    // Output compare mode
    // Set timer clock speed
    TCCR0A = ZERO | TCCR0A_CLOCK_DIV8;
    
    // TIMER0 Interrupts
    // overflow interrupt 
    // output compare match interrupt
    TIMSK0 = ZERO | TIMSK0_TOIE0 | TIMSK0_OCIE0B;

    // setup light manager for Red Green and Blue LEDs
    LightManager_init(&OCR1BL, &OCR1AL, &OCR0B);

    // initialize a pattern 
    // TODO make pattern const ENUMS
    light_pattern = 0;

    // mainloop 
    // TODO implement sleep
    while(1);
    
}

/*
ISR(I2C_Message_Rx) {

    // if message is a time synch cue ...
    //  calculate current time offset and store it

    // if message is a pattern update ...
    //  capture pattern and parameters

}
*/

// Timer overflow interrupt routine
//   update lighting intensities according to pattern
//   advance time in effect animation
//   adjust animation timer to synchronize across all lights
ISR(TIMER1_OVF_vect) {

    // TODO adjust timer to correct for offset

    // implement the currently selected pattern
    LightManager_setPattern(light_pattern);

    // mark time in light manager
    LightManager_tick();

}

// Implement Blue LED PWM Signal 
ISR(TIMER0_OVF_vect) {
    // set blue LED at start of PWM cycle
    if (OCR0B > 5) PORTB |= 0b00000001;
    else PORTB &= 0b11111110;
}

// Implement Blue LED PWM Signal 
ISR(TIMER0_COMPB_vect) {
    // reset blue LED on compare match
    PORTB &= 0b11111110;
}
