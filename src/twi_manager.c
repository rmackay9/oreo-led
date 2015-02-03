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

    // configure debug pin (PB4) for twi bus
    //  error detection, set PB4 to output low.
    //  if PB4 is ever asserted high, an error has
    //  been detected
    DDRB |= 0b00010000; 
    PORTB &= 0b11101111; 

    // calculate slave address
    // 8-bit address is 0xD0, 0xD2, 
    //   0xD4, 0xD6, 7-bit is 0x68 ~ 0x6B
    char TWI_SLAVE_ADDRESS = (0xD0 + (deviceId << 1));

    // TWI Config   
    TWAR = TWI_SLAVE_ADDRESS | TWAR_TWGCE;
    TWCR = ZERO | TWCR_TWEA | TWCR_TWEN | TWCR_TWIE;

    // release clock lines on startup
    TWCR |= TWCR_TWINT;

    // enable 400kHz I2C
    TWHSR = TWHSR_TWHS;	

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

    
    switch(TWSR) {

        // bus failure
        case TWI_BUS_ERROR:

            // release clock line and send stop bit
            //   in the event of a bus failure detected
            TWCR |= TWCR_TWINT | TWCR_TWSTO;

            break; 

        // general call detected
        case TWI_GENCALL_RCVD:

            // execute callback when general call received
            if (generalCallCB) generalCallCB();

            break; 

        // record the end of a transmission if 
        //   stop bit received
        //   TODO handle condition when stopped bit missed
        case TWI_STOP_RCVD:

            // execute callback when data received
            if (dataReceivedCB) dataReceivedCB();
            
            break;

        // every message with begin here
        // reset pointer
        case TWI_SLAW_RCVD:

            TWI_Ptr = 0;
            TWI_isBufferAvailable = 1;

            break; 

        // if this unit was addressed and we're receiving
        //   data, continue capturing into buffer
        case TWI_SLAW_DATA_RCVD:

            // record received data 
            //   until buffer is full
            if (TWI_Ptr == TWI_MAX_BUFFER_SIZE) 
                TWI_isBufferAvailable = 0;

            if (TWI_isBufferAvailable)
                TWI_Buffer[TWI_Ptr++] = TWDR;

            break;

        default:

            // default case 
            //  assert PB4 for debug
            PORTB |= 0b00010000; 

    }

    // always release clock line
    TWCR |= TWCR_TWINT;

}