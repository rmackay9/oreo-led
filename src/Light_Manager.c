/*
 * Light_Manager.c
 *
 */

#include <avr/io.h>
#include <avr/cpufunc.h>
#include "Light_Manager.h"
#include "math.h"

LightManager _manager_instance;

/*
 * setup lighting manager
 * params are RGB channel output registers
 */
void LightManager_init(volatile uint8_t* output_r, volatile uint8_t* output_g, volatile uint8_t* output_b) {

    // set output channel addresses
    _manager_instance.output_r = output_r;
    _manager_instance.output_g = output_g;
    _manager_instance.output_b = output_b;

    // initialize output channels
    *(_manager_instance.output_r) = 30;
    *(_manager_instance.output_g) = 230;
    *(_manager_instance.output_b) = 80;

}

/* 
 * set the current pattern
 */
void LightManager_setPattern(char pattern) {

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
void LightManager_setSpeed(int16_t speed) {

    // set speed
    _manager_instance.patternSpeed = speed;

}

/* 
 * updatelight effects animation
 */
void LightManager_tick() {

    _manager_instance.patternCounter += _manager_instance.patternSpeed;

    LightManager_setSpeed(250);
    uint8_t patternCarrier = 120 + 120 * sin(((double)_manager_instance.patternCounter/0xFFFF) * 2*M_PI);

    // update LED intensity
    *(_manager_instance.output_r) = 0; //(uint8_t)(30 + (double)(5 * patternCarrier)); 
    *(_manager_instance.output_g) = 0; //(uint8_t)(150 + (double)(20 * patternCarrier)); 
    *(_manager_instance.output_b) = 0; 

}


/*
 * Light_Pattern 
 *
 */

/*
uint8_t LightPattern_calculateRotatingBreath(DeviceState device) {

    // pattern speed
    LightManager_setSpeed(250);

    // pattern device phase angles
    LightPhaseArray patternPhases = {0, 90, 180, 270};

    // set the phase according to this device's installed position
    LightManager_setPhase(patternPhases[device.installedPosition]);

    float t = (float)_manager_instance.counter/0xFFFF;
    float p = patternPhases[device.installedPosition]/360

    uint8_t output = 100 + 50 * sin((p + t) * 2*M_PI);

    return output;

}

uint8_t LightPattern_calculateStrobe(DeviceState device) {

    // pattern speed
    LightManager_setSpeed(250);

    // pattern device phases
    LightPhaseArray patternPhases = {0, 0, 0, 0};

    // set the phase according to this device's installed position
    LightManager_setPhase(patternPhases[device.installedPosition]);


    uint8_t output = 100 + 50 * fabs(sin(((float)_manager_instance.counter/0xFFFF) * 2*M_PI));

    return output;

}

uint8_t LightPattern_calculateBreathe(void) {

    // pattern speed
    LightManager_setSpeed(0x0100);

    // pattern device phases
    //LightPhaseArray patternPhases = {0, 0, 0, 0};

    // set the phase according to this device's installed position
    //LightManager_setPhase(patternPhases[device.installedPosition]);


    uint8_t output = 50.0 * sin(((float)_manager_instance.patternCounter/0xFFFF) * 2*M_PI);

    return output;

}

uint8_t LightPattern_calculateAlternatingStrobe(DeviceState device) {

    // pattern speed
    LightManager_setSpeed(250);

    // pattern device phases
    LightPhaseArray patternPhases = {0, 0, 180, 180};

    // set the phase according to this device's installed position
    LightManager_setPhase(patternPhases[device.installedPosition]);


    uint8_t output = 100 + 50 * abs(sin(((float)_manager_instance.counter/0xFFFF) * 2*M_PI));

    return output;

}
*/

