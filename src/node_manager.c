/**********************************************************************

  node_manager.c - implementation, see header for description

  Authors: 
    Nate Fisher

  Created: 
    Thurday Feb 19, 2015

**********************************************************************/

#include "node_manager.h"
#include "pattern_generator.h"

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/cpufunc.h>
#include <util/delay.h>
#include <avr/eeprom.h>

void NODE_init() {

    // reset startup timeout seconds count
    NODE_startup_timeout_seconds = 0;

    // set node station to uninit value
    _NODE_station = _NODE_UNINITIALIZED_STATION;
}

// return node station ID
// For SOLO, the ID scheme is zero-indexed, beginning
// with left-rear node, inreasing counter-clockwise
uint8_t NODE_getId() {

    if (_NODE_station == _NODE_UNINITIALIZED_STATION) {

        SPCR    = 0x00; // disable SPI
        PCICR   = 0x00; // disable all pin interrupts
        
        // set PD6/PD7 as inputs (0 == input | 1 == output)
        DDRD = 0b00111111; 

        // turn off pullup resistor
        PORTD = 0x00;

        // capture unit station 
        _NODE_station = (PIND & 0b11000000) >> 6;

    }

    return _NODE_station;

}

void NODE_wdt_setOneSecInterruptMode() {

    // disable interrupts
    cli();

    // setup wdtcsr register for update of WDE bit
    MCUSR &= ~(1<<WDRF);
    WDTCSR = (1<<WDCE) | (1<<WDE);  

    // update WDE bit and timer for 1s, interrupt mode
    WDTCSR = (1<<WDIF) | (1<<WDIE) | (1<<WDCE) | (0<<WDE) | 
        (0<<WDP3) | ( 1<<WDP2) | (1<<WDP1) | (0<<WDP0);

    // enable interrupts
    sei();

}

void NODE_wdt_setHalfSecResetMode() {

    // disable interrupts
    cli();

    // setup wdtcsr register for update of WDE bit
    MCUSR &= ~(1<<WDRF);    
    WDTCSR |= (1<<WDCE);

    // update WDE bit and timer for 500ms, reset mode
    WDTCSR  = (1<<WDIF) | (1<<WDIE) | (1<<WDCE) | (1<<WDE) | 
        (0<<WDP3) | ( 1<<WDP2) | (0<<WDP1) | (1<<WDP0);

    // enable interrupts
    sei();
    
}

uint8_t NODE_isRestoreStateAvailable() {

    // disable interrupts
    cli();

    uint8_t value = eeprom_read_byte(RESTORE_POINT_AVAILABLE_ADDR);

    // enable interrupts
    sei();

    return value;

}

void NODE_setRestoreStateUnavailable() {

    // disable interrupts
    cli();

    eeprom_write_byte(RESTORE_POINT_AVAILABLE_ADDR, 0);

    // enable interrupts
    sei();

}

void NODE_saveRGBState(PatternGenerator* r, PatternGenerator* g, PatternGenerator* b) {

    // disable interrupts
    cli();

    // save rgb state values
    eeprom_write_byte(RESTORE_POINT_RED_VALUE, (char)r->value);
    eeprom_write_byte(RESTORE_POINT_GREEN_VALUE, (char)g->value);
    eeprom_write_byte(RESTORE_POINT_BLUE_VALUE, (char)b->value);

    // enable interrupts
    sei();

}

void NODE_restoreRGBState(PatternGenerator* r, PatternGenerator* g, PatternGenerator* b) {

    // disable interrupts
    cli();

    // restore values as a solid pattern
    r->bias = eeprom_read_byte(RESTORE_POINT_RED_VALUE);
    g->bias = eeprom_read_byte(RESTORE_POINT_GREEN_VALUE);
    b->bias = eeprom_read_byte(RESTORE_POINT_BLUE_VALUE);

    // set solid pattern
    r->pattern = PATTERN_SOLID;
    g->pattern = PATTERN_SOLID;
    b->pattern = PATTERN_SOLID;

    // enable interrupts
    sei();
    
}

