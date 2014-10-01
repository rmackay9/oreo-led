/*
 * Light_Manager.c
 *
 */

#include <avr/io.h>
#include <avr/cpufunc.h>
#include "Light_Manager.h"
#include "math.h"

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

LightManager _self;

/*
 * setup lighting manager
 * params are RGB channel output registers
 */
void LightManager_init(volatile uint8_t* output_r, volatile uint8_t* output_g, volatile uint8_t* output_b) {

    // init all instance members
    _self.skipNextTick                          = 0;
    _self.isDevicePhaseCorrectionUpdated        = 1;
    _self.isCommandFresh                        = 0;
    _self.systemPhase                           = 0;
    _self.devicePhaseError                      = 0;
    _self.devicePhaseCorrection                 = 0;

    // set output channel addresses
    _self.output_r = output_r;
    _self.output_g = output_g;
    _self.output_b = output_b;

    // initialize output channels to WHITE
    *(_self.output_r) = 0; 
    *(_self.output_g) = 0; 
    *(_self.output_b) = 10; 

    _self.redRelativeIntensity      = 30;
    _self.greenRelativeIntensity    = 230;
    _self.blueRelativeIntensity     = 80;

    _self.patternCounter    = 0;
    _self.patternSpeed      = 1;
    _self.patternPhase      = 0;

    // init light pattern
    LightManager_setPattern(PATTERN_OFF);

}

/* 
 * set the current pattern
 */
void LightManager_setPattern(LightManagerPattern pattern) {

    // set pattern cycle count to one, for first
    // cycle of single cycle patterns
    if (_self.currPattern != pattern)
        _self.patternCyclesRemaining = 1;

    // set current pattern
    _self.currPattern = pattern;

}

/* 
 * set the counter
 */
void LightManager_setCounter(int16_t count) {

    // set counter
    _self.patternCounter = count;

}

/* 
 * set the phase
 */
void LightManager_setPhase(int16_t phase) {

    // set phase
    _self.patternPhase = phase;

}

/* 
 * set the speed
 */
void LightManager_setSpeed(double speed) {

    // set speed
    _self.patternSpeed = speed;

}

void LightManager_setDeviceId(int8_t id) {

    // set counter
    _self.deviceId = id;

}

char LightManager_getDeviceIdMask() {

    if (_self.deviceId)
        return (0x00 | (0x01 << (_self.deviceId - 1)));
    else 
        return 0x00;

}

/*
 * Command Parsing
 *
 */
void LightManager_setCommandUpdated() {

    _self.isCommandFresh = 1;

}

void LightManager_parseCommand(char* twiCommandBuffer, int size) {

    // if command is new, re-parse
    // ensure valid length buffer
    // ensure pointer is valid
    if (twiCommandBuffer && 
        size > 0 &&
        _self.isCommandFresh) {

        // set pattern if command is not a param-only command
        if (twiCommandBuffer[0] != PATTERN_PARAMUPDATE)
            LightManager_setPattern( twiCommandBuffer[0] );

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
            LightManager_processParameterUpdate(currParam, buffer_pointer+1, twiCommandBuffer);

            // advance pointer
            buffer_pointer += paramSize + 1;

        }


    }

    // signal command has been parsed
    _self.isCommandFresh = 0;

}

