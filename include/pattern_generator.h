/**********************************************************************

  pattern_generator.h - a set of utilities to generate parametrically
    driven patterns. The time domain for the pattern must be updated
    via the theta parameter. In addition, phase and speed can be 
    specified, which will be used to adjust the specified theta value.
    Computation of patterns generally follows the convention: 

        value = bias + amplitude * f(x)

    ...where x is some speed and phase adjusted time domain 
    ...where f() is a carrier function determined by the pattern 



  Authors: 
    Nate Fisher

  Created: 
    Wed Oct 1, 2014

**********************************************************************/

#ifndef  PATTERN_GENERATOR_H
#define  PATTERN_GENERATOR_H

#include "utilities.h"

static const int CYCLES_INFINITE = -2;
static const int CYCLES_STOP = -1;

typedef enum _Pattern_Enum {
    PATTERN_OFF, 
    PATTERN_SINE, 
    PATTERN_SOLID,
    PATTERN_SIREN,
    PATTERN_STROBE,
    PATTERN_FADEIN, 
    PATTERN_FADEOUT,
    PATTERN_PARAMUPDATE,
    PATTERN_ENUM_COUNT
} PatternEnum;

typedef struct _Pattern_Generator_State {
    
    int cyclesRemaining; 
    PatternEnum pattern;
    double theta;
    double speed;
    double phase;
    double amplitude;
    double bias;
    uint8_t value;
    char isNewCycle;

} PatternGenerator;

void PG_init(PatternGenerator*);
void PG_calc(PatternGenerator*, double);
void _PG_calcTheta(PatternGenerator*, double);
void _PG_patternOff(PatternGenerator*);
void _PG_patternSolid(PatternGenerator*);
void _PG_patternStrobe(PatternGenerator*);
void _PG_patternSine(PatternGenerator*);
void _PG_patternSiren(PatternGenerator*);
void _PG_patternFadeIn(PatternGenerator*);
void _PG_patternFadeOut(PatternGenerator*);

#endif
