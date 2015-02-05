/**********************************************************************

  light_pattern_protocol.c - implementation, see header for description


  Authors: 
    Nate Fisher

  Created: 
    Wed Oct 1, 2014

**********************************************************************/

#include <avr/io.h>
#include "light_pattern_protocol.h"
#include "pattern_generator.h"
#include "utilities.h"
#include "node_manager.h"

// module singleton
static LightPatternProtocol _self_pattern_protocol;

void LPP_setRedPatternGen(PatternGenerator* pattern) { 

    _self_pattern_protocol.redPattern = pattern; 

}

void LPP_setGreenPatternGen(PatternGenerator* pattern) { 

    _self_pattern_protocol.greenPattern = pattern; 

}

void LPP_setBluePatternGen(PatternGenerator* pattern) { 

    _self_pattern_protocol.bluePattern = pattern; 

}
        
void LPP_processBuffer(char* twiCommandBuffer, int size) {

    // if command is new, re-parse
    // ensure valid length buffer
    // ensure pointer is valid
    if (twiCommandBuffer && 
        size > 0 &&
        _self_pattern_protocol.isCommandFresh) {

        // set pattern if command is not a param-only command
        if (twiCommandBuffer[0] != PATTERN_PARAMUPDATE)
            _LPP_setPattern( twiCommandBuffer[0] );

        // cycle through remaining params
        // beginning with first param (following pattern byte)
        int buffer_pointer = 1;
        while (buffer_pointer < size) {

            // digest parameters serially
            PatternEnum currParam;

            // ensure parameter is valid, stop parsing if invalid
            //    this means that part of a message can be parsed, until
            //    an invalid parameter is seen
            if (twiCommandBuffer[buffer_pointer] < PARAM_ENUM_COUNT &&
                twiCommandBuffer[buffer_pointer] >= 0) {

                currParam = twiCommandBuffer[buffer_pointer];

            } else {

                break;

            }

            // get size of parameter value
            int paramSize = LightParameterSize[currParam];

            // ensure buffer is long enough
            //   stop parsing if remaining buffer length does 
            //   not have enough room for this parameter
            //   ('size-1' accounts for pattern byte)
            if (buffer_pointer + paramSize > size-1) break;

            // implement parameter+value update 
            _LPP_processParameterUpdate(currParam, buffer_pointer+1, twiCommandBuffer);

            // advance pointer
            buffer_pointer += paramSize + 1;

        }

    }

    // signal command has been parsed
    _self_pattern_protocol.isCommandFresh = 0;

}

void LPP_setCommandRefreshed() {

    _self_pattern_protocol.isCommandFresh = 1;

}

void _LPP_setPattern(int patternEnum) {

    // if changing to fadein/fadeout, set cycles to 1
    // TODO create a more robust method of setting defaults
    if (_self_pattern_protocol.greenPattern->pattern != patternEnum &&
        ((patternEnum == PATTERN_FADEIN) | 
         (patternEnum == PATTERN_FADEOUT))) {

            _self_pattern_protocol.redPattern->cyclesRemaining = 1;
            _self_pattern_protocol.greenPattern->cyclesRemaining = 1;
            _self_pattern_protocol.bluePattern->cyclesRemaining = 1;

    }

    // assign each light pattern 
    _self_pattern_protocol.redPattern->pattern = patternEnum;
    _self_pattern_protocol.greenPattern->pattern = patternEnum;
    _self_pattern_protocol.bluePattern->pattern = patternEnum;

}

void _LPP_processParameterUpdate(LightProtocolParameter param, int start, char* buffer) {

    // validate arguments
    if (!buffer) return;

    // temp storage variables to reduce calculations
    // in each case statement
    uint16_t received_uint;
    uint16_t received_uint_radians;
    
    switch(param) {

        case PARAM_BIAS_RED: 
            _self_pattern_protocol.redPattern->bias = buffer[start];
            break;

        case PARAM_BIAS_GREEN: 
            _self_pattern_protocol.greenPattern->bias = buffer[start];
            break;

        case PARAM_BIAS_BLUE: 
            _self_pattern_protocol.bluePattern->bias = buffer[start];
            break;

        case PARAM_AMPLITUDE_RED: 
            _self_pattern_protocol.redPattern->amplitude = buffer[start];
            break;

        case PARAM_AMPLITUDE_GREEN: 
            _self_pattern_protocol.greenPattern->amplitude = buffer[start];
            break;

        case PARAM_AMPLITUDE_BLUE: 
            _self_pattern_protocol.bluePattern->amplitude = buffer[start];
            break;

        case PARAM_PERIOD: 
            received_uint = UTIL_charToInt(buffer[start], buffer[start+1]);
            _self_pattern_protocol.redPattern->speed    = MAX_PATTERN_PERIOD / received_uint;
            _self_pattern_protocol.greenPattern->speed  = MAX_PATTERN_PERIOD / received_uint;
            _self_pattern_protocol.bluePattern->speed   = MAX_PATTERN_PERIOD / received_uint;
            break;

        case PARAM_REPEAT: 
            _self_pattern_protocol.redPattern->cyclesRemaining    = buffer[start];
            _self_pattern_protocol.greenPattern->cyclesRemaining  = buffer[start];
            _self_pattern_protocol.bluePattern->cyclesRemaining   = buffer[start];
            break;

        case PARAM_PHASEOFFSET: 
            received_uint_radians = UTIL_degToRad(UTIL_charToInt(buffer[start], buffer[start+1]));
            _self_pattern_protocol.redPattern->phase    = received_uint_radians;
            _self_pattern_protocol.greenPattern->phase  = received_uint_radians;
            _self_pattern_protocol.bluePattern->phase   = received_uint_radians;
            break;

        case PARAM_MACRO:
            if (buffer[start] < PARAM_MACRO_ENUM_COUNT)
                _LPP_setParamMacro(buffer[start]);
            break;

        default:
            break;
    }

}