void LightManager_processParameterUpdate(LightParameter param, int start, char* buffer) {

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
            LightManager_setSpeed(4000.0 / LightManager_charToInt(buffer[start], buffer[start+1])); 
            break;

        case PARAM_REPEAT: 
            _self.patternCyclesRemaining = buffer[start];
            break;

        case PARAM_PHASEOFFSET: 
            LightManager_setPhase(LightManager_charToInt(buffer[start], buffer[start+1]));
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

uint16_t LightManager_charToInt(char msb, char lsb) {
    return ( ( (0x00FF & (uint16_t)msb) << 8) | (0x00FF & (uint16_t)lsb) );
}

/*
 * Timing Management
 *
 */

/* 
 * update light effects time counter
 */
void LightManager_tick() {

    // adjust clock for phase error
    if (_self.skipNextTick > 0) { 
        _self.skipNextTick--;
        return;
    }

    // increment lighting pattern effect clock
    if (_self.patternCounter < PATTERN_COUNT_TOP)
        _self.patternCounter += PATTERN_COUNT_INCREMENT;
    else 
        _self.patternCounter = PATTERN_COUNT_BOTTOM;

}

void LightManager_tickSkip() {

    _self.skipNextTick++;

}

void LightManager_recordPhaseError() {

    _self.systemPhase = _self.patternCounter;

}

void LightManager_setPhaseCorrectionRefresh() {

    // recompute phase correction as soon as possible
    _self.isDevicePhaseCorrectionUpdated = 0;
}

// calculate correction for phase error
// limit execution to once per clock tick
void LightManager_calcPhaseCorrection() {

    // phase correction already updated in this cycle
    if (_self.isDevicePhaseCorrectionUpdated) return;

    // calculate phase error if a phase signal received
    if (_self.systemPhase != 0) {

        // device is behind phase
        if (_self.systemPhase >= PATTERN_COUNT_TOP/2) {
            _self.devicePhaseError = (_self.systemPhase - PATTERN_COUNT_TOP) / PATTERN_COUNT_INCREMENT;

        // device is ahead of phase
        } else {
            _self.devicePhaseError = _self.systemPhase / PATTERN_COUNT_INCREMENT;
        }

        // do not calculate phaseError again until another phase signal received
        _self.systemPhase = 0;

    }

    // only apply correction if magnitude is greater than threshold
    if (fabs(_self.devicePhaseError) >= PHASE_CORRECTION_THRESHOLD) { 

        // if phase error negative, add an extra clock tick
        // if positive, remove a clock tick
        if (_self.devicePhaseError < 0) {
            LightManager_tick();
            _self.devicePhaseError++;
        } else {
            LightManager_tickSkip();
            _self.devicePhaseError--;
        }        
        
    }

    // phase correction has been updated
    _self.isDevicePhaseCorrectionUpdated = 1;

}

/*
 * Light Patterns
 *
 */
void LightManager_calc() { 

    // update light intensity target values
    // which the LEDs will be commanded to meet
    switch(_self.currPattern) {

        case PATTERN_SINE: 
            LightManager_patternSine(); 
            break;
        case PATTERN_STROBE: 
            LightManager_patternStrobe(); 
            break;
        case PATTERN_SIREN: 
            LightManager_patternSiren(); 
            break;
        case PATTERN_SOLID: 
            LightManager_patternSolid(); 
            break;
        case PATTERN_FADEOUT: 
            LightManager_patternFadeOut(); 
            break;
        case PATTERN_FADEIN: 
            LightManager_patternFadeIn(); 
            break;
        case PATTERN_COLORCYCLE: 
            LightManager_patternColorCycle(); 
            break;
        case PATTERN_OFF:
        default: 
            LightManager_patternOff();

    }

    // calculate carrier pattern argument
    LightManager_calcCarrierArgument();

    // update physical output channels per
    // the calculated intensity target values
    LightManager_setLEDChannels();

}

void LightManager_calcCarrierArgument() {

    // calculate theta, in radians, from the current timer
    double theta_rad = ((double)_self.patternCounter/PATTERN_COUNT_TOP) * _self.patternSpeed * _TWO_PI;

    // calculate the phase-adjusted theta
    double argument = fmod(theta_rad + (double)_self.patternPhase/180.0 * _PI, _TWO_PI);

    // set zero crossing flag
     _self.isPatternZeroCrossing = (_self.patternTheta > argument) ? 1 : 0;

    // set pattern theta
    _self.patternTheta = argument;

}

void LightManager_patternOff(void) {

    _self.output_target_r = 0; 
    _self.output_target_g = 0; 
    _self.output_target_b = 0; 

}

void LightManager_patternSolid(void) {
    
    // update LED intensity
    _self.output_target_r = _self.redRelativeIntensity; 
    _self.output_target_g = _self.greenRelativeIntensity; 
    _self.output_target_b = _self.blueRelativeIntensity; 

}

void LightManager_patternStrobe(void) {

    // calculate the carrier signal 
    double patternCarrier = (sin(_self.patternTheta) > 0) ? 1 : 0;

    // update LED intensity
    _self.output_target_r = _self.redRelativeIntensity * patternCarrier; 
    _self.output_target_g = _self.greenRelativeIntensity * patternCarrier; 
    _self.output_target_b = _self.blueRelativeIntensity * patternCarrier; 

}

void LightManager_patternSine(void) {

    // calculate the carrier signal 
    double patternCarrier = sin(_self.patternTheta);

    // update LED intensities
    _self.output_target_r = (double)_self.redRelativeIntensity * _self.redBC; 
    _self.output_target_r += (double)_self.redRelativeIntensity * patternCarrier * _self.redAC;

    _self.output_target_g = (double)_self.redRelativeIntensity * _self.greenBC; 
    _self.output_target_g += (double)_self.redRelativeIntensity * patternCarrier * _self.greenAC;

    _self.output_target_b = (double)_self.redRelativeIntensity * _self.blueBC;
    _self.output_target_b += (double)_self.redRelativeIntensity * patternCarrier * _self.blueAC;

}

void LightManager_patternSiren(void) {

    // calculate the carrier signal 
    double patternCarrier = sin(tan(_self.patternTheta)*.5);

    // update LED intensity
    _self.output_target_r = (double)_self.redRelativeIntensity * _self.redBC; 
    _self.output_target_r += (double)_self.redRelativeIntensity * patternCarrier * _self.redAC;

    _self.output_target_g = (double)_self.redRelativeIntensity * _self.greenBC; 
    _self.output_target_g += (double)_self.redRelativeIntensity * patternCarrier * _self.greenAC;

    _self.output_target_b = (double)_self.redRelativeIntensity * _self.blueBC;
    _self.output_target_b += (double)_self.redRelativeIntensity * patternCarrier * _self.blueAC;

}

void LightManager_patternColorCycle(void) {

    // calculate the carrier signal 
    double patternCarrierRed    = sin(_self.patternTheta + _PI * 2/3);
    double patternCarrierGreen  = sin(_self.patternTheta);
    double patternCarrierBlue   = sin(_self.patternTheta + _PI * 4/3);

    // update LED intensity
    _self.output_target_r = (60.0 + (30.0 * patternCarrierRed)); 
    _self.output_target_g = (40.0 + (30.0 * patternCarrierGreen)); 
    _self.output_target_b = (40.0 + (10.0 * patternCarrierBlue)); 

}

void LightManager_patternFadeIn(void) {

    if (_self.patternCyclesRemaining >= 0) {

        // calculate the carrier signal 
        double patternCarrier = sin(_self.patternTheta/4);

        // start pattern with lights off until last pattern
        // cycle remaining
        if (_self.patternCyclesRemaining >= 1) {

            // turn lights off
            _self.output_target_r = 0; 
            _self.output_target_g = 0; 
            _self.output_target_b = 0; 
        
        } else {

            // completes a cycle at zero crossing
            if (!_self.isPatternZeroCrossing) {

                // update LED intensity
                _self.output_target_r = (uint8_t)(_self.redRelativeIntensity * patternCarrier); 
                _self.output_target_g = (uint8_t)(_self.greenRelativeIntensity * patternCarrier); 
                _self.output_target_b = (uint8_t)(_self.blueRelativeIntensity * patternCarrier); 

            }

        }

        // decrement the cycles remaining at each zero crossing
        if (_self.isPatternZeroCrossing) 
            _self.patternCyclesRemaining--;

    // finish pattern with LEDs on, full
    } else {

        // turn lights on, full
        _self.output_target_r = _self.redRelativeIntensity; 
        _self.output_target_g = _self.greenRelativeIntensity; 
        _self.output_target_b = _self.blueRelativeIntensity; 

    }

}

void LightManager_patternFadeOut(void) {

    if (_self.patternCyclesRemaining >= 0) {

        // calculate the carrier signal 
        double patternCarrier = cos(_self.patternTheta/4);

        // start pattern with lights on until last pattern
        // cycle remaining
        if (_self.patternCyclesRemaining >= 1) {

            // turn lights on, full
            _self.output_target_r = _self.redRelativeIntensity; 
            _self.output_target_g = _self.greenRelativeIntensity; 
            _self.output_target_b = _self.blueRelativeIntensity; 
        
        } else {

            // completes a cycle at zero crossing
            if (!_self.isPatternZeroCrossing) {

                // update LED intensity
                _self.output_target_r = (uint8_t)(_self.redRelativeIntensity * patternCarrier); 
                _self.output_target_g = (uint8_t)(_self.greenRelativeIntensity * patternCarrier); 
                _self.output_target_b = (uint8_t)(_self.blueRelativeIntensity * patternCarrier); 

            }

        }

        // decrement the cycles remaining at each zero crossing
        if (_self.isPatternZeroCrossing) 
            _self.patternCyclesRemaining--;

    // finish pattern with LEDs off
    } else {

        // turn lights off
        _self.output_target_r = 0; 
        _self.output_target_g = 0; 
        _self.output_target_b = 0; 

    }

}

void LightManager_setLEDChannels(void) {

    // rescale LED percentage values to 0->240
    int greenValue = (fmod(_self.output_target_g, 100.0)/100.0) * 240;
    int redValue = (fmod(_self.output_target_r, 100.0)/100.0) * 240;

    // set pins to input mode, if value is actually zero
    // TODO abstract physical pins from class function
    if (redValue == 0) DDRB &= 0b11111011; //PB2 reset to input
    else DDRB |= 0b00000100; //PB2 set to output
    if (greenValue == 0) DDRB &= 0b11111101; //PB1 reset to input
    else DDRB |= 0b00000010; //PB1 set to output

    // assign color values to PWM timers
    *(_self.output_r) = redValue;
    *(_self.output_g) = greenValue;
    *(_self.output_b) = (fmod(_self.output_target_b, 100.0)/100.0) * 226 + 14;

}

