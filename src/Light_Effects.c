/*
 * Light_Effects.c
 *
 */


/*
int main(void)
{

    DDRB = (1<<DDB1)|(1<<DDB2);
    PORTB = 0x0;
    
    sei();
    
    TCCR1A = FASTPWM_10BIT_A|COM1B_ENABLE|COM1A_ENABLE;
    TCCR1B = (0<<ICNC1)|(0<<ICES1)|FASTPWM_B|IOCLK_DIV8;
    TIMSK1 |= (1<<TOIE1);
    
    OCR1A = 0x0F;
    OCR1B = 0x0F;

    while(1);

}


ISR(TIMER1_OVF_vect)
{

    OCR1B = 0x0F;
    OCR1A = 0x0F;

}
*/