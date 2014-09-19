/*
 * Variable duty cycle for all three LEDs
 */

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/cpufunc.h>

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

int main(void) {

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
    TIMSK0 = ZERO | TIMSK0_TOIE0 | TIMSK0_OCIE0A;

    // Set LED intensities
    // Green LED
    OCR1A = 230;
    // Red LED
    OCR1B = 35;
    // Blue LED
    OCR0A = 80;

    // mainloop for 
    while(1);
    
}

ISR(TIMER1_OVF_vect) {
    // optionally, update LED intensities here
}

ISR(TIMER0_OVF_vect) {
    // set blue LED at start of PWM cycle
    PORTB |= 0b00000001;
}

ISR(TIMER0_COMPA_vect) {
    // reset blue LED on compare match
    PORTB &= 0b11111110;
}
