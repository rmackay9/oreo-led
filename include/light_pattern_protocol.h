/**********************************************************************

  light_pattern_protocol.h - implementation of communications interface
    agreed upon by lighting system users. This is the file which will be 
    updated when interface changes are required, and is not meant to be
    portable, but rather a very application-specific implementation.


  Authors: 
    Nate Fisher

  Created: 
    Wed Oct 1, 2014

**********************************************************************/

#ifndef  LIGHT_PATTERN_PROTOCOL_H
#define  LIGHT_PATTERN_PROTOCOL_H

#include "pattern_generator.h"
#include "utilities.h"

// for use in solo oreoleds, this numver must match the period defined 
//   in the synchro clock header
#define MAX_PATTERN_PERIOD 4000.0

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
    PARAM_MACRO,
    PARAM_ENUM_COUNT
} LightProtocolParameter;

typedef enum _Light_Param_Macro {
    PARAM_MACRO_RESET,
    PARAM_MACRO_FWUPDATE,
    PARAM_MACRO_AUTOPILOT,
    PARAM_MACRO_CALIBRATE,
    PARAM_MACRO_POWERON,
    PARAM_MACRO_POWEROFF,
    PARAM_MACRO_RED,
    PARAM_MACRO_GREEN,
    PARAM_MACRO_BLUE,
    PARAM_MACRO_AMBER,
    PARAM_MACRO_WHITE,
    PARAM_MACRO_ENUM_COUNT
} LightParamMacro;

static const short int LightParameterSize[PARAM_ENUM_COUNT] = {
    1,  // Bias 
    1,  // Bias 
    1,  // Bias   
    1,  // Amp 
    1,  // Amp 
    1,  // Amp 
    2,  // Period
    1,  // Repeat
    2,  // Phase Offset
    1   // Param Macro
};

typedef struct _Light_Pattern_Protocol {
    uint8_t isCommandFresh;
    PatternGenerator* redPattern;
    PatternGenerator* greenPattern;
    PatternGenerator* bluePattern;
} LightPatternProtocol;

void LPP_setCommandRefreshed(void);
void LPP_setRedPatternGen(PatternGenerator*);
void LPP_setGreenPatternGen(PatternGenerator*);
void LPP_setBluePatternGen(PatternGenerator*);
void LPP_processBuffer(char*, int);
void _LPP_processParameterUpdate(LightProtocolParameter, int, char*);
void _LPP_setPattern(int);
void _LPP_setParamMacro(LightParamMacro);

#endif
  