/**********************************************************************

  light_pattern_protocol.h - implementation of communications interface
    agreed upon by lighting system users. This is the file which will be 
    updated when interface changes are required, and is not meant to be
    portable, but rather a very application-specific implementation.

  Authors: 
    Nate Fisher

  Created at: 
    Wed Oct 1, 2014

  <License> 
  <Copyright>

**********************************************************************/

#ifndef  LIGHT_PATTERN_PROTOCOL_H
#define  LIGHT_PATTERN_PROTOCOL_H

#include "pattern_generator.h"
#include "utilities.h"
  
typedef enum _Light_Protocol_Parameter {
    PARAM_BIAS_RED,
    PARAM_BIAS_GREEN,
    PARAM_BIAS_BLUE,
    PARAM_AMPLITUDE_RED,
    PARAM_AMPLITUDE_GREEN,
    PARAM_AMPLITUDE_BLUE,
    PARAM_PERIOD,
    PARAM_REPEAT,
    PARAM_PHASEOFFSET,
    PARAM_ENUM_COUNT
} LightProtocolParameter;

static const short int LightParameterSize[PARAM_ENUM_COUNT] = {
    1,  // Bias 
    1,  // Bias 
    1,  // Bias   
    1,  // Amp 
    1,  // Amp 
    1,  // Amp 
    2,  // Period
    1,  // Repeat
    2   // Phase Offset
};

typedef struct _Light_Pattern_Protocol {
    uint8_t isCommandFresh;
    PatternGenerator* redPattern;
    PatternGenerator* greenPattern;
    PatternGenerator* bluePattern;
} LightPatternProtocol;
LightPatternProtocol _self_pattern_protocol;

void LPP_setCommandRefreshed(void);
void LPP_setRedPatternGen(PatternGenerator*);
void LPP_setGreenPatternGen(PatternGenerator*);
void LPP_setBluePatternGen(PatternGenerator*);
void LPP_processBuffer(char*, int);
void _LPP_processParameterUpdate(PatternEnum, int, char*);
void _LPP_setPattern(int);

#endif
  