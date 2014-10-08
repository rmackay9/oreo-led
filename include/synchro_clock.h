/**********************************************************************

  synchro_clock.h - a clock, at a speed defined in this header file,
    synchronizable to a phase correction signal. This means that if an
    external signal is supplied at some interval, this clock will
    temporarily adjust its speed to synchronize with the phase signal.

    
    To synch to a phase signal, first call recordPhaseError() when a phase
      signal is detected. then, perhaps at a later time, call 
      calcPhaseCorrection() to compute the adjustment required.

    To advance the clock, call updateClock(). Any phase adjustments which
      were previously computed will be automatically applied.


  Authors: 
    Nate Fisher

  Created: 
    Wed Oct 1, 2014

**********************************************************************/

#ifndef  SYNCHRO_CLOCK_H
#define  SYNCHRO_CLOCK_H

#include "utilities.h"

// TODO: make an init function to handle these calculations
// creates a period of exactly 4s with:
//  - ticks at 8Mhz/8/8/256 (= 488.28125 Hz)
//  - then 488.28125/s * 4s = 1953.125 ticks in 4s period
//  - increment by 32 each tick yields a clock size of 62500
static const double _SYNCLK_CLOCK_RESET             = 0;
static const double _SYNCLK_CLOCK_TOP               = 62500;
static const double _SYNCLK_TICK_INCREMENT          = 4;

// TODO: make a setter routine to adjust agressiveness
static const double _SYNCLK_CORRECTION_THRESHOLD    = 2;

// synchro clock state structure
typedef struct _Syncro_Clock_State {
    int clockSkips;
    char isPhaseCorrectionUpdated;
    char isCommandFresh;
    int16_t nodePhaseError;
    int16_t nodeTimeOffset;
    uint32_t nodeTime;
    void (*recordPhaseError)();
} SyncroClock;

// synchro clock singleton instance
SyncroClock _self_synchro_clock;

void SYNCLK_init(void);
double SYNCLK_getClockPosition(void);
void SYNCLK_updateClock(void);
void SYNCLK_recordPhaseError(void);
void SYNCLK_calcPhaseCorrection(void);
void _SYNCLK_clockTick(void);
void _SYNCLK_clockSkip(void);
void _SYNCLK_setPhaseCorrectionStale(void);

#endif
