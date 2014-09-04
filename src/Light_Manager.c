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
 * params are a manager and two channel output registers
 */
void LightManager_init(volatile uint16_t * output_a, volatile uint16_t * output_b) {

    // set output channel addresses
    _manager_instance.output_a = output_a;
    _manager_instance.output_b = output_b;

    // initialize output channels
    *(_manager_instance.output_a) = 0x00;
    *(_manager_instance.output_b) = 0x00;

}

/* 
 * increment timer for light effects animation
 */
void LightManager_tick() {

    _manager_instance.counter += _manager_instance.patternSpeed;

}

/* 
 * implement the currently selected pattern
 */
void LightManager_setPattern(char pattern) {

    // set current pattern
    _manager_instance.currPattern = pattern;

    // "breathing" pattern
    _manager_instance.patternSpeed = 250;
    uint8_t output = 100 + 50 * sin(((float)_manager_instance.counter/0xFFFF) * 2*M_PI);

    // update LED intensity
    *(_manager_instance.output_a) = output;
    *(_manager_instance.output_b) = output;

}
