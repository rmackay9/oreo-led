/**********************************************************************

  twi_manager.h - I2C/TWI wrapper methods to asynchronously handle 
    transmission events. A maximum buffer size and slave address must
    be specified in the header file.



  Authors: 
    Nate Fisher

  Created at: 
    Wed Oct 1, 2014

  <License> 
  <Copyright>

**********************************************************************/

#ifndef  TWI_MANAGER_H
#define  TWI_MANAGER_H

#include "utilities.h"

// TODO replace with hardware address detection pins
#define TWI_SLAVE_ADDRESS   0xD0

// TWI buffer
int TWI_Ptr;
#define TWI_MAX_BUFFER_SIZE 100
char TWI_Buffer[TWI_MAX_BUFFER_SIZE];

// TWI hardware flags
#define TWAR_TWGCE          0b00000001
#define TWCR_TWINT          0b10000000
#define TWCR_TWEA           0b01000000
#define TWCR_TWEN           0b00000100
#define TWCR_TWIE           0b00000001

// TWI status definitions, as found in the
// device datasheet
#define TWI_SLAW_RCVD       (TWSR == 0x60) 
#define TWI_SLAR_RCVD       (TWSR == 0xA8) 
#define TWI_SLAW_DATA_RCVD  (TWSR == 0x80) 
#define TWI_GENCALL_RCVD    (TWSR == 0x70) 
#define TWI_STOP_RCVD       (TWSR == 0xA0) 

// TWI application status flags
uint8_t TWI_isCombinedFormat;
uint8_t TWI_isSubAddrByte;
uint8_t TWI_isSelected;

// callbacks
void (*generalCallCB)();
void (*dataReceivedCB)();

void TWI_onGeneralCall(void (*)());
void TWI_onDataReceived(void (*)());
char* TWI_getBuffer(void);
int TWI_getBufferSize(void);
void TWI_init(int);

#endif
