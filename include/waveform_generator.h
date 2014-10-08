/**********************************************************************

  waveform_generator.h - interacts with hardware timers and pwm
    generators to output a waveform as specified by the input 
    channel registers. 



  Authors: 
    Nate Fisher

  Created at: 
    Wed Oct 1, 2014

  <License> 
  <Copyright>

**********************************************************************/

#ifndef  WAVEFORM_GENERATOR_H
#define  WAVEFORM_GENERATOR_H

#define ZERO                  0b00000000

#define TCCR0A_CLOCK_FULL     0b00000001
#define TCCR0A_CLOCK_DIV8     0b00000010
#define TCCR0A_CLOCK_DIV64    0b00000011
#define TCCR0A_CLOCK_DIV1024  0b00000101

#define TIMSK0_OCIE0B         0b00000100
#define TIMSK0_OCIE0A         0b00000010
#define TIMSK0_TOIE0          0b00000001

#define TCCR1A_PWM_MODE       0b10100000
#define TCCR1A_FAST_PWM8      0b00000001

#define TCCR1B_FAST_PWM8      0b00001000
#define TCCR1B_CLOCK_FULL     0b00000001
#define TCCR1B_CLOCK_DIV8     0b00000010

#define TIMSK1_TOIE1          0b00000001

#define PWM_MAX_VALUE         100

typedef struct _Waveform_Generator_State {
    volatile uint8_t* channel_1_output;
    volatile uint8_t* channel_2_output;
    uint8_t channel_3_output;
    uint8_t channel_3_enable;
    uint8_t* channel_target[3];
    void (*overflowCallback)();
} WaveformGenerator;
WaveformGenerator _self_waveform_gen;

void WG_init(uint8_t**, int);
void WG_onOverflow(void(*)());
void WG_updatePWM(void);
void _WG_configureHardware(void);

#endif
