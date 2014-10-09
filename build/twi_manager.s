GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s 			page 1


   1               		.file	"twi_manager.c"
   2               	__SP_H__ = 0x3e
   3               	__SP_L__ = 0x3d
   4               	__SREG__ = 0x3f
   5               	__tmp_reg__ = 0
   6               	__zero_reg__ = 1
   7               		.text
   8               	.Ltext0:
   9               		.cfi_sections	.debug_frame
  10               	.global	TWI_init
  12               	TWI_init:
  13               	.LFB2:
  14               		.file 1 "src/twi_manager.c"
   1:src/twi_manager.c **** /**********************************************************************
   2:src/twi_manager.c **** 
   3:src/twi_manager.c ****   twi_manager.c - implementation, see header for description
   4:src/twi_manager.c **** 
   5:src/twi_manager.c **** 
   6:src/twi_manager.c ****   Authors: 
   7:src/twi_manager.c ****     Nate Fisher
   8:src/twi_manager.c **** 
   9:src/twi_manager.c ****   Created: 
  10:src/twi_manager.c ****     Wed Oct 1, 2014
  11:src/twi_manager.c **** 
  12:src/twi_manager.c **** **********************************************************************/
  13:src/twi_manager.c **** 
  14:src/twi_manager.c **** #include <avr/io.h>
  15:src/twi_manager.c **** #include <avr/interrupt.h>
  16:src/twi_manager.c **** #include <avr/sleep.h>
  17:src/twi_manager.c **** #include <avr/cpufunc.h>
  18:src/twi_manager.c **** 
  19:src/twi_manager.c **** #include "twi_manager.h"
  20:src/twi_manager.c **** 
  21:src/twi_manager.c **** void TWI_init(uint8_t deviceId) {
  15               		.loc 1 21 0
  16               		.cfi_startproc
  17               	.LVL0:
  18               	/* prologue: function */
  19               	/* frame size = 0 */
  20               	/* stack size = 0 */
  21               	.L__stack_usage = 0
  22:src/twi_manager.c **** 
  23:src/twi_manager.c ****     // calculate slave address
  24:src/twi_manager.c ****     // of the form: 0xA0, 0xB0, etc..
  25:src/twi_manager.c ****     char TWI_SLAVE_ADDRESS = ((9 + deviceId) << 4) & 0xF0;
  22               		.loc 1 25 0
  23 0000 90E0      		ldi r25,0
  24 0002 0996      		adiw r24,9
  25               	.LVL1:
  26 0004 24E0      		ldi r18,4
  27               		1:
  28 0006 880F      		lsl r24
  29 0008 991F      		rol r25
  30 000a 2A95      		dec r18
  31 000c 01F4      		brne 1b
  26:src/twi_manager.c **** 
  27:src/twi_manager.c ****     // TWI Config
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s 			page 2


  28:src/twi_manager.c ****     TWAR = TWI_SLAVE_ADDRESS | TWAR_TWGCE;
  32               		.loc 1 28 0
  33 000e 8160      		ori r24,lo8(1)
  34 0010 8093 BA00 		sts 186,r24
  29:src/twi_manager.c ****     TWCR = ZERO | TWCR_TWEA | TWCR_TWEN | TWCR_TWIE;
  35               		.loc 1 29 0
  36 0014 85E4      		ldi r24,lo8(69)
  37 0016 8093 BC00 		sts 188,r24
  38 001a 0895      		ret
  39               		.cfi_endproc
  40               	.LFE2:
  42               	.global	TWI_onGeneralCall
  44               	TWI_onGeneralCall:
  45               	.LFB3:
  30:src/twi_manager.c **** 
  31:src/twi_manager.c **** }
  32:src/twi_manager.c **** 
  33:src/twi_manager.c **** // specify callback to be executed
  34:src/twi_manager.c **** //  when device receives a general call
  35:src/twi_manager.c **** void TWI_onGeneralCall(void (*cb)()) {
  46               		.loc 1 35 0
  47               		.cfi_startproc
  48               	.LVL2:
  49               	/* prologue: function */
  50               	/* frame size = 0 */
  51               	/* stack size = 0 */
  52               	.L__stack_usage = 0
  36:src/twi_manager.c **** 
  37:src/twi_manager.c ****     generalCallCB = cb;
  53               		.loc 1 37 0
  54 001c 9093 0000 		sts generalCallCB+1,r25
  55 0020 8093 0000 		sts generalCallCB,r24
  56 0024 0895      		ret
  57               		.cfi_endproc
  58               	.LFE3:
  60               	.global	TWI_onDataReceived
  62               	TWI_onDataReceived:
  63               	.LFB4:
  38:src/twi_manager.c **** 
  39:src/twi_manager.c **** }
  40:src/twi_manager.c **** 
  41:src/twi_manager.c **** // specify callback to be executed
  42:src/twi_manager.c **** //  when device receives a completed 
  43:src/twi_manager.c **** //  data packet (at STOP signal)
  44:src/twi_manager.c **** void TWI_onDataReceived(void (*cb)()) {
  64               		.loc 1 44 0
  65               		.cfi_startproc
  66               	.LVL3:
  67               	/* prologue: function */
  68               	/* frame size = 0 */
  69               	/* stack size = 0 */
  70               	.L__stack_usage = 0
  45:src/twi_manager.c **** 
  46:src/twi_manager.c ****     dataReceivedCB = cb;
  71               		.loc 1 46 0
  72 0026 9093 0000 		sts dataReceivedCB+1,r25
  73 002a 8093 0000 		sts dataReceivedCB,r24
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s 			page 3


  74 002e 0895      		ret
  75               		.cfi_endproc
  76               	.LFE4:
  78               	.global	TWI_getBuffer
  80               	TWI_getBuffer:
  81               	.LFB5:
  47:src/twi_manager.c **** 
  48:src/twi_manager.c **** }
  49:src/twi_manager.c **** 
  50:src/twi_manager.c **** // returns pointer to TWI data buffer
  51:src/twi_manager.c **** char* TWI_getBuffer(void) {
  82               		.loc 1 51 0
  83               		.cfi_startproc
  84               	/* prologue: function */
  85               	/* frame size = 0 */
  86               	/* stack size = 0 */
  87               	.L__stack_usage = 0
  52:src/twi_manager.c **** 
  53:src/twi_manager.c ****     return TWI_Buffer;
  54:src/twi_manager.c **** 
  55:src/twi_manager.c **** }
  88               		.loc 1 55 0
  89 0030 80E0      		ldi r24,lo8(TWI_Buffer)
  90 0032 90E0      		ldi r25,hi8(TWI_Buffer)
  91 0034 0895      		ret
  92               		.cfi_endproc
  93               	.LFE5:
  95               	.global	TWI_getBufferSize
  97               	TWI_getBufferSize:
  98               	.LFB6:
  56:src/twi_manager.c **** 
  57:src/twi_manager.c **** // returns buffer pointer
  58:src/twi_manager.c **** int TWI_getBufferSize(void) {
  99               		.loc 1 58 0
 100               		.cfi_startproc
 101               	/* prologue: function */
 102               	/* frame size = 0 */
 103               	/* stack size = 0 */
 104               	.L__stack_usage = 0
  59:src/twi_manager.c **** 
  60:src/twi_manager.c ****     return TWI_Ptr;
  61:src/twi_manager.c **** 
  62:src/twi_manager.c **** }
 105               		.loc 1 62 0
 106 0036 8091 0000 		lds r24,TWI_Ptr
 107 003a 9091 0000 		lds r25,TWI_Ptr+1
 108 003e 0895      		ret
 109               		.cfi_endproc
 110               	.LFE6:
 112               	.global	__vector_19
 114               	__vector_19:
 115               	.LFB7:
  63:src/twi_manager.c **** 
  64:src/twi_manager.c **** // TWI ISR
  65:src/twi_manager.c **** ISR(TWI_vect) {
 116               		.loc 1 65 0
 117               		.cfi_startproc
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s 			page 4


 118 0040 1F92      		push r1
 119               	.LCFI0:
 120               		.cfi_def_cfa_offset 3
 121               		.cfi_offset 1, -2
 122 0042 0F92      		push r0
 123               	.LCFI1:
 124               		.cfi_def_cfa_offset 4
 125               		.cfi_offset 0, -3
 126 0044 0FB6      		in r0,__SREG__
 127 0046 0F92      		push r0
 128 0048 1124      		clr __zero_reg__
 129 004a 2F93      		push r18
 130               	.LCFI2:
 131               		.cfi_def_cfa_offset 5
 132               		.cfi_offset 18, -4
 133 004c 3F93      		push r19
 134               	.LCFI3:
 135               		.cfi_def_cfa_offset 6
 136               		.cfi_offset 19, -5
 137 004e 4F93      		push r20
 138               	.LCFI4:
 139               		.cfi_def_cfa_offset 7
 140               		.cfi_offset 20, -6
 141 0050 5F93      		push r21
 142               	.LCFI5:
 143               		.cfi_def_cfa_offset 8
 144               		.cfi_offset 21, -7
 145 0052 6F93      		push r22
 146               	.LCFI6:
 147               		.cfi_def_cfa_offset 9
 148               		.cfi_offset 22, -8
 149 0054 7F93      		push r23
 150               	.LCFI7:
 151               		.cfi_def_cfa_offset 10
 152               		.cfi_offset 23, -9
 153 0056 8F93      		push r24
 154               	.LCFI8:
 155               		.cfi_def_cfa_offset 11
 156               		.cfi_offset 24, -10
 157 0058 9F93      		push r25
 158               	.LCFI9:
 159               		.cfi_def_cfa_offset 12
 160               		.cfi_offset 25, -11
 161 005a AF93      		push r26
 162               	.LCFI10:
 163               		.cfi_def_cfa_offset 13
 164               		.cfi_offset 26, -12
 165 005c BF93      		push r27
 166               	.LCFI11:
 167               		.cfi_def_cfa_offset 14
 168               		.cfi_offset 27, -13
 169 005e EF93      		push r30
 170               	.LCFI12:
 171               		.cfi_def_cfa_offset 15
 172               		.cfi_offset 30, -14
 173 0060 FF93      		push r31
 174               	.LCFI13:
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s 			page 5


 175               		.cfi_def_cfa_offset 16
 176               		.cfi_offset 31, -15
 177               	/* prologue: Signal */
 178               	/* frame size = 0 */
 179               	/* stack size = 15 */
 180               	.L__stack_usage = 15
  66:src/twi_manager.c **** 
  67:src/twi_manager.c ****     // general call detected
  68:src/twi_manager.c ****     if (TWI_GENCALL_RCVD) {
 181               		.loc 1 68 0
 182 0062 8091 B900 		lds r24,185
 183 0066 8037      		cpi r24,lo8(112)
 184 0068 01F4      		brne .L7
  69:src/twi_manager.c **** 
  70:src/twi_manager.c ****         // execute callback when general call received
  71:src/twi_manager.c ****         if (generalCallCB) generalCallCB();
 185               		.loc 1 71 0
 186 006a E091 0000 		lds r30,generalCallCB
 187 006e F091 0000 		lds r31,generalCallCB+1
 188 0072 00C0      		rjmp .L22
 189               	.L7:
  72:src/twi_manager.c **** 
  73:src/twi_manager.c ****     // record the end of a transmission if 
  74:src/twi_manager.c ****     //   stop bit received
  75:src/twi_manager.c ****     //   TODO handle condition when stopped bit missed
  76:src/twi_manager.c ****     } else if (TWI_STOP_RCVD) {
 190               		.loc 1 76 0
 191 0074 8091 B900 		lds r24,185
 192 0078 803A      		cpi r24,lo8(-96)
 193 007a 01F4      		brne .L10
  77:src/twi_manager.c **** 
  78:src/twi_manager.c ****         // execute callback when data received
  79:src/twi_manager.c ****         if (dataReceivedCB) dataReceivedCB();
 194               		.loc 1 79 0
 195 007c E091 0000 		lds r30,dataReceivedCB
 196 0080 F091 0000 		lds r31,dataReceivedCB+1
 197               	.L22:
 198 0084 3097      		sbiw r30,0
 199 0086 01F0      		breq .L9
 200               		.loc 1 79 0 is_stmt 0 discriminator 1
 201 0088 0995      		icall
 202               	.LVL4:
 203 008a 00C0      		rjmp .L9
 204               	.L10:
  80:src/twi_manager.c ****         
  81:src/twi_manager.c ****     // every message with begin here
  82:src/twi_manager.c ****     // reset pointer
  83:src/twi_manager.c ****     } else if (TWI_SLAW_RCVD) {
 205               		.loc 1 83 0 is_stmt 1
 206 008c 8091 B900 		lds r24,185
 207 0090 8036      		cpi r24,lo8(96)
 208 0092 01F4      		brne .L12
  84:src/twi_manager.c **** 
  85:src/twi_manager.c ****         TWI_Ptr = 0;
 209               		.loc 1 85 0
 210 0094 1092 0000 		sts TWI_Ptr+1,__zero_reg__
 211 0098 1092 0000 		sts TWI_Ptr,__zero_reg__
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s 			page 6


  86:src/twi_manager.c ****         TWI_isBufferAvailable = 1;
 212               		.loc 1 86 0
 213 009c 81E0      		ldi r24,lo8(1)
 214 009e 8093 0000 		sts TWI_isBufferAvailable,r24
 215 00a2 00C0      		rjmp .L9
 216               	.L12:
  87:src/twi_manager.c **** 
  88:src/twi_manager.c ****     // if this unit was addressed and we're receiving
  89:src/twi_manager.c ****     //   data, continue capturing into buffer
  90:src/twi_manager.c ****     } else if (TWI_SLAW_DATA_RCVD) {
 217               		.loc 1 90 0
 218 00a4 8091 B900 		lds r24,185
 219 00a8 8038      		cpi r24,lo8(-128)
 220 00aa 01F4      		brne .L9
  91:src/twi_manager.c **** 
  92:src/twi_manager.c ****         // record received data 
  93:src/twi_manager.c ****         // until buffer is full
  94:src/twi_manager.c ****         if (TWI_Ptr == TWI_MAX_BUFFER_SIZE) 
 221               		.loc 1 94 0
 222 00ac 8091 0000 		lds r24,TWI_Ptr
 223 00b0 9091 0000 		lds r25,TWI_Ptr+1
 224 00b4 8436      		cpi r24,100
 225 00b6 9105      		cpc r25,__zero_reg__
 226 00b8 01F4      		brne .L13
  95:src/twi_manager.c ****             TWI_isBufferAvailable = 0;
 227               		.loc 1 95 0
 228 00ba 1092 0000 		sts TWI_isBufferAvailable,__zero_reg__
 229               	.L13:
  96:src/twi_manager.c **** 
  97:src/twi_manager.c ****         if (TWI_isBufferAvailable)
 230               		.loc 1 97 0
 231 00be 2091 0000 		lds r18,TWI_isBufferAvailable
 232 00c2 2223      		tst r18
 233 00c4 01F0      		breq .L9
  98:src/twi_manager.c ****             TWI_Buffer[TWI_Ptr++] = TWDR;
 234               		.loc 1 98 0
 235 00c6 9C01      		movw r18,r24
 236 00c8 2F5F      		subi r18,-1
 237 00ca 3F4F      		sbci r19,-1
 238 00cc 3093 0000 		sts TWI_Ptr+1,r19
 239 00d0 2093 0000 		sts TWI_Ptr,r18
 240 00d4 2091 BB00 		lds r18,187
 241 00d8 FC01      		movw r30,r24
 242 00da E050      		subi r30,lo8(-(TWI_Buffer))
 243 00dc F040      		sbci r31,hi8(-(TWI_Buffer))
 244 00de 2083      		st Z,r18
 245               	.L9:
  99:src/twi_manager.c **** 
 100:src/twi_manager.c ****     }
 101:src/twi_manager.c **** 
 102:src/twi_manager.c ****     // always release clock line
 103:src/twi_manager.c ****     TWCR |= TWCR_TWINT;
 246               		.loc 1 103 0
 247 00e0 8091 BC00 		lds r24,188
 248 00e4 8068      		ori r24,lo8(-128)
 249 00e6 8093 BC00 		sts 188,r24
 250               	/* epilogue start */
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s 			page 7


 104:src/twi_manager.c **** 
 105:src/twi_manager.c **** }...
 251               		.loc 1 105 0
 252 00ea FF91      		pop r31
 253 00ec EF91      		pop r30
 254 00ee BF91      		pop r27
 255 00f0 AF91      		pop r26
 256 00f2 9F91      		pop r25
 257 00f4 8F91      		pop r24
 258 00f6 7F91      		pop r23
 259 00f8 6F91      		pop r22
 260 00fa 5F91      		pop r21
 261 00fc 4F91      		pop r20
 262 00fe 3F91      		pop r19
 263 0100 2F91      		pop r18
 264 0102 0F90      		pop r0
 265 0104 0FBE      		out __SREG__,r0
 266 0106 0F90      		pop r0
 267 0108 1F90      		pop r1
 268 010a 1895      		reti
 269               		.cfi_endproc
 270               	.LFE7:
 272               		.comm	dataReceivedCB,2,1
 273               		.comm	generalCallCB,2,1
 274               		.comm	TWI_isBufferAvailable,1,1
 275               		.comm	TWI_isSelected,1,1
 276               		.comm	TWI_isSubAddrByte,1,1
 277               		.comm	TWI_isCombinedFormat,1,1
 278               		.comm	TWI_Buffer,100,1
 279               		.comm	TWI_Ptr,2,1
 280               	.Letext0:
 281               		.file 2 "include/utilities.h"
 282               		.file 3 "include/twi_manager.h"
 283               		.file 4 "/usr/local/CrossPack-AVR-20131216/avr/include/stdint.h"
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s 			page 8


DEFINED SYMBOLS
                            *ABS*:00000000 twi_manager.c
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s:2      *ABS*:0000003e __SP_H__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s:3      *ABS*:0000003d __SP_L__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s:4      *ABS*:0000003f __SREG__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s:5      *ABS*:00000000 __tmp_reg__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s:6      *ABS*:00000001 __zero_reg__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s:12     .text:00000000 TWI_init
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s:44     .text:0000001c TWI_onGeneralCall
                            *COM*:00000002 generalCallCB
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s:62     .text:00000026 TWI_onDataReceived
                            *COM*:00000002 dataReceivedCB
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s:80     .text:00000030 TWI_getBuffer
                            *COM*:00000064 TWI_Buffer
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s:97     .text:00000036 TWI_getBufferSize
                            *COM*:00000002 TWI_Ptr
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccujuiEE.s:114    .text:00000040 __vector_19
                            *COM*:00000001 TWI_isBufferAvailable
                            *COM*:00000001 TWI_isSelected
                            *COM*:00000001 TWI_isSubAddrByte
                            *COM*:00000001 TWI_isCombinedFormat

UNDEFINED SYMBOLS
__do_clear_bss
