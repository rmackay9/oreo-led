/**********************************************************************

  twi_manager.c - implementation, see header for description

  Authors: 
    Nate Fisher

  Created at: 
    Wed Oct 1, 2014

  <License> 
  <Copyright>

**********************************************************************/

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/cpufunc.h>

#include "twi_manager.h"

void TWI_init(int deviceId) {

    // TWI Config
    TWAR = TWI_SLAVE_ADDRESS | TWAR_TWGCE;
    TWCR = ZERO | TWCR_TWEA | TWCR_TWEN | TWCR_TWIE;

}

// specify callback to be executed
//  when device receives a general call
void TWI_onGeneralCall(void (*cb)()) {
    generalCallCB = cb;

}

// specify callback to be executed
//  when device receives a completed 
//  data packet (at STOP signal)
void TWI_onDataReceived(void (*cb)()) {
    dataReceivedCB = cb;

}

// returns pointer to TWI data buffer
char* TWI_getBuffer(void) {
    return TWI_Buffer;

}

// returns buffer pointer
int TWI_getBufferSize(void) {
    return TWI_Ptr;

}

// TWI ISR
ISR(TWI_vect) {

    if (TWI_GENCALL_RCVD) {

        // execute callback when general call received
        generalCallCB();

    // record the end of a transmission if 
    //   stop bit received
    //   TODO handle condition when stopped bit missed
    } else if (TWI_STOP_RCVD) {

        // execute callback when data received
        dataReceivedCB();

        TWI_Ptr = 0;
        
    // every message with begin here
    // reset pointer
    } else if (TWI_SLAW_RCVD) {

        TWI_Ptr = 0;

    // if this unit was addressed and we're receiving
    //   data, continue capturing into buffer
    } else if (TWI_SLAW_DATA_RCVD) {

        // record received data 
        // until buffer is full
        if (TWI_Ptr < TWI_MAX_BUFFER_SIZE) {
            TWI_Buffer[TWI_Ptr++] = TWDR;
        } 

    }

    // always release clock line
    TWCR |= TWCR_TWINT;

}