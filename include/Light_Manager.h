#ifndef  LIGHT_MANAGER_H
#define  LIGHT_MANAGER_H

#include <avr/io.h>
#include <avr/cpufunc.h>

/*
 * light manager state
 */
struct _Light_Manager {
    char currPattern;
    volatile uint8_t* output_r;
    volatile uint8_t* output_g;
    volatile uint8_t* output_b;
    int16_t patternCounter;
    int16_t patternSpeed;
    int16_t patternPhase;
};
typedef struct _Light_Manager LightManager;

// the manager singleton
extern LightManager _manager_instance;

/*
 * setup lighting manager
 * params are a manager and channel output registers
 */
void LightManager_init(volatile uint8_t *, volatile uint8_t *, volatile uint8_t *);

/* 
 * mark time in light manager
 */
void LightManager_tick(void);

/* 
 * implement the currently selected pattern
 */
void LightManager_setPattern(char);

uint8_t LightPattern_calculateBreathe(void);

#endif
