/**********************************************************************

  twi_manager.h - I2C/TWI wrapper methods to asynchronously handle 
    transmission events. A maximum buffer size and slave address must
    be specified in the header file.


  Authors: 
    Nate Fisher

  Created: 
    Wed Oct 1, 2014

**********************************************************************/

#ifndef  TWI_MANAGER_H
#define  TWI_MANAGER_H

#include "utilities.h"

// TWI buffer
int TWI_Ptr;
#define TWI_MAX_BUFFER_SIZE 100
char TWI_Buffer[TWI_MAX_BUFFER_SIZE];

// TWI hardware flags
#define TWCR_TWINT          0b10000000 // TWI Interrupt Flag
#define TWCR_TWEA           0b01000000 // TWI Enable Acknowledge Bit
#define TWCR_TWSTA          0b00100000 // TWI START Condition Bit
#define TWCR_TWSTO          0b00010000 // TWI STOP Condition Bit
#define TWCR_TWWC           0b00001000 // TWI Write Collision Flag
#define TWCR_TWEN           0b00000100 // TWI Enable Bit
#define TWCR_TWIE           0b00000001

#define TWAR_TWGCE          0b00000001
#define TWHSR_TWHS          0b00000001

/****************************************************************************
  TWI State codes from Atmel Corporation App Note AVR311
****************************************************************************/
// General TWI Master staus codes                      
#define TWI_START                  0x08  // START has been transmitted  
#define TWI_REP_START              0x10  // Repeated START has been transmitted
#define TWI_ARB_LOST               0x38  // Arbitration lost

// TWI Master Transmitter staus codes                      
#define TWI_MTX_ADR_ACK            0x18  // SLA+W has been tramsmitted and ACK received
#define TWI_MTX_ADR_NACK           0x20  // SLA+W has been tramsmitted and NACK received 
#define TWI_MTX_DATA_ACK           0x28  // Data byte has been tramsmitted and ACK received
#define TWI_MTX_DATA_NACK          0x30  // Data byte has been tramsmitted and NACK received 

// TWI Master Receiver staus codes  
#define TWI_MRX_ADR_ACK            0x40  // SLA+R has been tramsmitted and ACK received
#define TWI_MRX_ADR_NACK           0x48  // SLA+R has been tramsmitted and NACK received
#define TWI_MRX_DATA_ACK           0x50  // Data byte has been received and ACK tramsmitted
#define TWI_MRX_DATA_NACK          0x58  // Data byte has been received and NACK tramsmitted

// TWI Slave Transmitter staus codes
#define TWI_STX_ADR_ACK            0xA8  // Own SLA+R has been received; ACK has been returned
#define TWI_STX_ADR_ACK_M_ARB_LOST 0xB0  // Arbitration lost in SLA+R/W as Master; own SLA+R has been received; ACK has been returned
#define TWI_STX_DATA_ACK           0xB8  // Data byte in TWDR has been transmitted; ACK has been received
#define TWI_STX_DATA_NACK          0xC0  // Data byte in TWDR has been transmitted; NOT ACK has been received
#define TWI_STX_DATA_ACK_LAST_BYTE 0xC8  // Last data byte in TWDR has been transmitted (TWEA = “0”); ACK has been received

// TWI Slave Receiver staus codes
#define TWI_SRX_ADR_ACK            0x60  // Own SLA+W has been received ACK has been returned
#define TWI_SRX_ADR_ACK_M_ARB_LOST 0x68  // Arbitration lost in SLA+R/W as Master; own SLA+W has been received; ACK has been returned
#define TWI_SRX_GEN_ACK            0x70  // General call address has been received; ACK has been returned
#define TWI_SRX_GEN_ACK_M_ARB_LOST 0x78  // Arbitration lost in SLA+R/W as Master; General call address has been received; ACK has been returned
#define TWI_SRX_ADR_DATA_ACK       0x80  // Previously addressed with own SLA+W; data has been received; ACK has been returned
#define TWI_SRX_ADR_DATA_NACK      0x88  // Previously addressed with own SLA+W; data has been received; NOT ACK has been returned
#define TWI_SRX_GEN_DATA_ACK       0x90  // Previously addressed with general call; data has been received; ACK has been returned
#define TWI_SRX_GEN_DATA_NACK      0x98  // Previously addressed with general call; data has been received; NOT ACK has been returned
#define TWI_SRX_STOP_RESTART       0xA0  // A STOP condition or repeated START condition has been received while still addressed as Slave

// TWI Miscellaneous status codes
#define TWI_NO_STATE               0xF8  // No relevant state information available; TWINT = “0”
#define TWI_BUS_ERROR              0x00  // Bus error due to an illegal START or STOP condition

// TWI application status flags
uint8_t TWI_isBufferAvailable; 
uint8_t TWI_isSlaveAddressed;

// callbacks
void (*generalCallCB)();
void (*dataReceivedCB)();

void TWI_onGeneralCall(void (*)());
void TWI_onDataReceived(void (*)());
char* TWI_getBuffer(void);
int TWI_getBufferSize(void);
void TWI_init(uint8_t);

#endif
