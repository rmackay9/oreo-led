GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccMH0SHH.s 			page 1


   1               		.file	"main.c"
   2               	__SP_H__ = 0x3e
   3               	__SP_L__ = 0x3d
   4               	__SREG__ = 0x3f
   5               	__tmp_reg__ = 0
   6               	__zero_reg__ = 1
   7               		.text
   8               	.Ltext0:
   9               		.cfi_sections	.debug_frame
  10               	.global	NODE_getId
  12               	NODE_getId:
  13               	.LFB4:
  14               		.file 1 "include/node_manager.h"
   1:include/node_manager.h **** /**********************************************************************
   2:include/node_manager.h **** 
   3:include/node_manager.h ****   node_manager.h - derive a unit identification based on installed
   4:include/node_manager.h ****     configuration. Also calculate the network communications address
   5:include/node_manager.h ****     based on the ident.
   6:include/node_manager.h **** 
   7:include/node_manager.h **** 
   8:include/node_manager.h ****   Authors: 
   9:include/node_manager.h ****     Nate Fisher
  10:include/node_manager.h **** 
  11:include/node_manager.h ****   Created: 
  12:include/node_manager.h ****     Wed Oct 1, 2014
  13:include/node_manager.h **** 
  14:include/node_manager.h **** **********************************************************************/
  15:include/node_manager.h **** 
  16:include/node_manager.h **** #ifndef  NODE_MANAGER_H
  17:include/node_manager.h **** #define  NODE_MANAGER_H
  18:include/node_manager.h **** 
  19:include/node_manager.h **** uint8_t NODE_getId() {
  15               		.loc 1 19 0
  16               		.cfi_startproc
  17               	/* prologue: function */
  18               	/* frame size = 0 */
  19               	/* stack size = 0 */
  20               	.L__stack_usage = 0
  20:include/node_manager.h **** 
  21:include/node_manager.h ****     SPCR    = 0x00; // disable SPI
  21               		.loc 1 21 0
  22 0000 1CBC      		out 0x2c,__zero_reg__
  22:include/node_manager.h ****     PCICR   = 0x00; // disable all pin interrupts
  23               		.loc 1 22 0
  24 0002 1092 6800 		sts 104,__zero_reg__
  23:include/node_manager.h **** 
  24:include/node_manager.h ****     // set PB4/PB3 as inputs (0 == input | 1 == output)
  25:include/node_manager.h ****     DDRB &= 0b11100111; 
  25               		.loc 1 25 0
  26 0006 84B1      		in r24,0x4
  27 0008 877E      		andi r24,lo8(-25)
  28 000a 84B9      		out 0x4,r24
  26:include/node_manager.h **** 
  27:include/node_manager.h ****     // turn off pullup resistor
  28:include/node_manager.h ****     PORTB = 0x00;
  29               		.loc 1 28 0
  30 000c 15B8      		out 0x5,__zero_reg__
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccMH0SHH.s 			page 2


  29:include/node_manager.h **** 
  30:include/node_manager.h ****     // capture unit position 
  31:include/node_manager.h ****     uint8_t position = (PINB & 0b00011000) >> 3;
  31               		.loc 1 31 0
  32 000e 83B1      		in r24,0x3
  33               	.LVL0:
  34 0010 8871      		andi r24,lo8(24)
  35               	.LVL1:
  32:include/node_manager.h **** 
  33:include/node_manager.h ****     return position;
  34:include/node_manager.h **** 
  35:include/node_manager.h **** }
  36               		.loc 1 35 0
  37 0012 8695      		lsr r24
  38 0014 8695      		lsr r24
  39 0016 8695      		lsr r24
  40               	.LVL2:
  41 0018 0895      		ret
  42               		.cfi_endproc
  43               	.LFE4:
  45               		.section	.text.startup,"ax",@progbits
  46               	.global	main
  48               	main:
  49               	.LFB5:
  50               		.file 2 "src/main.c"
   1:src/main.c    **** /**********************************************************************
   2:src/main.c    **** 
   3:src/main.c    ****   main.c - implementation of aircraft lighting system. Commands to the 
   4:src/main.c    ****    system are transmitted via a common I2C bus, connecting all lighting 
   5:src/main.c    ****    units (slave devices) with the Pixhawk (as master transmitter). 
   6:src/main.c    **** 
   7:src/main.c    **** 
   8:src/main.c    ****   Authors: 
   9:src/main.c    ****     Nate Fisher
  10:src/main.c    **** 
  11:src/main.c    ****   Created: 
  12:src/main.c    ****     Wed Oct 1, 2014
  13:src/main.c    **** 
  14:src/main.c    **** **********************************************************************/
  15:src/main.c    **** 
  16:src/main.c    **** #include <avr/io.h>
  17:src/main.c    **** #include <avr/interrupt.h>
  18:src/main.c    **** #include <avr/sleep.h>
  19:src/main.c    **** #include <avr/cpufunc.h>
  20:src/main.c    **** 
  21:src/main.c    **** #include "math.h"
  22:src/main.c    **** 
  23:src/main.c    **** #include "pattern_generator.h"
  24:src/main.c    **** #include "light_pattern_protocol.h"
  25:src/main.c    **** #include "synchro_clock.h"
  26:src/main.c    **** #include "twi_manager.h"
  27:src/main.c    **** #include "waveform_generator.h"
  28:src/main.c    **** #include "node_manager.h"
  29:src/main.c    **** 
  30:src/main.c    **** 
  31:src/main.c    **** int main(void) {
  51               		.loc 2 31 0
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccMH0SHH.s 			page 3


  52               		.cfi_startproc
  53 0000 CF93      		push r28
  54               	.LCFI0:
  55               		.cfi_def_cfa_offset 3
  56               		.cfi_offset 28, -2
  57 0002 DF93      		push r29
  58               	.LCFI1:
  59               		.cfi_def_cfa_offset 4
  60               		.cfi_offset 29, -3
  61 0004 CDB7      		in r28,__SP_L__
  62 0006 DEB7      		in r29,__SP_H__
  63               	.LCFI2:
  64               		.cfi_def_cfa_register 28
  65 0008 CE54      		subi r28,78
  66 000a D109      		sbc r29,__zero_reg__
  67               	.LCFI3:
  68               		.cfi_def_cfa_offset 82
  69 000c 0FB6      		in __tmp_reg__,__SREG__
  70 000e F894      		cli
  71 0010 DEBF      		out __SP_H__,r29
  72 0012 0FBE      		out __SREG__,__tmp_reg__
  73 0014 CDBF      		out __SP_L__,r28
  74               	/* prologue: function */
  75               	/* frame size = 78 */
  76               	/* stack size = 80 */
  77               	.L__stack_usage = 80
  32:src/main.c    ****     
  33:src/main.c    ****     // init synchro node singleton
  34:src/main.c    ****     SYNCLK_init();
  78               		.loc 2 34 0
  79 0016 00D0      		rcall SYNCLK_init
  80               	.LVL3:
  35:src/main.c    **** 
  36:src/main.c    ****     // init TWI node singleton with device ID
  37:src/main.c    ****     TWI_init(NODE_getId());
  81               		.loc 2 37 0
  82 0018 00D0      		rcall NODE_getId
  83               	.LVL4:
  84 001a 00D0      		rcall TWI_init
  85               	.LVL5:
  38:src/main.c    **** 
  39:src/main.c    ****     // register TWI event callbacks
  40:src/main.c    ****     TWI_onGeneralCall(SYNCLK_recordPhaseError);
  86               		.loc 2 40 0
  87 001c 80E0      		ldi r24,lo8(gs(SYNCLK_recordPhaseError))
  88 001e 90E0      		ldi r25,hi8(gs(SYNCLK_recordPhaseError))
  89 0020 00D0      		rcall TWI_onGeneralCall
  90               	.LVL6:
  41:src/main.c    ****     TWI_onDataReceived(LPP_setCommandRefreshed);
  91               		.loc 2 41 0
  92 0022 80E0      		ldi r24,lo8(gs(LPP_setCommandRefreshed))
  93 0024 90E0      		ldi r25,hi8(gs(LPP_setCommandRefreshed))
  94 0026 00D0      		rcall TWI_onDataReceived
  95               	.LVL7:
  42:src/main.c    **** 
  43:src/main.c    ****     // create pattern generators for all
  44:src/main.c    ****     //  three LED channels
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccMH0SHH.s 			page 4


  45:src/main.c    ****     PatternGenerator pgRed;
  46:src/main.c    ****     PatternGenerator pgGreen;
  47:src/main.c    ****     PatternGenerator pgBlue;
  48:src/main.c    **** 
  49:src/main.c    ****     // init the generators
  50:src/main.c    ****     PG_init(&pgRed);
  96               		.loc 2 50 0
  97 0028 CE01      		movw r24,r28
  98 002a C196      		adiw r24,49
  99 002c 00D0      		rcall PG_init
 100               	.LVL8:
  51:src/main.c    ****     PG_init(&pgGreen);
 101               		.loc 2 51 0
 102 002e CE01      		movw r24,r28
 103 0030 4996      		adiw r24,25
 104 0032 00D0      		rcall PG_init
 105               	.LVL9:
  52:src/main.c    ****     PG_init(&pgBlue);
 106               		.loc 2 52 0
 107 0034 CE01      		movw r24,r28
 108 0036 0196      		adiw r24,1
 109 0038 00D0      		rcall PG_init
 110               	.LVL10:
  53:src/main.c    **** 
  54:src/main.c    ****     // register pattern generators with the
  55:src/main.c    ****     //  lighting pattern protocol interface
  56:src/main.c    ****     LPP_setRedPatternGen(&pgRed);
 111               		.loc 2 56 0
 112 003a CE01      		movw r24,r28
 113 003c C196      		adiw r24,49
 114 003e 00D0      		rcall LPP_setRedPatternGen
 115               	.LVL11:
  57:src/main.c    ****     LPP_setGreenPatternGen(&pgGreen);
 116               		.loc 2 57 0
 117 0040 CE01      		movw r24,r28
 118 0042 4996      		adiw r24,25
 119 0044 00D0      		rcall LPP_setGreenPatternGen
 120               	.LVL12:
  58:src/main.c    ****     LPP_setBluePatternGen(&pgBlue);
 121               		.loc 2 58 0
 122 0046 CE01      		movw r24,r28
 123 0048 0196      		adiw r24,1
 124 004a 00D0      		rcall LPP_setBluePatternGen
 125               	.LVL13:
  59:src/main.c    **** 
  60:src/main.c    ****     // register the pattern generator calculated values
  61:src/main.c    ****     //  with hardware waveform outputs
  62:src/main.c    ****     uint8_t* wavegen_inputs[3] = {&(pgRed.value), &(pgGreen.value), &(pgBlue.value)};
 126               		.loc 2 62 0
 127 004c 81E3      		ldi r24,lo8(49)
 128 004e 90E0      		ldi r25,0
 129 0050 8C0F      		add r24,r28
 130 0052 9D1F      		adc r25,r29
 131 0054 4796      		adiw r24,23
 132 0056 2B96      		adiw r28,73-62
 133 0058 9FAF      		std Y+63,r25
 134 005a 8EAF      		std Y+62,r24
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccMH0SHH.s 			page 5


 135 005c 2B97      		sbiw r28,73-62
 136 005e 4897      		sbiw r24,24
 137 0060 2D96      		adiw r28,75-62
 138 0062 9FAF      		std Y+63,r25
 139 0064 8EAF      		std Y+62,r24
 140 0066 2D97      		sbiw r28,75-62
 141 0068 4897      		sbiw r24,24
 142 006a 2F96      		adiw r28,77-62
 143 006c 9FAF      		std Y+63,r25
 144 006e 8EAF      		std Y+62,r24
 145 0070 2F97      		sbiw r28,77-62
  63:src/main.c    ****     WG_init(wavegen_inputs, 3);
 146               		.loc 2 63 0
 147 0072 63E0      		ldi r22,lo8(3)
 148 0074 70E0      		ldi r23,0
 149 0076 C196      		adiw r24,49
 150 0078 00D0      		rcall WG_init
 151               	.LVL14:
  64:src/main.c    **** 
  65:src/main.c    ****     // attach clock input to the synchroniced timing
  66:src/main.c    ****     //  module, to ultimately drive the pattern generator
  67:src/main.c    ****     //  updates in a coordinated way
  68:src/main.c    ****     WG_onOverflow(SYNCLK_updateClock);
 152               		.loc 2 68 0
 153 007a 80E0      		ldi r24,lo8(gs(SYNCLK_updateClock))
 154 007c 90E0      		ldi r25,hi8(gs(SYNCLK_updateClock))
 155 007e 00D0      		rcall WG_onOverflow
 156               	.LVL15:
  69:src/main.c    **** 
  70:src/main.c    ****     // enable interrupts 
  71:src/main.c    ****     sei();
 157               		.loc 2 71 0
 158               	/* #APP */
 159               	 ;  71 "src/main.c" 1
 160 0080 7894      		sei
 161               	 ;  0 "" 2
 162               	/* #NOAPP */
 163               	.L3:
  72:src/main.c    **** 
  73:src/main.c    ****     // application mainloop 
  74:src/main.c    ****     while(1) {
  75:src/main.c    **** 
  76:src/main.c    ****         // run light effect calculations based
  77:src/main.c    ****         //  on synchronized clock reference
  78:src/main.c    ****         PG_calc(&pgRed, SYNCLK_getClockPosition());
 164               		.loc 2 78 0 discriminator 1
 165 0082 00D0      		rcall SYNCLK_getClockPosition
 166               	.LVL16:
 167 0084 AB01      		movw r20,r22
 168 0086 BC01      		movw r22,r24
 169 0088 CE01      		movw r24,r28
 170 008a C196      		adiw r24,49
 171 008c 00D0      		rcall PG_calc
 172               	.LVL17:
  79:src/main.c    ****         PG_calc(&pgGreen, SYNCLK_getClockPosition());
 173               		.loc 2 79 0 discriminator 1
 174 008e 00D0      		rcall SYNCLK_getClockPosition
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccMH0SHH.s 			page 6


 175               	.LVL18:
 176 0090 AB01      		movw r20,r22
 177 0092 BC01      		movw r22,r24
 178 0094 CE01      		movw r24,r28
 179 0096 4996      		adiw r24,25
 180 0098 00D0      		rcall PG_calc
 181               	.LVL19:
  80:src/main.c    ****         PG_calc(&pgBlue, SYNCLK_getClockPosition());
 182               		.loc 2 80 0 discriminator 1
 183 009a 00D0      		rcall SYNCLK_getClockPosition
 184               	.LVL20:
 185 009c AB01      		movw r20,r22
 186 009e BC01      		movw r22,r24
 187 00a0 CE01      		movw r24,r28
 188 00a2 0196      		adiw r24,1
 189 00a4 00D0      		rcall PG_calc
 190               	.LVL21:
  81:src/main.c    **** 
  82:src/main.c    ****         // update LED PWM duty cycle
  83:src/main.c    ****         //  with values computed in pattern generator
  84:src/main.c    ****         WG_updatePWM();
 191               		.loc 2 84 0 discriminator 1
 192 00a6 00D0      		rcall WG_updatePWM
 193               	.LVL22:
  85:src/main.c    **** 
  86:src/main.c    ****         // calculate time adjustment needed to 
  87:src/main.c    ****         //  sync up with system clock signal
  88:src/main.c    ****         SYNCLK_calcPhaseCorrection();
 194               		.loc 2 88 0 discriminator 1
 195 00a8 00D0      		rcall SYNCLK_calcPhaseCorrection
 196               	.LVL23:
  89:src/main.c    **** 
  90:src/main.c    ****         // parse commands per interface contract
  91:src/main.c    ****         //  and update pattern generators accordingly
  92:src/main.c    ****         LPP_processBuffer(TWI_getBuffer(), TWI_getBufferSize());
 197               		.loc 2 92 0 discriminator 1
 198 00aa 00D0      		rcall TWI_getBufferSize
 199               	.LVL24:
 200 00ac 8C01      		movw r16,r24
 201 00ae 00D0      		rcall TWI_getBuffer
 202               	.LVL25:
 203 00b0 B801      		movw r22,r16
 204 00b2 00D0      		rcall LPP_processBuffer
 205               	.LVL26:
 206 00b4 00C0      		rjmp .L3
 207               		.cfi_endproc
 208               	.LFE5:
 210               		.comm	_self_waveform_gen,14,1
 211               		.comm	dataReceivedCB,2,1
 212               		.comm	generalCallCB,2,1
 213               		.comm	TWI_isBufferAvailable,1,1
 214               		.comm	TWI_isSelected,1,1
 215               		.comm	TWI_isSubAddrByte,1,1
 216               		.comm	TWI_isCombinedFormat,1,1
 217               		.comm	TWI_Buffer,100,1
 218               		.comm	TWI_Ptr,2,1
 219               		.comm	_self_synchro_clock,14,1
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccMH0SHH.s 			page 7


 220               		.comm	_self_pattern_protocol,7,1
 221               		.text
 222               	.Letext0:
 223               		.file 3 "/usr/local/CrossPack-AVR-20131216/avr/include/stdint.h"
 224               		.file 4 "include/pattern_generator.h"
 225               		.file 5 "include/light_pattern_protocol.h"
 226               		.file 6 "include/synchro_clock.h"
 227               		.file 7 "include/waveform_generator.h"
 228               		.file 8 "include/utilities.h"
 229               		.file 9 "include/twi_manager.h"
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccMH0SHH.s 			page 8


DEFINED SYMBOLS
                            *ABS*:00000000 main.c
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccMH0SHH.s:2      *ABS*:0000003e __SP_H__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccMH0SHH.s:3      *ABS*:0000003d __SP_L__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccMH0SHH.s:4      *ABS*:0000003f __SREG__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccMH0SHH.s:5      *ABS*:00000000 __tmp_reg__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccMH0SHH.s:6      *ABS*:00000001 __zero_reg__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccMH0SHH.s:12     .text:00000000 NODE_getId
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccMH0SHH.s:48     .text.startup:00000000 main
                            *COM*:0000000e _self_waveform_gen
                            *COM*:00000002 dataReceivedCB
                            *COM*:00000002 generalCallCB
                            *COM*:00000001 TWI_isBufferAvailable
                            *COM*:00000001 TWI_isSelected
                            *COM*:00000001 TWI_isSubAddrByte
                            *COM*:00000001 TWI_isCombinedFormat
                            *COM*:00000064 TWI_Buffer
                            *COM*:00000002 TWI_Ptr
                            *COM*:0000000e _self_synchro_clock
                            *COM*:00000007 _self_pattern_protocol

UNDEFINED SYMBOLS
SYNCLK_init
TWI_init
SYNCLK_recordPhaseError
TWI_onGeneralCall
LPP_setCommandRefreshed
TWI_onDataReceived
PG_init
LPP_setRedPatternGen
LPP_setGreenPatternGen
LPP_setBluePatternGen
WG_init
SYNCLK_updateClock
WG_onOverflow
SYNCLK_getClockPosition
PG_calc
WG_updatePWM
SYNCLK_calcPhaseCorrection
TWI_getBufferSize
TWI_getBuffer
LPP_processBuffer
__do_clear_bss
