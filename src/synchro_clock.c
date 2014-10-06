/**********************************************************************

  synchro_clock.c - implementation, see header for description

  Authors: 
    Nate Fisher

  Created at: 
    Wed Oct 1, 2014

  <License> 
  <Copyright>

**********************************************************************/

#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/cpufunc.h>

#include <avr/io.h>
#include "math.h"
#include "synchro_clock.h"

#include "utilities.h"
  
void SYNCLK_init(void) {
    // init instance members
    _self_synchro_clock.clockSkips                = 0;
    _self_synchro_clock.isPhaseCorrectionUpdated  = 1;
    _self_synchro_clock.timerOverflows            = 0;
    _self_synchro_clock.isCommandFresh            = 0;
    _self_synchro_clock.nodePhaseError            = 0;
    _self_synchro_clock.nodeTimeOffset            = 0;
    _self_synchro_clock.nodeTime                  = 0;
}

// return clock position, in radians
double SYNCLK_getClockPosition(void) {

    return (_self_synchro_clock.nodeTime / _SYNCLK_CLOCK_TOP) * _TWO_PI;

}

// advance internal clock
void SYNCLK_updateClock(void) {

    // mark time in light manager
    _self_synchro_clock.timerOverflows++;

    // phase correction can be updated
    _self_synchro_clock.isPhaseCorrectionUpdated = 0;

}

// increment clock and also implement phase adjustment
void SYNCLK_procClockUpdate(void) {

    // adjust clock for phase error
    while (_self_synchro_clock.clockSkips && _self_synchro_clock.timerOverflows) {
            _self_synchro_clock.timerOverflows--;
            _self_synchro_clock.clockSkips--;
    }

    // advance this node's clock time
    while(_self_synchro_clock.timerOverflows > 0) {

        _self_synchro_clock.timerOverflows--;
        
        // increment lighting pattern effect clock
        if (_self_synchro_clock.nodeTime == (_SYNCLK_CLOCK_TOP - _SYNCLK_CLOCK_RESET)) {
            _self_synchro_clock.nodeTime = _SYNCLK_CLOCK_RESET;
        } else {
            _self_synchro_clock.nodeTime += _SYNCLK_TICK_INCREMENT;
        } 

    }

}

// calculate correction for phase error
// NOTE: user must limit execution to once 
//       per call to updateClock
void SYNCLK_calcPhaseCorrection(void) {

    // phase correction already updated in this cycle
    if (_self_synchro_clock.isPhaseCorrectionUpdated) return;

    // calculate phase error if a phase signal received
    if (_self_synchro_clock.nodeTimeOffset != 0) {

        // device is behind system time
        // phase error is negative
        if (_self_synchro_clock.nodeTimeOffset >= _SYNCLK_CLOCK_TOP/2) {
            _self_synchro_clock.nodePhaseError = (_self_synchro_clock.nodeTimeOffset - _SYNCLK_CLOCK_TOP) / _SYNCLK_TICK_INCREMENT;

        // device is ahead of system time
        // phase error is positive
        } else {
            _self_synchro_clock.nodePhaseError = _self_synchro_clock.nodeTimeOffset / _SYNCLK_TICK_INCREMENT;
        }

        // do not calculate phaseError again until another phase signal received
        _self_synchro_clock.nodeTimeOffset = 0;

    }

    // only apply correction if magnitude is greater than threshold
    // to minimize some chasing
    if (fabs(_self_synchro_clock.nodePhaseError) >= _SYNCLK_CORRECTION_THRESHOLD) { 

        int correction = fabs(_self_synchro_clock.nodePhaseError/2);

        // if phase error negative, add an extra clock tick
        // if positive, remove a clock tick
        if (_self_synchro_clock.nodePhaseError < 0) {
            _SYNCLK_clockTick(correction);
            _self_synchro_clock.nodePhaseError += correction;
        } else {
            _SYNCLK_clockSkip(correction);
            _self_synchro_clock.nodePhaseError -= correction;
        }        
        
    }

    // phase correction has been updated
    _self_synchro_clock.isPhaseCorrectionUpdated = 1;

}

// clock adjustment to be applied
//  if local phase is behind system
void _SYNCLK_clockTick(int count) {

    _self_synchro_clock.timerOverflows = count;

}

// clock adjustment to be applied
//  if local phase is ahead of system
void _SYNCLK_clockSkip(int count) {

    _self_synchro_clock.clockSkips = count;

}

// call on receipt of a phase correction
//  signal to record the local offset from
//  the system value
void SYNCLK_recordPhaseError(void) {

    _self_synchro_clock.nodeTimeOffset = _self_synchro_clock.nodeTime;

/*
    _self_synchro_clock.clockSkips                = 0;
    _self_synchro_clock.timerOverflows            = 0;
    _self_synchro_clock.nodePhaseError            = 0;
    _self_synchro_clock.nodeTimeOffset            = 0;
    _self_synchro_clock.nodeTime                  = 0;
*/
    
}
