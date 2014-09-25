#ifndef  LIGHT_MANAGER_H
#define  LIGHT_MANAGER_H

#include <avr/io.h>
#include <avr/cpufunc.h>

typedef enum _Light_Pattern {
    PATTERN_NONE, 
    PATTERN_SINE, 
    PATTERN_SOLID,
    PATTERN_SIREN,
    PATTERN_STROBE,
    PATTERN_FADEIN, 
    PATTERN_FADEOUT
} LightManagerPattern;

typedef struct _Light_Manager {

    // command management
    char isCommandFresh;

    // timing management
    uint16_t systemPhase;
    int16_t devicePhaseError;
    int16_t devicePhaseCorrection;
    int skipNextTick;
    int isDevicePhaseCorrectionUpdated;

    // lighting effects management
    LightManagerPattern currPattern;
    uint16_t patternCounter;
    int16_t patternSpeed;
    uint16_t patternPhase;
    volatile uint8_t* output_r;
    volatile uint8_t* output_g;
    volatile uint8_t* output_b;

} LightManager;

// creates a period of exactly 4s with 
// clock divider = 8, timer divider = 8 and timer TOP = 0xFF
#define PATTERN_COUNT_BOTTOM        0
#define PATTERN_COUNT_TOP           62500
#define PATTERN_COUNT_INCREMENT     32
#define PHASE_CORRECTION_THRESHOLD  2

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
void LightManager_tickSkip(void);
void LightManager_recordPhaseError(void);
void LightManager_calcPhaseCorrection(void);
void LightManager_setPhaseCorrectionRefresh(void);

/* 
 * implement the currently selected pattern
 */
void LightManager_setPattern(LightManagerPattern);

/* 
 * calculate LED intensities per selected
 * pattern parameters
 */
void LightManager_calc(void);

/* 
 * implement the light patterns
 */
void LightManager_patternSine(void);
void LightManager_patternSolid(void);
void LightManager_patternSiren(void);
void LightManager_patternStrobe(void);
void LightManager_patternOff(void);
void LightManager_patternFadeIn(void);

/*
 * Command parsing
 */
void LightManager_setCommandUpdated(void);
void LightManager_parseCommand(char*);

#endif
