/*
 * Roughly 50% duty cycle of all LEDs   
 */

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/cpufunc.h>

int main(void) {

    // configure port B pins as output
    DDRB    = 0xFF;
    PORTB   = 0x00;

    // mainloop for 
    while(1) {

        // set PB0, PB1, PB2 at bottom of counter
        PINB = 0b00000111;

        // unset all LEDS
        PINB = 0b00000000;

    }

}
