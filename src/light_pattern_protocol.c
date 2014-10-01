/**********************************************************************

  light_pattern_protocol.c - 

  Authors: 
    Nate Fisher

  Created at: 
    Wed Oct 1, 2014

  <License> 
  <Copyright>

**********************************************************************/

#include "light_pattern_protocol.h"

void LPP_setCommandRefreshed(void);
void LPP_setRedPatternGen(&pgRed);
void LPP_setGreenPatternGen(&pgGreen);
void LPP_setBluePatternGen(&pgBlue);

// parse commands per interface contract
//  and update pattern generators accordingly
void LPP_processBuffer(TWI_getBuffer(), TWI_getBufferSize());
        
typedef enum _Light_Protocol_Parameter {
    PARAM_RED,
    PARAM_GREEN,
    PARAM_BLUE,
    PARAM_HUE,
    PARAM_SATURATION,
    PARAM_BRIGHTNESS,
    PARAM_PERIOD,
    PARAM_REPEAT,
    PARAM_PHASEOFFSET,
    PARAM_BC_RED,
    PARAM_BC_GREEN,
    PARAM_BC_BLUE,
    PARAM_AC_RED,
    PARAM_AC_GREEN,
    PARAM_AC_BLUE,
    PARAM_ENUM_COUNT
} LightProtocolParameter;

const short int LightParameterSize[PARAM_ENUM_COUNT] = {
    1,  // Colors RGB
    1,
    1,
    1,  // Colors HSB
    1,
    1,
    2,  // Period
    1,  // Repeat
    2,  // Phase Offset
    1,  // Bias coefficients
    1,
    1,  
    1,  // Amp coefficients
    1,
    1
};

void LPP_parseCommand(char* twiCommandBuffer, int size) {

    // if command is new, re-parse
    // ensure valid length buffer
    // ensure pointer is valid
    if (twiCommandBuffer && 
        size > 0 &&
        _self.isCommandFresh) {

        // set pattern if command is not a param-only command
        if (twiCommandBuffer[0] != PATTERN_PARAMUPDATE)
            LPP_setPattern( twiCommandBuffer[0] );

        // cycle through remaining params
        // beginning with first param (following pattern byte)
        int buffer_pointer = 1;
        while (buffer_pointer < size) {

            // digest parameters serially
            LightParameter currParam;

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
            LPP_processParameterUpdate(currParam, buffer_pointer+1, twiCommandBuffer);

            // advance pointer
            buffer_pointer += paramSize + 1;

        }


    }

    // signal command has been parsed
    _self.isCommandFresh = 0;

}

void LPP_processParameterUpdate(LightParameter param, int start, char* buffer) {

    // validate arguments
    if (!buffer) return;

    switch(param) {

        case PARAM_RED: 
            _self.redRelativeIntensity = buffer[start];
            break;

        case PARAM_GREEN: 
            _self.greenRelativeIntensity = buffer[start];
            break;

        case PARAM_BLUE: 
            _self.blueRelativeIntensity = buffer[start];
            break;

        case PARAM_HUE: 
            break;
        case PARAM_SATURATION: 
            break;
        case PARAM_BRIGHTNESS: 
            break;

        case PARAM_PERIOD: 
            LPP_setSpeed(4000.0 / LPP_charToInt(buffer[start], buffer[start+1])); 
            break;

        case PARAM_REPEAT: 
            _self.patternCyclesRemaining = buffer[start];
            break;

        case PARAM_PHASEOFFSET: 
            LPP_setPhase(LPP_charToInt(buffer[start], buffer[start+1]));
            break;

        case PARAM_BC_RED:
            _self.redBC = buffer[start]/100.0;
            break;
        case PARAM_BC_GREEN:
            _self.greenBC = buffer[start]/100.0;
            break;
        case PARAM_BC_BLUE:
            _self.blueBC = buffer[start]/100.0;
            break;
        case PARAM_AC_RED:
            _self.redAC = buffer[start]/100.0;
            break;
        case PARAM_AC_GREEN:
            _self.greenAC = buffer[start]/100.0;
            break;
        case PARAM_AC_BLUE:
            _self.blueAC = buffer[start]/100.0;
            break;

        default:
            break;
    }

}

void LPP_setCounter(int16_t count) {

    // set counter
    _self.patternCounter = count;

}

void LPP_setPhase(int16_t phase) {

    // set phase
    _self.patternPhase = phase;

}

void LPP_setSpeed(double speed) {

    // set speed
    _self.patternSpeed = speed;

}

void LPP_setCommandUpdated() {

    _self.isCommandFresh = 1;

}

void LPP_setPattern(LightManagerPattern pattern) {

    // set pattern cycle count to one, for first
    // cycle of single cycle patterns
    if (_self.currPattern != pattern)
        _self.patternCyclesRemaining = 1;

    // set current pattern
    _self.currPattern = pattern;

}
