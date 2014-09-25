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

#define TWAR_TWGCE          0b00000001
#define TWCR_TWINT          0b10000000
#define TWCR_TWEA           0b01000000
#define TWCR_TWEN           0b00000100
#define TWCR_TWIE           0b00000001

// TWI Stuff
#define TWI_BUFFER_SIZE 10
int TWI_Receiving;
int TWI_Ptr;
char TWI_Buff[TWI_BUFFER_SIZE];

// TODO set based on physical input lines
// use to create slave address
char MYADDR = 0b00000001;

// global light pattern variable
// to be implemented at top of every clock cycle
LightManagerPattern light_pattern;

// blue LED intensity proxy to ensure
// CCM is set at top of every clock cycle
uint8_t LEDIntensityBlue;



int main(void) {

    // TODO: record module position from hardware switches on startup, set I2C slave address accordingly
    
    // configure port B pins as output
    DDRB    = 0xFF;
    PORTB   = 0x00;

    // enable interrupts (via global mask)
    sei();

    // TWI Config
    TWAR = 0xB0 | TWAR_TWGCE;
    TWCR = ZERO | TWCR_TWEA | TWCR_TWEN | TWCR_TWIE;



    // TIMER1 Config
    // pwm mode and waveform generation mode
    // timer clock speed
    TCCR1A = ZERO | TCCR1A_PWM_MODE | TCCR1A_FAST_PWM8;
    TCCR1B = ZERO | TWCR_TWINT | TCCR1B_FAST_PWM8 | TCCR1B_CLOCK_DIV8;

    // TIMER1 Interrupts
    // overflow interrupt 
    TIMSK1 = ZERO | TIMSK1_TOIE1;


    // TIMER0 Config
    // Output compare mode
    // Set timer clock speed
    TCCR0A = ZERO | TCCR0A_CLOCK_DIV8;
    
    // TIMER0 Interrupts
    // overflow interrupt 
    // output compare match interrupt
    TIMSK0 = ZERO | TIMSK0_TOIE0 | TIMSK0_OCIE0B;


    // setup light manager for Red Green and Blue LEDs
    LightManager_init(&OCR1BL, &OCR1AL, &LEDIntensityBlue);

    // mainloop 
    while(1) {

        // run light effect calculations
        LightManager_calc();

        // adjust time to correct for phase offset
        LightManager_calcPhaseCorrection();

        // TODO implement sleep

        // buffer parser per interface contract
        LightManager_parseCommand(TWI_Buff);


    }
    
}


ISR(TWI_vect) {

    // ignore if another light unit is being addressed
    if ((TWSR == 0x80) && !TWI_Receiving && ((MYADDR & TWDR) != MYADDR)) {

        // release clock line 
        TWCR |= TWCR_TWINT;

    // if message is a time synch cue (general call)
    //  calculate current time offset and store it
    } else if (TWSR == 0x90) {

        LightManager_recordPhaseError();

    // record the end of a transmission if 
    //   stop bit received
    //   TODO handle condition when stopped bit missed
    } else if (TWSR == 0xA0) {

        TWI_Receiving = 0;
        LightManager_setCommandUpdated();

    // if this unit is being addressed
    //  start capturing pattern and parameters
    } else if ((TWSR == 0x80) && !TWI_Receiving && ((MYADDR & TWDR) == MYADDR)) {

        TWI_Receiving   = 1;
        TWI_Ptr         = 0;

    // if this unit was addressed and we're receiving
    //   data, continue capturing into buffer
    } else if ((TWSR == 0x80) && TWI_Receiving) {

        if (TWI_Ptr < TWI_BUFFER_SIZE) {
            TWI_Buff[TWI_Ptr++] = TWDR;
        } else { 
            TWI_Receiving = 0;
        }

    }

    // release clock line
    TWCR |= TWCR_TWINT;

}


// Timer overflow interrupt routine
//   update lighting intensities according to pattern
//   advance time in effect animation
//   adjust animation timer to synchronize across all lights
ISR(TIMER1_OVF_vect) {

    // mark time in light manager
    LightManager_tick();

    LightManager_updatePhaseCorrection();

}

// Implement Blue LED PWM Signal 
ISR(TIMER0_OVF_vect) {

    // if blue intensity is below threshold,
    // do not turn on at all
    if (LEDIntensityBlue > 15) {

        // set blue LED at start of PWM cycle
        PORTB |= 0b00000001; 

    } else { 

        // keep LED off if below threshold
        PORTB &= 0b11111110;
        LEDIntensityBlue = 15;

    }

    // set compare register value
    OCR0B = LEDIntensityBlue;
 
}

// Implement Blue LED PWM Signal 
ISR(TIMER0_COMPB_vect) {

    // reset blue LED on compare match
    PORTB &= 0b11111110;

}
