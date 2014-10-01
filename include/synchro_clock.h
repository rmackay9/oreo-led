/**********************************************************************

  synchro_clock.h - 

  Authors: 
    Nate Fisher

  Created at: 
    Wed Oct 1, 2014

  <License> 
  <Copyright>

**********************************************************************/

#ifndef  SYNCHRO_CLOCK_H
#define  SYNCHRO_CLOCK_H

// TODO: make an init function to handle these calculations
// creates a period of exactly 4s with:
//  - ticks at 8Mhz/8/8/256 (= 488.28125 Hz)
//  - then 488.28125/s * 4s = 1953.125 ticks in 4s period
//  - increment by 32 each tick yields a clock size of 62500
static const double _SYNCLK_CLOCK_RESET             = 0;
static const double _SYNCLK_CLOCK_TOP               = 62500;
static const double _SYNCLK_TICK_INCREMENT          = 32;

// TODO: make setter routine to adjust agressiveness
static const double _SYNCLK_CORRECTION_THRESHOLD    = 2;

// TODO: extern these
static const double     _PI= 3.1415926535897932384626433;
static const double _TWO_PI= 6.2831853071795864769252867;

// Clock singleton instance
typedef struct _Syncro_Clock_State {
    int clockSkips;
    char isPhaseCorrectionUpdated;
    char isCommandFresh;
    int16_t nodePhaseError;
    int16_t nodeTimeOffset;
    uint32_t nodeTime;
    void (*recordPhaseError)();
} SyncroClock;
SyncroClock _self_synchro_clock;

void SYNCLK_init(void);
double SYNCLK_getClockPosition(void);
void SYNCLK_updateClock(void);
void _SYNCLK_clockTick(void);
void _SYNCLK_clockSkip(void);
void _SYNCLK_recordPhaseError(void);
void _SYNCLK_setPhaseCorrectionStale(void);
void _SYNCLK_calcPhaseCorrection(void);

#endif
