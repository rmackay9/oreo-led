/**********************************************************************

  light_pattern_protocol.c - implementation, see header for description

  Authors: 
    Nate Fisher

  Created at: 
    Wed Oct 1, 2014

  <License> 
  <Copyright>

**********************************************************************/

#include <avr/io.h>
#include "light_pattern_protocol.h"
#include "pattern_generator.h"
#include "utilities.h"

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
            //process(currParam, start, stop, buffer);
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
    _self_pattern_protocol.redPattern->pattern = patternEnum;
    _self_pattern_protocol.greenPattern->pattern = patternEnum;
    _self_pattern_protocol.bluePattern->pattern = patternEnum;
}

void _LPP_processParameterUpdate(PatternEnum param, int start, char* buffer) {

    // validate arguments
    if (!buffer) return;

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
            _self_pattern_protocol.redPattern->speed    = 4000.0 / UTIL_charToInt(buffer[start], buffer[start+1]);
            _self_pattern_protocol.greenPattern->speed  = 4000.0 / UTIL_charToInt(buffer[start], buffer[start+1]);
            _self_pattern_protocol.bluePattern->speed   = 4000.0 / UTIL_charToInt(buffer[start], buffer[start+1]);
            break;

        case PARAM_REPEAT: 
            _self_pattern_protocol.redPattern->cyclesRemaining    = buffer[start];
            _self_pattern_protocol.greenPattern->cyclesRemaining  = buffer[start];
            _self_pattern_protocol.bluePattern->cyclesRemaining   = buffer[start];
            break;

        case PARAM_PHASEOFFSET: 
            _self_pattern_protocol.redPattern->phase    = UTIL_degToRad(UTIL_charToInt(buffer[start], buffer[start+1]));
            _self_pattern_protocol.greenPattern->phase  = UTIL_degToRad(UTIL_charToInt(buffer[start], buffer[start+1]));
            _self_pattern_protocol.bluePattern->phase   = UTIL_degToRad(UTIL_charToInt(buffer[start], buffer[start+1]));
            break;

        default:
            break;
    }

}
