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
#define TWI_SLAVE_ADDRESS   0xB0
#define TWI_MAX_BUFFER_SIZE 50
#define TWI_SLAW_RCVD       (TWSR == 0x60) 
#define TWI_SLAR_RCVD       (TWSR == 0xA8) 
#define TWI_SLAW_DATA_RCVD  (TWSR == 0x80) 
#define TWI_GENCALL_RCVD    (TWSR == 0x90) // TODO should be 0x70?
#define TWI_STOP_RCVD       (TWSR == 0xA0) 
int TWI_isCombinedFormat;
int TWI_isSubAddrByte;
int TWI_isSelected;
int TWI_Ptr;
char TWI_Buffer[TWI_MAX_BUFFER_SIZE];

// use to create slave address
#define DEVICE_ID 1
char myTwiSubAddr;

// global light pattern variable
// to be implemented at top of every clock cycle
LightManagerPattern light_pattern;

// blue LED intensity proxy to ensure
// CCM is set at top of every clock cycle
uint8_t LEDIntensityBlue;





int main(void) {
    
    // configure port B pins as output
    DDRB    = 0xFF;
    PORTB   = 0x00;

    // enable interrupts (via global mask)
    sei();

    // TWI Config
    TWAR = TWI_SLAVE_ADDRESS | TWAR_TWGCE;
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

    // TODO set based on physical input lines
    LightManager_setDeviceId(DEVICE_ID);
    myTwiSubAddr = LightManager_getDeviceIdMask();

    // mainloop 
    while(1) {

        // run light effect calculations
        LightManager_calc();

        // adjust time to correct for phase offset
        LightManager_calcPhaseCorrection();

        // buffer parser per interface contract
        LightManager_parseCommand(TWI_Buffer, TWI_Ptr);

        // TODO implement sleep for duty cycle manangement

    }
    
}



// TODO combine all flags to a bit mask pattern?
ISR(TWI_vect) {

    // ignore message if another light unit is being addressed
    if (TWI_SLAW_DATA_RCVD && 
        !TWI_isSubAddrByte && 
        !TWI_isSelected) {

        // release clock line 
        TWCR |= TWCR_TWINT;

    // if message is a time synch cue (general call)
    //  calculate current time offset and store it
    } else if (TWI_GENCALL_RCVD) {

        // record the phase error for correction
        // in mainloop
        LightManager_recordPhaseError();

    // record the end of a transmission if 
    //   stop bit received
    //   TODO handle condition when stopped bit missed
    } else if (TWI_STOP_RCVD && TWI_isSelected) {

        // if this is a repeated-start,
        // answer the next SLA+R
        if (!TWI_isCombinedFormat) {
            // set flag to re-parse TWI command
            LightManager_setCommandUpdated();
        } 

        // mark end of transmission
        TWI_isSelected = 0;

    // every message with begin here
    // reset all flags
    } else if (TWI_SLAW_RCVD) {

        TWI_isCombinedFormat    = 0;
        TWI_isSelected          = 0;
        TWI_isSubAddrByte       = 1;

    // if this unit is being addressed
    //  start capturing pattern and parameters
    } else if (TWI_SLAW_DATA_RCVD && TWI_isSubAddrByte) {

        // always unflag, indicating remaining bytes
        // are not subaddr bytes
        TWI_isSubAddrByte = 0;

        // determine if this message is for this device
        if (myTwiSubAddr & TWDR) {

            // this device is being addressed
            TWI_isSelected = 1;

            // reset buffer pointer
            TWI_Ptr = 0;

        }

    // if this unit was addressed and we're receiving
    //   data, continue capturing into buffer
    } else if (TWI_SLAW_DATA_RCVD && TWI_isSelected) {

        // if this is first byte following a sub-address
        // (normally the pattern byte) and it is 0xFF
        // then treat the next stop/repeated-start as
        // the beginning of a combined format message
        if (TWI_Ptr == 0 && TWDR == 0xFF) 
            TWI_isCombinedFormat = 1;

        // record received data 
        // until buffer is full
        if (TWI_Ptr < TWI_MAX_BUFFER_SIZE) {
            TWI_Buffer[TWI_Ptr++] = TWDR;
        } else { 
            TWI_isSelected = 0;
        }

    }

    // always release clock line
    TWCR |= TWCR_TWINT;

}


// Timer overflow interrupt routine
//   update lighting intensities according to pattern
//   advance time in effect animation
//   adjust animation timer to synchronize across all lights
ISR(TIMER1_OVF_vect) {

    // mark time in light manager
    LightManager_tick();

    // refresh phase correction
    LightManager_setPhaseCorrectionRefresh();

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
