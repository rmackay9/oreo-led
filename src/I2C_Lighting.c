/*
 * I2C_Lighting.c
 *
 * Created: 6/25/2014 3:37:19 PM
 *  Author: john
 */  

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/cpufunc.h>
#include "TWI_Slave.h"
#include "Light_Manager.h"

#define TWI_CMD_LIGHT_PULSE 0x10
#define TWI_CMD_LIGHT_ON    0x20
#define TWI_CMD_LIGHT_OFF   0x40

#define IOCLK_DIV1024       (1<<CS12)|(0<<CS11)|(1<<CS10)
#define IOCLK_DIV256        (1<<CS12)|(0<<CS11)|(0<<CS10)
#define IOCLK_DIV64         (0<<CS12)|(1<<CS11)|(1<<CS10)
#define IOCLK_DIV8          (0<<CS12)|(1<<CS11)|(0<<CS10)
#define IOCLK_DIV1          (0<<CS12)|(0<<CS11)|(1<<CS10)

#define COM1A_ENABLE        (1<<COM1A1)|(0<<COM1A0)
#define COM1B_ENABLE        (1<<COM1B1)|(0<<COM1B0)

#define FASTPWM_8BIT_A      (0<<WGM11)|(1<<WGM10)
#define FASTPWM_9BIT_A      (1<<WGM11)|(0<<WGM10)
#define FASTPWM_10BIT_A     (1<<WGM11)|(1<<WGM10)

#define FASTPWM_B           (0<<WGM13)|(1<<WGM12)

uint8_t light_pattern;

unsigned char TWI_Act_On_Failure_In_Last_Transmission ( unsigned char TWIerrorMsg );

unsigned char TWI_Act_On_Failure_In_Last_Transmission ( unsigned char TWIerrorMsg )
{
    // A failure has occurred, use TWIerrorMsg to determine the nature of the failure
    // and take appropriate actions.
    // Se header file for a list of possible failures messages.
    
    // This very simple example puts the error code on PORTB and restarts the transceiver with
    // all the same data in the transmission buffers.
    //PORTB = TWIerrorMsg;
    TWI_Start_Transceiver();
    
    return TWIerrorMsg;
} 

int main(void)
{

    // TODO: record module position from hardware switches

    // setup I2C
    unsigned char messageBuf[TWI_BUFFER_SIZE];
    unsigned char TWI_slaveAddress;  
    TWI_slaveAddress = 0x18;
    TWI_Slave_Initialise( (unsigned char)((TWI_slaveAddress<<TWI_ADR_BITS)));
    TWI_Start_Transceiver();
    
    // enable OC1A output driver
    DDRB = (1<<DDB1)|(1<<DDB2);

    // set port b pins as output
    PORTB = 0x00;
        
    // enable PWM signal from OC1 A&B pins
    // enable 10-bit fast PWM mode (125.25Hz)
    TCCR1A = FASTPWM_10BIT_A | COM1B_ENABLE | COM1A_ENABLE;
    TCCR1B = (0<<ICNC1) | (0<<ICES1) | FASTPWM_B | IOCLK_DIV8;

    // enable T1 interrupts
    TIMSK1 |= TOIE1;
    
    // initialize the light manager
    //LightManager_init(&OCR1B, &OCR1A);

    // set an initial pattern
    light_pattern = 0x01;

    // enable interrupts (via global mask)
    sei();

    // begin main loop
    while(1) {
        // sleep();
    }
    
    /*
    while(1)
    {
        if( ! TWI_statusReg.RxDataInBuf ) {
            if(TWI_Transceiver_Busy()) {
                MCUCR = (1<<SE)|(0<<SM1)|(0<<SM0); // Enable sleep with idle mode
            } else {
                MCUCR = (1<<SE)|(1<<SM1)|(0<<SM0); // Enable sleep with power-down mode
            }
            sleep_mode();
        } else {
            _NOP(); // There is data in the buffer, code below takes care of it.
        }
        
        if ( ! TWI_Transceiver_Busy() )
        {
            // Check if the last operation was successful
            if ( TWI_statusReg.lastTransOK )
            {
                // Check if the last operation was a reception
                if ( TWI_statusReg.RxDataInBuf )
                {
                    TWI_Get_Data_From_Transceiver(messageBuf, 2);

                    switch(messageBuf[0]){
                        case TWI_CMD_LIGHT_OFF:
                            break;
                        case TWI_CMD_LIGHT_ON:
                            break;
                        case TWI_CMD_LIGHT_PULSE:
                            break;
                    }                       
                }
                else // Ends up here if the last operation was a transmission
                {
                    _NOP(); // Put own code here.
                }
                // Check if the TWI Transceiver has already been started.
                // If not then restart it to prepare it for new receptions.
                if ( ! TWI_Transceiver_Busy() )
                {
                    TWI_Start_Transceiver();
                }
            }
            else // Ends up here if the last operation completed unsuccessfully
            {
                TWI_Act_On_Failure_In_Last_Transmission( TWI_Get_State_Info() );
            }   
        }
    } */
}

// timer1 overflow interrupt routine
ISR(TIMER1_OVF_vect)
{

    OCR1A = 0xaa;
    OCR1B = 0xff;

    // mark time in light manager
    //LightManager_tick();

    // implement the currently selected pattern
    //LightManager_setPattern(light_pattern);

}
    
