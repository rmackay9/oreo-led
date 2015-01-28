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

uint8_t NODE_getId() {

    SPCR    = 0x00; // disable SPI
    PCICR   = 0x00; // disable all pin interrupts
    
    // set PD6/PD7 as inputs (0 == input | 1 == output)
    DDRD = 0b00111111; 

    // turn off pullup resistor
    PORTD = 0x00;

    // capture unit position 
    uint8_t position = (PIND & 0b11000000) >> 6;

    return position;

}

#endif
