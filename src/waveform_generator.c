/**********************************************************************

  waveform_generator.c - implementation, see header for description


  Authors: 
    Nate Fisher

  Created: 
    Wed Oct 1, 2014

**********************************************************************/

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/cpufunc.h>
#include "math.h"
#include "waveform_generator.h"

// private module singleton instance
static WaveformGenerator _self_waveform_gen;

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

    // configure PWM port B pins as output
    // and set level to LOW
    DDRB    |= 0b00000111; // 0 == input | 1 == output
    PORTB    = 0;

    // TIMER1 Config - Ch1 and Ch2 hardware PWM output
    // timer clock speed sets ch1/ch2 PWM frequency to about 3.96kHz
    //   ..FAST_PWM8 mode sets TOP to 0xFF; sets output pins at TOP
    //   ..PWM_MODE clears output pins when counter equals OCR1x
    //   ..CLOCK_DIV8 sets timer count speed to 1MHz (yields ~4Khz PWM freq)
    TCCR1A = ZERO | TCCR1A_PWM_MODE | TCCR1A_FAST_PWM8;
    TCCR1B = ZERO | TCCR1B_FAST_PWM8 | TCCR1B_CLOCK_DIV8;

    // TIMER1 Interrupts
    // overflow interrupt 
    TIMSK1 = ZERO | TIMSK1_TOIE1;

    // TIMER0 Config - Ch3 bit banged PWM output
    // ..CLOCK_DIV64 sets timer clock speed to about 488Hz
    //   The DIV64 setting was determined to be much more reliable 
    //   than faster speeds, which would create more interrupts
    TCCR0A = ZERO | TCCR0A_CLOCK_DIV64;

    // TIMER0 Interrupts
    // output compare match interrupt
    TIMSK0 = ZERO | TIMSK0_TOIE0 | TIMSK0_OCIE0B;

}


// update PWM duty cycle values per the channel target
//  values, which are stored as percentages
void WG_updatePWM(void) {

    // rescale channel values to the PWM_MAX_VALUE
    // because the PWM value registers are 8-bit (Fast PWM 8-bit mode), the
    // maximum possible command duty cycle is computed as a percentage
    // of (PWM_MAX_VALUE / 256) * 100
    //
    //  Rational: having the channel targets exist as 8-bit values gives the maximum possible resolution
    //  on the user side of the system, yielding input values of 0-255. However, this value should still be 
    //  scaled to the maximum physical duty cycle (presented to LEDs) mandated by hardware.
    //  Using fmod() here to enforce an input upper limit.
    //
    int channel_1_pwm_value = (fmod(*(_self_waveform_gen.channel_target[0]), 256.0)/256.0) * PWM_MAX_VALUE;
    int channel_2_pwm_value = (fmod(*(_self_waveform_gen.channel_target[1]), 256.0)/256.0) * PWM_MAX_VALUE;
    // the third (non hardware PWM channel) should be offset by 10 (never a zero value)
    // to implement the lower threshold for 'full off' 
    int channel_3_pwm_value = (fmod(*(_self_waveform_gen.channel_target[2]), 256.0)/256.0) * (PWM_MAX_VALUE-10) + 10;

    // assign chan1& chan2 values directly to PWM timers
    *(_self_waveform_gen.channel_1_output) = channel_1_pwm_value;
    *(_self_waveform_gen.channel_2_output) = channel_2_pwm_value;

    // The following GPIO direction settings are implemented
    //  to ensure that a commanded output value of '0' yields a 
    //  truly 0% duty cycle. Without this protection, the PWM gen
    //  will actually either (1) blip the output pin high before 
    //  reaching the OCRx value, or (2) miss the OCRx value completely
    //  and produce a 100% duty cycle. Either condition is not desireable


    // set pins to input mode, if value is actually zero
    if (channel_1_pwm_value == 0) DDRB &= 0b11111011;   //PB2 reset to input
    else DDRB |= 0b00000100;                            //PB2 set to output

    // set pins to input mode, if value is actually zero
    if (channel_2_pwm_value == 0) DDRB &= 0b11111101;   //PB1 reset to input
    else DDRB |= 0b00000010;                            //PB1 set to output

    // The following is a similar implementation of the above thresholding logic
    //  but for the (non-hardware pwm) ch3 output

    // assign channel 3 value to a proxy
    _self_waveform_gen.channel_3_output = channel_3_pwm_value;
    
    // implement a lower threshold for channel3 to enable full off
    _self_waveform_gen.channel_3_enable = (_self_waveform_gen.channel_3_output > 10) ? 1 : 0;


}




// execute a callback on timer1 overflow
ISR(TIMER1_OVF_vect) {

    // mark time in light manager, this advances the 
    // animation clock
    if (_self_waveform_gen.overflowCallback)
        _self_waveform_gen.overflowCallback();
 
}

ISR(TIMER0_OVF_vect) {

    // set compare register value
    OCR0B = _self_waveform_gen.channel_3_output;

    // if channel 3 value is below threshold,
    // do not turn on the output pin at all
    if (_self_waveform_gen.channel_3_enable) {
        // set channel 3 output pin at start of PWM cycle
        PORTB |= 0b00000001; 
    } else { 
        // keep output off if below threshold
        PORTB &= 0b11111110;
    }

}

// Implement Channel 3 PWM Signal 
ISR(TIMER0_COMPB_vect) {

    // reset channel 3 output pin on compare match
    PORTB &= 0b11111110;

}