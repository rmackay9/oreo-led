/*
 * Light_Manager.c
 *
 */

#include <avr/io.h>
#include <avr/cpufunc.h>
#include "Light_Manager.h"
#include "math.h"

const short int LightParameterSize[PARAM_ENUM_COUNT] = {
    1, // Colors RGB
    1,
    1,
    1, // Colors HSB
    1,
    1,
    2, // Period
    1, // Repeat
    2  // Phase Offset
};

LightManager _manager_instance;

/*
 * setup lighting manager
 * params are RGB channel output registers
 */
void LightManager_init(volatile uint8_t* output_r, volatile uint8_t* output_g, volatile uint8_t* output_b) {

    // init all instance members
    _manager_instance.skipNextTick                          = 0;
    _manager_instance.isDevicePhaseCorrectionUpdated        = 1;
    _manager_instance.isCommandFresh                        = 0;
    _manager_instance.systemPhase                           = 0;
    _manager_instance.devicePhaseError                      = 0;
    _manager_instance.devicePhaseCorrection                 = 0;

    // set output channel addresses
    _manager_instance.output_r = output_r;
    _manager_instance.output_g = output_g;
    _manager_instance.output_b = output_b;

    // initialize output channels to WHITE
    *(_manager_instance.output_r) = 0; 
    *(_manager_instance.output_g) = 0; 
    *(_manager_instance.output_b) = 10; 

    _manager_instance.redRelativeIntensity      = 30;
    _manager_instance.greenRelativeIntensity    = 230;
    _manager_instance.blueRelativeIntensity     = 80;

    _manager_instance.patternCounter    = 0;
    _manager_instance.patternSpeed      = 1;
    _manager_instance.patternPhase      = 0;

    // init light pattern
    LightManager_setPattern(PATTERN_OFF);

}

/* 
 * set the current pattern
 */
void LightManager_setPattern(LightManagerPattern pattern) {



    // set current pattern
    _manager_instance.currPattern = pattern;

}

/* 
 * set the counter
 */
void LightManager_setCounter(int16_t count) {

    // set counter
    _manager_instance.patternCounter = count;

}

/* 
 * set the phase
 */
void LightManager_setPhase(int16_t phase) {

    // set phase
    _manager_instance.patternPhase = phase;

}

/* 
 * set the speed
 */
void LightManager_setSpeed(double speed) {

    // set speed
    _manager_instance.patternSpeed = speed;

}

void LightManager_setDeviceId(int8_t id) {

    // set counter
    _manager_instance.deviceId = id;

}

char LightManager_getDeviceIdMask() {

    if (_manager_instance.deviceId)
        return (0x00 | (0x01 << (_manager_instance.deviceId - 1)));
    else 
        return 0x00;

}

/*
 * Command Parsing
 *
 */
void LightManager_setCommandUpdated() {

    _manager_instance.isCommandFresh = 1;

}

