/**********************************************************************

  synchro_clock.c - 

  Authors: 
    Nate Fisher

  Created at: 
    Wed Oct 1, 2014

  <License> 
  <Copyright>

**********************************************************************/

#include "math.h"
#include "synchro_clock.h"

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
} SyncroClock _self_synchro_clock;

void SYNCLK_init(void);
double SYNCLK_getClockPosition(void);
void SYNCLK_updateClock(void);
void _SYNCLK_clockTick(void);
void _SYNCLK_clockSkip(void);
void _SYNCLK_recordPhaseError(void);
void _SYNCLK_setPhaseCorrectionStale(void);
void _SYNCLK_calcPhaseCorrection(void);



void SYNCLK_init(void) {
    // init instance members
    _self_synchro_clock->clockSkips                = 0;
    _self_synchro_clock->isPhaseCorrectionUpdated  = 1;
    _self_synchro_clock->isCommandFresh            = 0;
    _self_synchro_clock->nodePhaseError            = 0;
    _self_synchro_clock->nodeTimeOffset            = 0;
    _self_synchro_clock->nodeTime                  = 0;
}

double SYNCLK_getClockPosition(void) {

    return (_self_synchro_clock->nodeTime / _SYNCLK_CLOCK_TOP) * _TWO_PI;

}

void SYNCLK_updateClock(void) {

    // mark time in light manager
    _SYNCLK_clockTick();

    // phase correction can be updated
    _SYNCLK_setPhaseCorrectionStale();

}

void _SYNCLK_clockTick(void) {


    // adjust clock for phase error
    if (_self_synchro_clock->clockSkips > 0) { 
        _self_synchro_clock->clockSkips--;
        return;
    }

    // increment lighting pattern effect clock
    if (_self_synchro_clock->nodeTime < _SYNCLK_CLOCK_TOP) {
        _self_synchro_clock->nodeTime += _SYNCLK_TICK_INCREMENT;
    } else {
        _self_synchro_clock->nodeTime = _SYNCLK_CLOCK_RESET;
    } 

}

void _SYNCLK_clockSkip(void) {

    _self_synchro_clock->clockSkips++;

}

void _SYNCLK_recordPhaseError(void) {

    _self_synchro_clock->nodeTimeOffset = _self_synchro_clock->nodeTime;

}

void _SYNCLK_setPhaseCorrectionStale(void) {

    // recompute phase correction 
    //  in next mainloop
    _self_synchro_clock->isPhaseCorrectionUpdated = 0;
}

// calculate correction for phase error
// NOTE: user must limit execution to once per clock tick
void _SYNCLK_calcPhaseCorrection(void) {

    // phase correction already updated in this cycle
    if (_self_synchro_clock->isPhaseCorrectionUpdated) return;

    // calculate phase error if a phase signal received
    if (_self_synchro_clock->nodeTimeOffset != 0) {

        // device is behind system time
        // phase error is negative
        if (_self_synchro_clock->nodeTimeOffset >= _SYNCLK_CLOCK_TOP/2) {
            _self_synchro_clock->nodePhaseError = (_self_synchro_clock->nodeTimeOffset - _SYNCLK_CLOCK_TOP) / _SYNCLK_TICK_INCREMENT;

        // device is ahead of system time
        // phase error is positive
        } else {
            _self_synchro_clock->nodePhaseError = _self_synchro_clock->nodeTimeOffset / _SYNCLK_TICK_INCREMENT;
        }

        // do not calculate phaseError again until another phase signal received
        _self_synchro_clock->nodeTimeOffset = 0;

    }

    // only apply correction if magnitude is greater than threshold
    // to minimize some chasing
    if (fabs(_self_synchro_clock->nodePhaseError) >= _SYNCLK_CORRECTION_THRESHOLD) { 

        // if phase error negative, add an extra clock tick
        // if positive, remove a clock tick
        if (_self_synchro_clock->nodePhaseError < 0) {
            _SYNCLK_clockTick();
            _self_synchro_clock->nodePhaseError++;
        } else {
            _SYNCLK_clockSkip();
            _self_synchro_clock->nodePhaseError--;
        }        
        
    }

    // phase correction has been updated
    _self_synchro_clock->isPhaseCorrectionUpdated = 1;

}