// Pre-canned patterns and setting combinations
// tuned through testing on lighting hardware
void _LPP_setParamMacro(LightParamMacro macro) {
    
    switch(macro) {

        case PARAM_MACRO_FWUPDATE:
            _self_pattern_protocol.redPattern->cyclesRemaining      = CYCLES_INFINITE;
            _self_pattern_protocol.greenPattern->cyclesRemaining    = CYCLES_INFINITE;
            _self_pattern_protocol.bluePattern->cyclesRemaining     = CYCLES_INFINITE;

            _self_pattern_protocol.redPattern->speed                = 1;
            _self_pattern_protocol.greenPattern->speed              = 1;
            _self_pattern_protocol.bluePattern->speed               = 1;

            _self_pattern_protocol.redPattern->phase                = UTIL_degToRad(270 + NODE_getId()*30);
            _self_pattern_protocol.greenPattern->phase              = UTIL_degToRad(90  + NODE_getId()*30);
            _self_pattern_protocol.bluePattern->phase               = UTIL_degToRad(180 + NODE_getId()*30);

            _self_pattern_protocol.redPattern->amplitude            = 120;
            _self_pattern_protocol.redPattern->bias                 = 120;
            _self_pattern_protocol.greenPattern->amplitude          = 50;
            _self_pattern_protocol.greenPattern->bias               = 50;
            _self_pattern_protocol.bluePattern->amplitude           = 70;
            _self_pattern_protocol.bluePattern->bias                = 70;

            _LPP_setPattern(PATTERN_SINE);
            break;
            
        case PARAM_MACRO_AUTOPILOT:
            // USES PREVIOUSLY SET BIAS/AMPLITUDE
            // AUTOPILOT MACRO SHOULD BE CALLED AFTER
            // A COLOR SETTING HAS BEEN ISSUED

            _self_pattern_protocol.redPattern->cyclesRemaining      = CYCLES_INFINITE;
            _self_pattern_protocol.greenPattern->cyclesRemaining    = CYCLES_INFINITE;
            _self_pattern_protocol.bluePattern->cyclesRemaining     = CYCLES_INFINITE;

            _self_pattern_protocol.redPattern->speed                = 2;
            _self_pattern_protocol.greenPattern->speed              = 2;
            _self_pattern_protocol.bluePattern->speed               = 2;

            _self_pattern_protocol.redPattern->phase                = 0;
            _self_pattern_protocol.greenPattern->phase              = 0;
            _self_pattern_protocol.bluePattern->phase               = 0;

            _LPP_setPattern(PATTERN_SINE);
            break;
            
        case PARAM_MACRO_CALIBRATE:
            _self_pattern_protocol.redPattern->cyclesRemaining      = CYCLES_INFINITE;
            _self_pattern_protocol.greenPattern->cyclesRemaining    = CYCLES_INFINITE;
            _self_pattern_protocol.bluePattern->cyclesRemaining     = CYCLES_INFINITE;

            _self_pattern_protocol.redPattern->speed                = 12;
            _self_pattern_protocol.greenPattern->speed              = 12;
            _self_pattern_protocol.bluePattern->speed               = 12;

            _self_pattern_protocol.redPattern->phase                = 0;
            _self_pattern_protocol.greenPattern->phase              = 0;
            _self_pattern_protocol.bluePattern->phase               = 0;

            _self_pattern_protocol.redPattern->bias                 = 0;
            _self_pattern_protocol.greenPattern->bias               = 0;
            _self_pattern_protocol.bluePattern->bias                = 0;

            _LPP_setPattern(PATTERN_STROBE);
            break;
            
        case PARAM_MACRO_POWERON:
            _self_pattern_protocol.redPattern->cyclesRemaining      = 1;
            _self_pattern_protocol.greenPattern->cyclesRemaining    = 1;
            _self_pattern_protocol.bluePattern->cyclesRemaining     = 1;

            _self_pattern_protocol.redPattern->speed                = 2;
            _self_pattern_protocol.greenPattern->speed              = 2;
            _self_pattern_protocol.bluePattern->speed               = 2;

            _self_pattern_protocol.redPattern->phase                = 0;
            _self_pattern_protocol.greenPattern->phase              = 0;
            _self_pattern_protocol.bluePattern->phase               = 0;

            // front ESCs power on as white
            // rear ESCs power on as red
            if (NODE_getId() == 2 || NODE_getId() == 3) {
                _self_pattern_protocol.redPattern->amplitude            = 115;
                _self_pattern_protocol.redPattern->bias                 = 120;
                _self_pattern_protocol.greenPattern->amplitude          = 95;
                _self_pattern_protocol.greenPattern->bias               = 100;
                _self_pattern_protocol.bluePattern->amplitude           = 27;
                _self_pattern_protocol.bluePattern->bias                = 30;
            } else {
                _self_pattern_protocol.redPattern->amplitude            = 115;
                _self_pattern_protocol.redPattern->bias                 = 120;
                _self_pattern_protocol.greenPattern->amplitude          = 0;
                _self_pattern_protocol.greenPattern->bias               = 0;
                _self_pattern_protocol.bluePattern->amplitude           = 0;
                _self_pattern_protocol.bluePattern->bias                = 0;
            }

            _LPP_setPattern(PATTERN_FADEIN);
            break;
            
        case PARAM_MACRO_POWEROFF:
            _self_pattern_protocol.redPattern->cyclesRemaining      = 1;
            _self_pattern_protocol.greenPattern->cyclesRemaining    = 1;
            _self_pattern_protocol.bluePattern->cyclesRemaining     = 1;

            _self_pattern_protocol.redPattern->speed                = 2;
            _self_pattern_protocol.greenPattern->speed              = 2;
            _self_pattern_protocol.bluePattern->speed               = 2;

            _self_pattern_protocol.redPattern->phase                = 0;
            _self_pattern_protocol.greenPattern->phase              = 0;
            _self_pattern_protocol.bluePattern->phase               = 0;

            _self_pattern_protocol.redPattern->amplitude            = _self_pattern_protocol.redPattern->value;
            _self_pattern_protocol.redPattern->bias                 = 0;
            _self_pattern_protocol.greenPattern->amplitude          = _self_pattern_protocol.greenPattern->value;
            _self_pattern_protocol.greenPattern->bias               = 0;
            _self_pattern_protocol.bluePattern->amplitude           = _self_pattern_protocol.bluePattern->value;
            _self_pattern_protocol.bluePattern->bias                = 0;

            _LPP_setPattern(PATTERN_FADEOUT);
            break;
            
        case PARAM_MACRO_RED:
            _self_pattern_protocol.redPattern->cyclesRemaining      = CYCLES_INFINITE;
            _self_pattern_protocol.greenPattern->cyclesRemaining    = CYCLES_INFINITE;
            _self_pattern_protocol.bluePattern->cyclesRemaining     = CYCLES_INFINITE;
            
            _self_pattern_protocol.redPattern->speed                = 1;
            _self_pattern_protocol.greenPattern->speed              = 1;
            _self_pattern_protocol.bluePattern->speed               = 1;

            _self_pattern_protocol.redPattern->phase                = 0;
            _self_pattern_protocol.greenPattern->phase              = 0;
            _self_pattern_protocol.bluePattern->phase               = 0;

            _self_pattern_protocol.redPattern->amplitude            = 115;
            _self_pattern_protocol.redPattern->bias                 = 120;
            _self_pattern_protocol.greenPattern->amplitude          = 0;
            _self_pattern_protocol.greenPattern->bias               = 0;
            _self_pattern_protocol.bluePattern->amplitude           = 0;
            _self_pattern_protocol.bluePattern->bias                = 0;

            _LPP_setPattern(PATTERN_SOLID);
            break;
            
        case PARAM_MACRO_GREEN:
            _self_pattern_protocol.redPattern->cyclesRemaining      = CYCLES_INFINITE;
            _self_pattern_protocol.greenPattern->cyclesRemaining    = CYCLES_INFINITE;
            _self_pattern_protocol.bluePattern->cyclesRemaining     = CYCLES_INFINITE;

            _self_pattern_protocol.redPattern->speed                = 1;
            _self_pattern_protocol.greenPattern->speed              = 1;
            _self_pattern_protocol.bluePattern->speed               = 1;

            _self_pattern_protocol.redPattern->phase                = 0;
            _self_pattern_protocol.greenPattern->phase              = 0;
            _self_pattern_protocol.bluePattern->phase               = 0;

            _self_pattern_protocol.redPattern->amplitude            = 0;
            _self_pattern_protocol.redPattern->bias                 = 0;
            _self_pattern_protocol.greenPattern->amplitude          = 115;
            _self_pattern_protocol.greenPattern->bias               = 120;
            _self_pattern_protocol.bluePattern->amplitude           = 0;
            _self_pattern_protocol.bluePattern->bias                = 0;

            _LPP_setPattern(PATTERN_SOLID);
            break;
            
        case PARAM_MACRO_BLUE:
            _self_pattern_protocol.redPattern->cyclesRemaining      = CYCLES_INFINITE;
            _self_pattern_protocol.greenPattern->cyclesRemaining    = CYCLES_INFINITE;
            _self_pattern_protocol.bluePattern->cyclesRemaining     = CYCLES_INFINITE;
            
            _self_pattern_protocol.redPattern->speed                = 1;
            _self_pattern_protocol.greenPattern->speed              = 1;
            _self_pattern_protocol.bluePattern->speed               = 1;

            _self_pattern_protocol.redPattern->phase                = 0;
            _self_pattern_protocol.greenPattern->phase              = 0;
            _self_pattern_protocol.bluePattern->phase               = 0;

            _self_pattern_protocol.redPattern->amplitude            = 0;
            _self_pattern_protocol.redPattern->bias                 = 0;
            _self_pattern_protocol.greenPattern->amplitude          = 0;
            _self_pattern_protocol.greenPattern->bias               = 0;
            _self_pattern_protocol.bluePattern->amplitude           = 115;
            _self_pattern_protocol.bluePattern->bias                = 120;

            _LPP_setPattern(PATTERN_SOLID);
            break;
            
        case PARAM_MACRO_AMBER:
            _self_pattern_protocol.redPattern->cyclesRemaining      = CYCLES_INFINITE;
            _self_pattern_protocol.greenPattern->cyclesRemaining    = CYCLES_INFINITE;
            _self_pattern_protocol.bluePattern->cyclesRemaining     = CYCLES_INFINITE;
            
            _self_pattern_protocol.redPattern->speed                = 1;
            _self_pattern_protocol.greenPattern->speed              = 1;
            _self_pattern_protocol.bluePattern->speed               = 1;

            _self_pattern_protocol.redPattern->phase                = 0;
            _self_pattern_protocol.greenPattern->phase              = 0;
            _self_pattern_protocol.bluePattern->phase               = 0;

            _self_pattern_protocol.redPattern->amplitude            = 115;
            _self_pattern_protocol.redPattern->bias                 = 120;
            _self_pattern_protocol.greenPattern->amplitude          = 45;
            _self_pattern_protocol.greenPattern->bias               = 50;
            _self_pattern_protocol.bluePattern->amplitude           = 0;
            _self_pattern_protocol.bluePattern->bias                = 0;

            _LPP_setPattern(PATTERN_SOLID);
            break;
            
        case PARAM_MACRO_WHITE:
            _self_pattern_protocol.redPattern->cyclesRemaining      = CYCLES_INFINITE;
            _self_pattern_protocol.greenPattern->cyclesRemaining    = CYCLES_INFINITE;
            _self_pattern_protocol.bluePattern->cyclesRemaining     = CYCLES_INFINITE;
            
            _self_pattern_protocol.redPattern->speed                = 1;
            _self_pattern_protocol.greenPattern->speed              = 1;
            _self_pattern_protocol.bluePattern->speed               = 1;

            _self_pattern_protocol.redPattern->phase                = 0;
            _self_pattern_protocol.greenPattern->phase              = 0;
            _self_pattern_protocol.bluePattern->phase               = 0;

            _self_pattern_protocol.redPattern->amplitude            = 115;
            _self_pattern_protocol.redPattern->bias                 = 120;
            _self_pattern_protocol.greenPattern->amplitude          = 95;
            _self_pattern_protocol.greenPattern->bias               = 100;
            _self_pattern_protocol.bluePattern->amplitude           = 27;
            _self_pattern_protocol.bluePattern->bias                = 30;

            _LPP_setPattern(PATTERN_SOLID);
            break;

        case PARAM_MACRO_RESET:
            PG_init(_self_pattern_protocol.redPattern);
            PG_init(_self_pattern_protocol.greenPattern);
            PG_init(_self_pattern_protocol.bluePattern);
            break;

        default:
            break;

    }

}