void LightManager_parseCommand(char* twiCommandBuffer, int size) {

    // if command is new, re-parse
    // ensure valid length buffer
    // ensure pointer is valid
    if (twiCommandBuffer && 
        size > 0 &&
        _manager_instance.isCommandFresh) {

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
    _manager_instance.isCommandFresh = 0;

}

void LightManager_processParameterUpdate(LightParameter param, int start, char* buffer) {

    // validate arguments
    if (!buffer) return;

    switch(param) {

        case PARAM_RED: 
            _manager_instance.redRelativeIntensity = buffer[start];
            break;

        case PARAM_GREEN: 
            _manager_instance.greenRelativeIntensity = buffer[start];
            break;

        case PARAM_BLUE: 
            _manager_instance.blueRelativeIntensity = buffer[start];
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
            _manager_instance.patternCyclesRemaining = buffer[start];
            break;

        case PARAM_PHASEOFFSET: 
            LightManager_setPhase(LightManager_charToInt(buffer[start], buffer[start+1]));
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
    if (_manager_instance.skipNextTick > 0) { 
        _manager_instance.skipNextTick--;
        return;
    }

    // increment lighting pattern effect clock
    if (_manager_instance.patternCounter < PATTERN_COUNT_TOP)
        _manager_instance.patternCounter += PATTERN_COUNT_INCREMENT;
    else 
        _manager_instance.patternCounter = PATTERN_COUNT_BOTTOM;

}

void LightManager_tickSkip() {
    _manager_instance.skipNextTick++;

}

void LightManager_recordPhaseError() {

    _manager_instance.systemPhase = _manager_instance.patternCounter;

}

void LightManager_setPhaseCorrectionRefresh() {
    // recompute phase correction as soon as possible
    _manager_instance.isDevicePhaseCorrectionUpdated = 0;
}

// calculate correction for phase error
// limit execution to once per clock tick
void LightManager_calcPhaseCorrection() {

    // phase correction already updated in this cycle
    if (_manager_instance.isDevicePhaseCorrectionUpdated) return;

    // calculate phase error if a phase signal received
    if (_manager_instance.systemPhase != 0) {

        // device is behind phase
        if (_manager_instance.systemPhase >= PATTERN_COUNT_TOP/2) {
            _manager_instance.devicePhaseError = (_manager_instance.systemPhase - PATTERN_COUNT_TOP) / PATTERN_COUNT_INCREMENT;

        // device is ahead of phase
        } else {
            _manager_instance.devicePhaseError = _manager_instance.systemPhase / PATTERN_COUNT_INCREMENT;
        }

        // do not calculate phaseError again until another phase signal received
        _manager_instance.systemPhase = 0;

    }

    // only apply correction if magnitude is greater than threshold
    if (fabs(_manager_instance.devicePhaseError) >= PHASE_CORRECTION_THRESHOLD) { 

        // if phase error negative, add an extra clock tick
        // if positive, remove a clock tick
        if (_manager_instance.devicePhaseError < 0) {
            LightManager_tick();
            _manager_instance.devicePhaseError++;
        } else {
            LightManager_tickSkip();
            _manager_instance.devicePhaseError--;
        }        
        
    }

    // phase correction has been updated
    _manager_instance.isDevicePhaseCorrectionUpdated = 1;

}

/*
 * Light Patterns
 *
 */
void LightManager_calc() { 

    // update light intensity target values
    // which the LEDs will be commanded to meet
    switch(_manager_instance.currPattern) {

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

    // update physical output channels per
    // the calculated intensity target values
    LightManager_setLEDChannels();

}

void LightManager_patternOff(void) {

    _manager_instance.output_target_r = 0; 
    _manager_instance.output_target_g = 0; 
    _manager_instance.output_target_b = 10; 

}

void LightManager_patternSolid(void) {
    
    // update LED intensity
    _manager_instance.output_target_r = _manager_instance.redRelativeIntensity; 
    _manager_instance.output_target_g = _manager_instance.greenRelativeIntensity; 
    _manager_instance.output_target_b = _manager_instance.blueRelativeIntensity; 

}

void LightManager_patternSine(void) {

    // calculate the carrier signal 
    double patternCarrier = sin(LightManager_phaseAdjustedCarrierArgument());

    // update LED intensities
    _manager_instance.output_target_r = (_manager_instance.redRelativeIntensity + 
        (double)(_manager_instance.redRelativeIntensity * 0.3 * patternCarrier)); 

    _manager_instance.output_target_g = (_manager_instance.greenRelativeIntensity + 
        (double)(_manager_instance.greenRelativeIntensity * 0.3 * patternCarrier)); 

    _manager_instance.output_target_b = (_manager_instance.blueRelativeIntensity + 
        (double)(_manager_instance.blueRelativeIntensity * 0.3 * patternCarrier)); 

}

double LightManager_phaseAdjustedCarrierArgument() {

    // calculate theta, in radians, from the current timer
    double theta_rad = fmod(((double)_manager_instance.patternCounter/PATTERN_COUNT_TOP) * _manager_instance.patternSpeed * _TWO_PI, _TWO_PI);

    // calculate the carrier signal 
    double argument = theta_rad + _manager_instance.deviceId * (double)_manager_instance.patternPhase/180.0 * _PI;

    return argument;

}

void LightManager_patternStrobe(void) {

    // calculate the carrier signal 
    double patternCarrier = (sin(LightManager_phaseAdjustedCarrierArgument()) > 0) ? 1 : 0;

    // update LED intensity
    _manager_instance.output_target_r = (uint8_t)(10 + (30 * patternCarrier)); 
    _manager_instance.output_target_g = (uint8_t)(60 + (180 * patternCarrier)); 
    _manager_instance.output_target_b = (uint8_t)(30 + (90 * patternCarrier)); 

}

void LightManager_patternSiren(void) {

    // calculate the carrier signal 
    double patternCarrier = 0.8 + 0.3 * sin(tan(LightManager_phaseAdjustedCarrierArgument())*0.75);

    // update LED intensity
    _manager_instance.output_target_r = (uint8_t)(10 + (double)(30 * patternCarrier)); 
    _manager_instance.output_target_g = (uint8_t)(60 + (double)(180 * patternCarrier)); 
    _manager_instance.output_target_b = (uint8_t)(30 + (double)(90 * patternCarrier)); 

}

void LightManager_patternFadeIn(void) {

    // calculate the carrier signal 
    double patternCarrier = sin(LightManager_phaseAdjustedCarrierArgument()/4);

    // completes a cycle at zero crossing

    // update LED intensity
    _manager_instance.output_target_r = (uint8_t)(0 + (240 * patternCarrier)); 
    _manager_instance.output_target_g = (uint8_t)(0 + (240 * patternCarrier)); 
    _manager_instance.output_target_b = (uint8_t)(0 + (240 * patternCarrier)); 

}

void LightManager_patternFadeOut(void) {

}

void LightManager_patternColorCycle(void) {

}

void LightManager_setLEDChannels(void) {

    if (_manager_instance.output_target_r > 240) *(_manager_instance.output_r) = 240;
    else *(_manager_instance.output_r) = _manager_instance.output_target_r;

    if (_manager_instance.output_target_g > 240) *(_manager_instance.output_g) = 240;
    else *(_manager_instance.output_g) = _manager_instance.output_target_g;

    if (_manager_instance.output_target_b > 240) *(_manager_instance.output_b) = 240;
    else *(_manager_instance.output_b) = _manager_instance.output_target_b;

    if (_manager_instance.output_target_b < 15) *(_manager_instance.output_b) = 15;
    else *(_manager_instance.output_b) = _manager_instance.output_target_b;

}

