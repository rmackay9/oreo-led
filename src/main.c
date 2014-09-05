/*
 * main.c
 */  

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/cpufunc.h>
#include "TWI_Slave.h"
#include "Light_Manager.h"


#define IOCLK_DIV1024       (1<<CS12)|(0<<CS11)|(1<<CS10)
#define IOCLK_DIV256        (1<<CS12)|(0<<CS11)|(0<<CS10)
#define IOCLK_DIV64         (0<<CS12)|(1<<CS11)|(1<<CS10)
#define IOCLK_DIV8          (0<<CS12)|(1<<CS11)|(0<<CS10)
#define IOCLK_DIV1          (0<<CS12)|(0<<CS11)|(1<<CS10)

#define COM1A_ENABLE        (1<<COM1A1)|(0<<COM1A0)
#define COM1B_ENABLE        (1<<COM1B1)|(0<<COM1B0)

#define FASTPWM_8BIT_A      (0<<WGM11)|(1<<WGM10)
#define FASTPWM_9BIT_A      (1<<WGM11)|(0<<WGM10)
#define FASTPWM_10BIT_A     (1<<WGM11)|(1<<WGM10)

#define FASTPWM_B           (0<<WGM13)|(1<<WGM12)

uint8_t light_pattern;

int main(void) {

    // TODO: record module position from hardware switches on startup, set I2C slave address accordingly

    // TODO: create synchronization event handler, adjust timer counter accordingly 
    // this will get our current phase, which will then be used in the adjustment event
    // to match the selected pattern phase to the manager's internal patternPhase

    // TODO: create i2c slave message handler, update light pattern accordingly

    // TODO: setup I2C slave
    
    // enable OC1A output driver
    DDRB = (1<<DDB1)|(1<<DDB2);

    // set port b pins as output
    PORTB = 0x00;

    // enable interrupts (via global mask)
    sei();

    // enable PWM signal from OC1 A&B pins
    // enable 10-bit fast PWM mode (125.25Hz)
    TCCR1A = FASTPWM_10BIT_A | COM1B_ENABLE | COM1A_ENABLE;
    TCCR1B = (0<<ICNC1) | (0<<ICES1) | FASTPWM_B | IOCLK_DIV8;

    // enable T1 interrupts
    TIMSK1 |= 1<<TOIE1;
    
    // initialize the light manager
    LightManager_init(&OCR1B, &OCR1A);

    // set an initial pattern
    light_pattern = 0x01;

    // begin main loop
    // TODO: implement sleep mode
    while(1);
    
}

/*
ISR(I2C_Message_Rx) {

    // if message is a time synch cue ...
    //  calculate current phase and store it

    // if message is a pattern update ...
    //  capture pattern and parameters

}
*/

// Light animation update timer ISR 
ISR(TIMER1_OVF_vect) {

    // adjust current phase to target phase

    // mark time in light manager
    LightManager_tick();

    // implement the currently selected pattern
    LightManager_setPattern(light_pattern);

}
    
