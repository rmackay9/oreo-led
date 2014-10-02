/**********************************************************************

  twi_manager.c - 

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

void TWI_onGeneralCall(void (*cb)()) {
    generalCallCB = cb;
}

void TWI_onDataReceived(void (*cb)()) {
    dataReceivedCB = cb;
}

char* TWI_getBuffer(void) {
    return TWI_Buffer;
}

int TWI_getBufferSize(void) {
    return TWI_Ptr;
}

void TWI_init(int deviceId) {

    // TWI Config
    TWAR = TWI_SLAVE_ADDRESS | TWAR_TWGCE;
    TWCR = ZERO | TWCR_TWEA | TWCR_TWEN | TWCR_TWIE;

}

// TWI ISR
ISR(TWI_vect) {

    // ignore message if another light unit is being addressed
    if (TWI_SLAW_DATA_RCVD && 
        !TWI_isSubAddrByte && 
        !TWI_isSelected) {

        // release clock line 
        TWCR |= TWCR_TWINT;

    // if message is a time synch cue (general call)
    //  calculate current time offset and store it
    } else if (TWI_GENCALL_RCVD) {

        // execute callback when general call received
        generalCallCB();

    // record the end of a transmission if 
    //   stop bit received
    //   TODO handle condition when stopped bit missed
    } else if (TWI_STOP_RCVD && TWI_isSelected) {

        // if this is a repeated-start,
        // answer the next SLA+R
        if (!TWI_isCombinedFormat) {
            
            // execute callback when data received
            dataReceivedCB();
        } 

        // mark end of transmission
        TWI_isSelected = 0;

    // every message with begin here
    // reset all flags
    } else if (TWI_SLAW_RCVD) {

        TWI_isCombinedFormat    = 0;
        TWI_isSelected          = 0;
        TWI_isSubAddrByte       = 1;

    // if this unit is being addressed
    //  start capturing pattern and parameters
    } else if (TWI_SLAW_DATA_RCVD && TWI_isSubAddrByte) {

        // always unflag, indicating remaining bytes
        // are not subaddr bytes
        TWI_isSubAddrByte = 0;

        // determine if this message is for this device
        if (myTwiSubAddr & TWDR) {

            // this device is being addressed
            TWI_isSelected = 1;

            // reset buffer pointer
            TWI_Ptr = 0;

        }

    // if this unit was addressed and we're receiving
    //   data, continue capturing into buffer
    } else if (TWI_SLAW_DATA_RCVD && TWI_isSelected) {

        // if this is first byte following a sub-address
        // (normally the pattern byte) and it is 0xFF
        // then treat the next stop/repeated-start as
        // the beginning of a combined format message
        if (TWI_Ptr == 0 && TWDR == 0xFF) 
            TWI_isCombinedFormat = 1;

        // record received data 
        // until buffer is full
        if (TWI_Ptr < TWI_MAX_BUFFER_SIZE) {
            TWI_Buffer[TWI_Ptr++] = TWDR;
        } else { 
            TWI_isSelected = 0;
        }

    }

    // always release clock line
    TWCR |= TWCR_TWINT;

}