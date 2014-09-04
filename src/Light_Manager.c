/*
 * Light_Manager.c
 *
 */

#include <avr/io.h>
#include <avr/cpufunc.h>
#include "Light_Manager.h"

/*
 * setup lighting manager
 * params are a manager and two channel output registers
 */
void LightManager_init(uint16_t * output_a, uint16_t * output_b) {

    // set output channel addresses
    _manager_instance.output_a = output_a;
    _manager_instance.output_b = output_b;

    // initialize output channels
    *(m.output_a) = 0xF0;
    *(m.output_b) = 0xF0;

}

/* 
 * mark time in light manager
 */
void LightManager_tick() {
    _manager_instance.counter++;
}

/* 
 * implement the currently selected pattern
 */
void LightManager_setPattern(char pattern) {
    _manager_instance.currPattern = pattern;

    *(m.output_a) = 0xF0;
    *(m.output_b) = 0xF0;

}

