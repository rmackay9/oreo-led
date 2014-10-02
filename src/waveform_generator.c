/**********************************************************************

  waveform_generator.c - implementation, see header for description

  Authors: 
    Nate Fisher

  Created at: 
    Wed Oct 1, 2014

  <License> 
  <Copyright>

**********************************************************************/

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/cpufunc.h>
#include "math.h"
#include "waveform_generator.h"

// setup wavegen hardware; assign inputs and outputs
//  - register the pattern generator calculated values
//    with (up to three) hardware waveform outputs
void WG_init(uint8_t** channelValueRefs, int channelCount) {

    // setup cpu hardware for PWM and timer operation
    _WG_configureHardware();

    // assign outputs for hardware PWM channels 1 & 2
    //  note that channel 3 requires manipulation of a non-PWM
    //  generating hardware timer (Timer0)
    _self_waveform_gen.channel_1_output = &OCR1BL;
    _self_waveform_gen.channel_2_output = &OCR1AL;

    // register the wavegen target references
    //  with inputs, expressed as percentages
    while(channelCount--) {
        _self_waveform_gen.channel_target[channelCount] = channelValueRefs[channelCount];
    }

}

// attach clock input to the synchroniced timing
//  module, to ultimately drive the pattern generator
//  updates in a coordinated way
void WG_onOverflow(void (*cb)()) {

    _self_waveform_gen.overflowCallback = cb;

};

// setup cpu hardware for PWM and timer operation
void _WG_configureHardware(void) {

    // configure port B pins as output
    DDRB    = 0xFF;
    PORTB   = 0x00;

    // TIMER1 Config
    // pwm mode and waveform generation mode
    // timer clock speed
    TCCR1A = ZERO | TCCR1A_PWM_MODE | TCCR1A_FAST_PWM8;
    TCCR1B = ZERO | TCCR1B_FAST_PWM8 | TCCR1B_CLOCK_DIV8;

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

}


// update PWM duty cycle values per the channel target
//  values, which are stored as percentages
void WG_updatePWM(void) {

    // rescale channel percentage values to 0->240
    int channel_1_pwm_value = (fmod(*(_self_waveform_gen.channel_target[0]), 100.0)/100.0) * PWM_MAX_VALUE;
    int channel_2_pwm_value = (fmod(*(_self_waveform_gen.channel_target[1]), 100.0)/100.0) * PWM_MAX_VALUE;
    
    // set pins to input mode, if value is actually zero
    if (channel_1_pwm_value == 0) DDRB &= 0b11111011;   //PB2 reset to input
    else DDRB |= 0b00000100;                            //PB2 set to output

    // set pins to input mode, if value is actually zero
    if (channel_2_pwm_value == 0) DDRB &= 0b11111101;   //PB1 reset to input
    else DDRB |= 0b00000010;                            //PB1 set to output

    // assign chan 1&2 values directly to PWM timers
    *(_self_waveform_gen.channel_1_output) = channel_1_pwm_value;
    *(_self_waveform_gen.channel_2_output) = channel_2_pwm_value;

    // chan 3 value must be handled differently so we can set the
    //  compare value at top of timer cycle. Also, offsetting the min
    //  value by 14 to allow for a zero percent duty cycle to be achieved
    _self_waveform_gen.channel_3_output = ((fmod(*(_self_waveform_gen.channel_target[2]), 100.0)/100.0) * (PWM_MAX_VALUE-14)) + 14;

}

// execute a callback on timer1 overflow
ISR(TIMER1_OVF_vect) {

    // mark time in light manager
    _self_waveform_gen.overflowCallback();

}

// Implement Channel 3 PWM Signal 
ISR(TIMER0_OVF_vect) {

    // if channel 3 value is below threshold,
    // do not turn on the output pin at all
    if (_self_waveform_gen.channel_3_output > 15) {

        // set channel 3 output pin at start of PWM cycle
        PORTB |= 0b00000001; 

    } else { 

        // keep output off if below threshold
        PORTB &= 0b11111110;
        _self_waveform_gen.channel_3_output = 15;

    }

    // set compare register value
    OCR0B = _self_waveform_gen.channel_3_output;
 
}

// Implement Channel 3 PWM Signal 
ISR(TIMER0_COMPB_vect) {

    // reset channel 3 output pin on compare match
    PORTB &= 0b11111110;

}