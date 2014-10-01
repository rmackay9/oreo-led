/**********************************************************************

  pattern_generator.c - 

  Authors: 
    Nate Fisher

  Created at: 
    Wed Oct 1, 2014

  <License> 
  <Copyright>

**********************************************************************/

#include "pattern_generator.h"
#include "math.h"

void PG_init(PatternGenerator* self) {
    
    self->cyclesRemaining     = 0; 
    self->theta               = 0;
    self->isNewCycle          = 0;
    self->pattern             = PATTERN_OFF;
    self->speed               = 0;
    self->phase               = 0;
    self->amplitude           = 0;
    self->bias                = 0;
    self->value               = 0;

}

void PG_calc(PatternGenerator* self, double clock_position) { 

    // update pattern instance theta 
    _PG_calcTheta(self, clock_position);

    // update pattern value
    switch(self->pattern) {

        case PATTERN_SINE: 
            _PG_patternSine(self); 
            break;
        case PATTERN_STROBE: 
            _PG_patternStrobe(self); 
            break;
        case PATTERN_SIREN: 
            _PG_patternSiren(self); 
            break;
        case PATTERN_SOLID: 
            _PG_patternSolid(self); 
            break;
        case PATTERN_FADEOUT: 
            _PG_patternFadeOut(self); 
            break;
        case PATTERN_FADEIN: 
            _PG_patternFadeIn(self); 
            break;
        case PATTERN_OFF:
        default: 
            _PG_patternOff(self);

    }

}

// PRIVATE METHODS BELOW

void _PG_calcTheta(PatternGenerator* self, double clock_position) {

    // calculate theta, in radians, from the current timer
    double theta_at_speed = clock_position * self->speed;

    // calculate the speed and phase adjusted theta
    double new_theta = fmod(theta_at_speed + Util_degToRad(self->phase), _TWO_PI);

    // set zero crossing flag
    self->isNewCycle = (self->theta > new_theta) ? 1 : 0;

    // set pattern theta
    self->theta = new_theta;

}

void _PG_patternOff(PatternGenerator* self) {

    self->value = 0; 

}

void _PG_patternSolid(PatternGenerator* self) {

    self->value = self->bias;

}

void _PG_patternStrobe(PatternGenerator* self) {

    // calculate the carrier signal 
    // as square wave
    double carrier = (sin(self->theta) > 0) ? 1 : 0;

    // value is a square wave with an 
    // adjustable amplitude and bias
    self->value = self->bias + self->amplitude * carrier;

}

void _PG_patternSine(PatternGenerator* self) {

    // calculate the carrier signal 
    double carrier = sin(self->theta);

    // value is a sin function output of the form
    // B + A * sin(theta)
    self->value = self->bias + self->amplitude * carrier;

}

void _PG_patternSiren(PatternGenerator* self) {

    // calculate the carrier signal 
    double carrier = sin(tan(self->theta)*.5);

    // value is an annoying strobe-like pattern
    self->value = self->bias + self->amplitude * carrier;

}

void _PG_patternFadeIn(PatternGenerator* self) {

    if (self->cyclesRemaining >= 0) {

        // calculate the carrier signal 
        double carrier = sin(self->theta/4);

        // start pattern with output low
        if (self->cyclesRemaining >= 1) {

            self->output = 0; 
        
        } else {

            // not done with current cycle
            if (!self->isNewCycle) {

                // update output
                self->output = self->amplitude * carrier;

            }

        }

        // decrement the cycles remaining 
        if (self->isNewCycle) self->cyclesRemaining--;

    // finish pattern with value high
    } else {

        self->output = self->amplitude;

    }

}

void _PG_patternFadeOut(PatternGenerator* self) {

    if (self->cyclesRemaining >= 0) {

        // calculate the carrier signal 
        double carrier = cos(self->theta/4);

        // start pattern with output high 
        if (self->cyclesRemaining >= 1) {

            self->output = self->amplitude; 
        
        } else {

            // not done with current cycle
            if (!self->isNewCycle) {

                // update output
                self->output = self->amplitude * carrier;

            }

        }

        // decrement the cycles remaining at each zero crossing
        if (self->isNewCycle) self->cyclesRemaining--;

    // finish pattern with value zero
    } else {

        self->output = 0;

    }

}
