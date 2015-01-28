/**********************************************************************

  twi_manager.c - implementation, see header for description


  Authors: 
    Nate Fisher

  Created: 
    Wed Oct 1, 2014

**********************************************************************/

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/cpufunc.h>

#include "twi_manager.h"

void TWI_init(uint8_t deviceId) {

    // calculate slave address
    // 8-bit address is 0xD0, 0xD2, 
    //   0xD4, 0xD6, 7-bit is 0x68 ~ 0x6B
    char TWI_SLAVE_ADDRESS = (0xD0 + (deviceId << 1));

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

    // general call detected
    if (TWI_GENCALL_RCVD) {

        // execute callback when general call received
        if (generalCallCB) generalCallCB();

    // record the end of a transmission if 
    //   stop bit received
    //   TODO handle condition when stopped bit missed
    } else if (TWI_STOP_RCVD) {

        // execute callback when data received
        if (dataReceivedCB) dataReceivedCB();
        
    // every message with begin here
    // reset pointer
    } else if (TWI_SLAW_RCVD) {

        TWI_Ptr = 0;
        TWI_isBufferAvailable = 1;

    // if this unit was addressed and we're receiving
    //   data, continue capturing into buffer
    } else if (TWI_SLAW_DATA_RCVD) {

        // record received data 
        // until buffer is full
        if (TWI_Ptr == TWI_MAX_BUFFER_SIZE) 
            TWI_isBufferAvailable = 0;

        if (TWI_isBufferAvailable)
            TWI_Buffer[TWI_Ptr++] = TWDR;

    }

    // always release clock line
    TWCR |= TWCR_TWINT;

}