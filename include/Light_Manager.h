#ifndef  LIGHT_MANAGER_H
#define  LIGHT_MANAGER_H

#include <avr/io.h>
#include <avr/cpufunc.h>

static const double     _PI= 3.1415926535897932384626433;
static const double _TWO_PI= 6.2831853071795864769252867;

typedef enum _Light_Parameter {
    PARAM_RED,
    PARAM_GREEN,
    PARAM_BLUE,
    PARAM_HUE,
    PARAM_SATURATION,
    PARAM_BRIGHTNESS,
    PARAM_PERIOD,
    PARAM_REPEAT,
    PARAM_PHASEOFFSET,
    PARAM_ENUM_COUNT
} LightParameter;

typedef enum _Light_Pattern {
    PATTERN_OFF, 
    PATTERN_SINE, 
    PATTERN_SOLID,
    PATTERN_SIREN,
    PATTERN_STROBE,
    PATTERN_FADEIN, 
    PATTERN_FADEOUT,
    PATTERN_COLORCYCLE,
    PATTERN_PARAMUPDATE, 
    PATTERN_ENUM_COUNT
} LightManagerPattern;

typedef struct _Light_Manager {

    uint8_t deviceId;

    // command management
    char isCommandFresh;

    // timing management
    uint16_t systemPhase;
    int16_t devicePhaseError;
    int16_t devicePhaseCorrection;
    int skipNextTick;
    int isDevicePhaseCorrectionUpdated;

    // lighting effects pattern management
    LightManagerPattern currPattern;
    uint32_t patternCounter;
    double patternSpeed;
    uint16_t patternPhase;
    uint8_t patternCyclesRemaining; 

    // led management
    uint8_t redRelativeIntensity;
    uint8_t blueRelativeIntensity;
    uint8_t greenRelativeIntensity;

    uint8_t output_target_r;
    uint8_t output_target_g;
    uint8_t output_target_b;
    volatile uint8_t* output_r;
    volatile uint8_t* output_g;
    volatile uint8_t* output_b;

    uint8_t hue;
    uint8_t saturation;
    uint8_t brightness;
    

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
void LightManager_setLEDChannels(void);
/* 
 * implement the light patterns
 */
void LightManager_patternSine(void);
void LightManager_patternSolid(void);
void LightManager_patternSiren(void);
void LightManager_patternStrobe(void);
void LightManager_patternOff(void);
void LightManager_patternFadeIn(void);
void LightManager_patternFadeOut(void);
void LightManager_patternColorCycle(void);
double LightManager_phaseAdjustedCarrierArgument(void);

void LightManager_setDeviceId(int8_t);
char LightManager_getDeviceIdMask(void);

/*
 * Command parsing
 */
void LightManager_setCommandUpdated(void);
void LightManager_parseCommand(char*, int);
void LightManager_processParameterUpdate(LightParameter, int, char*);
uint16_t LightManager_charToInt(char, char);
#endif
