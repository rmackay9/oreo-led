/**********************************************************************

  node_manager.h - derive a unit identification based on installed
    configuration. Also calculate the network communications address
    based on the ident.


  Authors: 
    Nate Fisher

  Created: 
    Wed Oct 1, 2014

**********************************************************************/

#ifndef  NODE_MANAGER_H
#define  NODE_MANAGER_H

// id of first node considered in 'front' of
// aircraft - used to determine lighting color orientation
#define _NODE_STATION_FRONT 2

// store node station ID once derived; Before determined
// by hardware pins, the ID is conisdered uninitialized
#define _NODE_UNINITIALIZED_STATION 255
static uint8_t _NODE_station = _NODE_UNINITIALIZED_STATION;

// set node ID
// For SOLO, the ID scheme is zero-indexed, beginning
// with left-rear node, inreasing counter-clockwise
static void NODE_init() {

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

}

// return node station ID
static uint8_t NODE_getId() {
    NODE_init();
    return _NODE_station;

}

#endif
