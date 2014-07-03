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

#define TWI_CMD_LIGHT_PULSE	0x10
#define TWI_CMD_LIGHT_ON	0x20
#define TWI_CMD_LIGHT_OFF	0x40

#define IOCLK_DIV1024	(1<<CS12)|(0<<CS11)|(1<<CS10)
#define IOCLK_DIV256	(1<<CS12)|(0<<CS11)|(0<<CS10)
#define IOCLK_DIV64		(0<<CS12)|(1<<CS11)|(1<<CS10)
#define IOCLK_DIV8		(0<<CS12)|(1<<CS11)|(0<<CS10)
#define IOCLK_DIV1		(0<<CS12)|(0<<CS11)|(1<<CS10)

#define COM1A_ENABLE (1<<COM1A1)|(0<<COM1A0)
#define COM1B_ENABLE (1<<COM1B1)|(0<<COM1B0)

#define FASTPWM_8BIT_A	(0<<WGM11)|(1<<WGM10)
#define FASTPWM_9BIT_A	(1<<WGM11)|(0<<WGM10)
#define FASTPWM_10BIT_A	(1<<WGM11)|(1<<WGM10)

#define FASTPWM_B (0<<WGM13)|(1<<WGM12)

uint16_t current_comp_val = 0;

unsigned char TWI_Act_On_Failure_In_Last_Transmission ( unsigned char TWIerrorMsg );

/*	IOclk/FastPWM hertz table
	These are the 'easy' hertz rates to hit with the default timers
 				8bit	9bit	10bit
	IOCLK_1		4010	2005	1002.5
	IOCLK_8		501		250.5	125.25
	IOCLK_64	62.66	31.33	15.665
	IOCLK_256	15.65	7.825	3.9125
	IOCLK_1024	3.9		1.95	0.975 */

int main(void)
{
	unsigned char messageBuf[TWI_BUFFER_SIZE];
	unsigned char TWI_slaveAddress;  
	
	TWI_slaveAddress = 0x18;
	TWI_Slave_Initialise( (unsigned char)((TWI_slaveAddress<<TWI_ADR_BITS)));
	
	TWI_Start_Transceiver();
	
	//DDRB = (1<<DDB2);
	//PORTB = (1<<PB2);
	DDRB = (1<<DDB1)|(1<<DDB2);
	PORTB = 0x0;
	
	sei();
	
	
	TCCR1A = FASTPWM_10BIT_A|COM1B_ENABLE|COM1A_ENABLE;
	TCCR1B = (0<<ICNC1)|(0<<ICES1)|FASTPWM_B|IOCLK_DIV8;
	OCR1A = 0x32;
	OCR1B = 0x32;
	current_comp_val = 0x32;
	TIMSK1 |= (1<<TOIE1);
	
	
	while(1) { 
		;
	}		
/*		uint16_t samples = 0;
		for(samples=0; samples < 0x01ff; samples++) {
			if(samples < 0x0010) {
				PORTB |= (1<<PORTB1);
				} else {
				PORTB = 0;
			}
		}
		
	} */
	
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
	} 
}

#define SAFE_COMPARE 0x10f
uint8_t up = 0;


ISR(TIMER1_OVF_vect)
{
	if(up){
		current_comp_val++;
		if(current_comp_val > SAFE_COMPARE) {
			up = 0;
		}
	} else {
		current_comp_val--;
		if(current_comp_val == 0) {
			up = 1;
		}
	}
	OCR1B = current_comp_val;
	OCR1A = current_comp_val;
}

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