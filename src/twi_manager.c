#define TWAR_TWGCE          0b00000001
#define TWCR_TWINT          0b10000000
#define TWCR_TWEA           0b01000000
#define TWCR_TWEN           0b00000100
#define TWCR_TWIE           0b00000001



// TWI Stuff
#define TWI_SLAVE_ADDRESS   0xB0
#define TWI_MAX_BUFFER_SIZE 50
#define TWI_SLAW_RCVD       (TWSR == 0x60) 
#define TWI_SLAR_RCVD       (TWSR == 0xA8) 
#define TWI_SLAW_DATA_RCVD  (TWSR == 0x80) 
#define TWI_GENCALL_RCVD    (TWSR == 0x90) // TODO should be 0x70?
#define TWI_STOP_RCVD       (TWSR == 0xA0) 
int TWI_isCombinedFormat;
int TWI_isSubAddrByte;
int TWI_isSelected;
int TWI_Ptr;
char TWI_Buffer[TWI_MAX_BUFFER_SIZE];


// TWI Config
TWAR = TWI_SLAVE_ADDRESS | TWAR_TWGCE;
TWCR = ZERO | TWCR_TWEA | TWCR_TWEN | TWCR_TWIE;

void TWI_onGeneralCall(void *) {}
void TWI_onDataReceived(void *) {}



// TODO combine all flags to a bit mask pattern?
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

        // record the phase error for correction
        // in mainloop
        LightManager_recordPhaseError();

    // record the end of a transmission if 
    //   stop bit received
    //   TODO handle condition when stopped bit missed
    } else if (TWI_STOP_RCVD && TWI_isSelected) {

        // if this is a repeated-start,
        // answer the next SLA+R
        if (!TWI_isCombinedFormat) {
            // set flag to re-parse TWI command
            LightManager_setCommandUpdated();
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