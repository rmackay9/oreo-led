GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s 			page 1


   1               		.file	"waveform_generator.c"
   2               	__SP_H__ = 0x3e
   3               	__SP_L__ = 0x3d
   4               	__SREG__ = 0x3f
   5               	__tmp_reg__ = 0
   6               	__zero_reg__ = 1
   7               		.text
   8               	.Ltext0:
   9               		.cfi_sections	.debug_frame
  10               	.global	WG_onOverflow
  12               	WG_onOverflow:
  13               	.LFB3:
  14               		.file 1 "src/waveform_generator.c"
   1:src/waveform_generator.c **** /**********************************************************************
   2:src/waveform_generator.c **** 
   3:src/waveform_generator.c ****   waveform_generator.c - implementation, see header for description
   4:src/waveform_generator.c **** 
   5:src/waveform_generator.c **** 
   6:src/waveform_generator.c ****   Authors: 
   7:src/waveform_generator.c ****     Nate Fisher
   8:src/waveform_generator.c **** 
   9:src/waveform_generator.c ****   Created: 
  10:src/waveform_generator.c ****     Wed Oct 1, 2014
  11:src/waveform_generator.c **** 
  12:src/waveform_generator.c **** **********************************************************************/
  13:src/waveform_generator.c **** 
  14:src/waveform_generator.c **** #include <avr/io.h>
  15:src/waveform_generator.c **** #include <avr/interrupt.h>
  16:src/waveform_generator.c **** #include <avr/sleep.h>
  17:src/waveform_generator.c **** #include <avr/cpufunc.h>
  18:src/waveform_generator.c **** #include "math.h"
  19:src/waveform_generator.c **** #include "waveform_generator.h"
  20:src/waveform_generator.c **** 
  21:src/waveform_generator.c **** // setup wavegen hardware; assign inputs and outputs
  22:src/waveform_generator.c **** //  - register the pattern generator calculated values
  23:src/waveform_generator.c **** //    with (up to three) hardware waveform outputs
  24:src/waveform_generator.c **** void WG_init(uint8_t** channelValueRefs, int channelCount) {
  25:src/waveform_generator.c **** 
  26:src/waveform_generator.c ****     // setup cpu hardware for PWM and timer operation
  27:src/waveform_generator.c ****     _WG_configureHardware();
  28:src/waveform_generator.c **** 
  29:src/waveform_generator.c ****     // assign outputs for hardware PWM channels 1 & 2
  30:src/waveform_generator.c ****     //  note that channel 3 requires manipulation of a non-PWM
  31:src/waveform_generator.c ****     //  generating hardware timer (Timer0)
  32:src/waveform_generator.c ****     _self_waveform_gen.channel_1_output = &OCR1BL;
  33:src/waveform_generator.c ****     _self_waveform_gen.channel_2_output = &OCR1AL;
  34:src/waveform_generator.c **** 
  35:src/waveform_generator.c ****     // register the wavegen target references
  36:src/waveform_generator.c ****     //  with inputs, expressed as percentages
  37:src/waveform_generator.c ****     while(channelCount--) {
  38:src/waveform_generator.c ****         _self_waveform_gen.channel_target[channelCount] = channelValueRefs[channelCount];
  39:src/waveform_generator.c ****     }
  40:src/waveform_generator.c **** 
  41:src/waveform_generator.c **** }
  42:src/waveform_generator.c **** 
  43:src/waveform_generator.c **** // attach clock input to the synchroniced timing
  44:src/waveform_generator.c **** //  module, to ultimately drive the pattern generator
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s 			page 2


  45:src/waveform_generator.c **** //  updates in a coordinated way
  46:src/waveform_generator.c **** void WG_onOverflow(void (*cb)()) {
  15               		.loc 1 46 0
  16               		.cfi_startproc
  17               	.LVL0:
  18               	/* prologue: function */
  19               	/* frame size = 0 */
  20               	/* stack size = 0 */
  21               	.L__stack_usage = 0
  47:src/waveform_generator.c **** 
  48:src/waveform_generator.c ****     _self_waveform_gen.overflowCallback = cb;
  22               		.loc 1 48 0
  23 0000 9093 0000 		sts _self_waveform_gen+12+1,r25
  24 0004 8093 0000 		sts _self_waveform_gen+12,r24
  25 0008 0895      		ret
  26               		.cfi_endproc
  27               	.LFE3:
  29               	.global	_WG_configureHardware
  31               	_WG_configureHardware:
  32               	.LFB4:
  49:src/waveform_generator.c **** 
  50:src/waveform_generator.c **** };
  51:src/waveform_generator.c **** 
  52:src/waveform_generator.c **** // setup cpu hardware for PWM and timer operation
  53:src/waveform_generator.c **** void _WG_configureHardware(void) {
  33               		.loc 1 53 0
  34               		.cfi_startproc
  35               	/* prologue: function */
  36               	/* frame size = 0 */
  37               	/* stack size = 0 */
  38               	.L__stack_usage = 0
  54:src/waveform_generator.c **** 
  55:src/waveform_generator.c ****     // configure PWM port B pins as output
  56:src/waveform_generator.c ****     // and set level to LOW
  57:src/waveform_generator.c ****     DDRB    |= 0b00000111; // 0 == input | 1 == output
  39               		.loc 1 57 0
  40 000a 84B1      		in r24,0x4
  41 000c 8760      		ori r24,lo8(7)
  42 000e 84B9      		out 0x4,r24
  58:src/waveform_generator.c ****     PORTB    = 0;
  43               		.loc 1 58 0
  44 0010 15B8      		out 0x5,__zero_reg__
  59:src/waveform_generator.c **** 
  60:src/waveform_generator.c ****     // TIMER1 Config
  61:src/waveform_generator.c ****     // pwm mode and waveform generation mode
  62:src/waveform_generator.c ****     // timer clock speed
  63:src/waveform_generator.c ****     TCCR1A = ZERO | TCCR1A_PWM_MODE | TCCR1A_FAST_PWM8;
  45               		.loc 1 63 0
  46 0012 81EA      		ldi r24,lo8(-95)
  47 0014 8093 8000 		sts 128,r24
  64:src/waveform_generator.c ****     TCCR1B = ZERO | TCCR1B_FAST_PWM8 | TCCR1B_CLOCK_DIV8;
  48               		.loc 1 64 0
  49 0018 8AE0      		ldi r24,lo8(10)
  50 001a 8093 8100 		sts 129,r24
  65:src/waveform_generator.c **** 
  66:src/waveform_generator.c ****     // TIMER1 Interrupts
  67:src/waveform_generator.c ****     // overflow interrupt 
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s 			page 3


  68:src/waveform_generator.c ****     TIMSK1 = ZERO | TIMSK1_TOIE1;
  51               		.loc 1 68 0
  52 001e 81E0      		ldi r24,lo8(1)
  53 0020 8093 6F00 		sts 111,r24
  69:src/waveform_generator.c **** 
  70:src/waveform_generator.c ****     // TIMER0 Config
  71:src/waveform_generator.c ****     // Output compare mode
  72:src/waveform_generator.c ****     // Set timer clock speed
  73:src/waveform_generator.c ****     TCCR0A = ZERO | TCCR0A_CLOCK_DIV64;
  54               		.loc 1 73 0
  55 0024 83E0      		ldi r24,lo8(3)
  56 0026 85BD      		out 0x25,r24
  74:src/waveform_generator.c **** 
  75:src/waveform_generator.c ****     // TIMER0 Interrupts
  76:src/waveform_generator.c ****     // output compare match interrupt
  77:src/waveform_generator.c ****     TIMSK0 = ZERO | TIMSK0_TOIE0 | TIMSK0_OCIE0B;
  57               		.loc 1 77 0
  58 0028 85E0      		ldi r24,lo8(5)
  59 002a 8093 6E00 		sts 110,r24
  60 002e 0895      		ret
  61               		.cfi_endproc
  62               	.LFE4:
  64               	.global	WG_init
  66               	WG_init:
  67               	.LFB2:
  24:src/waveform_generator.c **** void WG_init(uint8_t** channelValueRefs, int channelCount) {
  68               		.loc 1 24 0
  69               		.cfi_startproc
  70               	.LVL1:
  71 0030 0F93      		push r16
  72               	.LCFI0:
  73               		.cfi_def_cfa_offset 3
  74               		.cfi_offset 16, -2
  75 0032 1F93      		push r17
  76               	.LCFI1:
  77               		.cfi_def_cfa_offset 4
  78               		.cfi_offset 17, -3
  79 0034 CF93      		push r28
  80               	.LCFI2:
  81               		.cfi_def_cfa_offset 5
  82               		.cfi_offset 28, -4
  83 0036 DF93      		push r29
  84               	.LCFI3:
  85               		.cfi_def_cfa_offset 6
  86               		.cfi_offset 29, -5
  87               	/* prologue: function */
  88               	/* frame size = 0 */
  89               	/* stack size = 4 */
  90               	.L__stack_usage = 4
  91 0038 8C01      		movw r16,r24
  92 003a EB01      		movw r28,r22
  27:src/waveform_generator.c ****     _WG_configureHardware();
  93               		.loc 1 27 0
  94 003c 00D0      		rcall _WG_configureHardware
  95               	.LVL2:
  32:src/waveform_generator.c ****     _self_waveform_gen.channel_1_output = &OCR1BL;
  96               		.loc 1 32 0
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s 			page 4


  97 003e 8AE8      		ldi r24,lo8(-118)
  98 0040 90E0      		ldi r25,0
  99 0042 9093 0000 		sts _self_waveform_gen+1,r25
 100 0046 8093 0000 		sts _self_waveform_gen,r24
  33:src/waveform_generator.c ****     _self_waveform_gen.channel_2_output = &OCR1AL;
 101               		.loc 1 33 0
 102 004a 88E8      		ldi r24,lo8(-120)
 103 004c 90E0      		ldi r25,0
 104 004e 9093 0000 		sts _self_waveform_gen+2+1,r25
 105 0052 8093 0000 		sts _self_waveform_gen+2,r24
 106 0056 9E01      		movw r18,r28
 107 0058 220F      		lsl r18
 108 005a 331F      		rol r19
 109 005c 020F      		add r16,r18
 110 005e 131F      		adc r17,r19
 111               	.LVL3:
 112 0060 C901      		movw r24,r18
 113 0062 8050      		subi r24,lo8(-(_self_waveform_gen))
 114 0064 9040      		sbci r25,hi8(-(_self_waveform_gen))
  37:src/waveform_generator.c ****     while(channelCount--) {
 115               		.loc 1 37 0
 116 0066 20E0      		ldi r18,0
 117 0068 30E0      		ldi r19,0
 118               	.L4:
  37:src/waveform_generator.c ****     while(channelCount--) {
 119               		.loc 1 37 0 is_stmt 0 discriminator 1
 120 006a 2197      		sbiw r28,1
 121               	.LVL4:
 122 006c 2250      		subi r18,2
 123 006e 3109      		sbc r19,__zero_reg__
 124 0070 CF3F      		cpi r28,-1
 125 0072 4FEF      		ldi r20,-1
 126 0074 D407      		cpc r29,r20
 127 0076 01F0      		breq .L7
 128 0078 F801      		movw r30,r16
 129 007a E20F      		add r30,r18
 130 007c F31F      		adc r31,r19
  38:src/waveform_generator.c ****         _self_waveform_gen.channel_target[channelCount] = channelValueRefs[channelCount];
 131               		.loc 1 38 0 is_stmt 1
 132 007e 4081      		ld r20,Z
 133 0080 5181      		ldd r21,Z+1
 134 0082 FC01      		movw r30,r24
 135 0084 E20F      		add r30,r18
 136 0086 F31F      		adc r31,r19
 137 0088 5783      		std Z+7,r21
 138 008a 4683      		std Z+6,r20
 139 008c 00C0      		rjmp .L4
 140               	.L7:
 141               	/* epilogue start */
  41:src/waveform_generator.c **** }
 142               		.loc 1 41 0
 143 008e DF91      		pop r29
 144 0090 CF91      		pop r28
 145               	.LVL5:
 146 0092 1F91      		pop r17
 147 0094 0F91      		pop r16
 148 0096 0895      		ret
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s 			page 5


 149               		.cfi_endproc
 150               	.LFE2:
 152               	.global	__floatunsisf
 153               	.global	__mulsf3
 154               	.global	__fixsfsi
 155               	.global	__addsf3
 156               	.global	WG_updatePWM
 158               	WG_updatePWM:
 159               	.LFB5:
  78:src/waveform_generator.c **** 
  79:src/waveform_generator.c **** }
  80:src/waveform_generator.c **** 
  81:src/waveform_generator.c **** 
  82:src/waveform_generator.c **** // update PWM duty cycle values per the channel target
  83:src/waveform_generator.c **** //  values, which are stored as percentages
  84:src/waveform_generator.c **** void WG_updatePWM(void) {
 160               		.loc 1 84 0
 161               		.cfi_startproc
 162 0098 EF92      		push r14
 163               	.LCFI4:
 164               		.cfi_def_cfa_offset 3
 165               		.cfi_offset 14, -2
 166 009a FF92      		push r15
 167               	.LCFI5:
 168               		.cfi_def_cfa_offset 4
 169               		.cfi_offset 15, -3
 170 009c 0F93      		push r16
 171               	.LCFI6:
 172               		.cfi_def_cfa_offset 5
 173               		.cfi_offset 16, -4
 174 009e 1F93      		push r17
 175               	.LCFI7:
 176               		.cfi_def_cfa_offset 6
 177               		.cfi_offset 17, -5
 178 00a0 CF93      		push r28
 179               	.LCFI8:
 180               		.cfi_def_cfa_offset 7
 181               		.cfi_offset 28, -6
 182 00a2 DF93      		push r29
 183               	.LCFI9:
 184               		.cfi_def_cfa_offset 8
 185               		.cfi_offset 29, -7
 186               	/* prologue: function */
 187               	/* frame size = 0 */
 188               	/* stack size = 6 */
 189               	.L__stack_usage = 6
  85:src/waveform_generator.c **** 
  86:src/waveform_generator.c ****     // rescale channel percentage values to 0->240
  87:src/waveform_generator.c ****     int channel_1_pwm_value = (fmod(*(_self_waveform_gen.channel_target[0]), 256.0)/256.0) * PWM_MA
 190               		.loc 1 87 0
 191 00a4 E091 0000 		lds r30,_self_waveform_gen+6
 192 00a8 F091 0000 		lds r31,_self_waveform_gen+6+1
 193 00ac 6081      		ld r22,Z
 194 00ae 70E0      		ldi r23,0
 195 00b0 80E0      		ldi r24,0
 196 00b2 90E0      		ldi r25,0
 197 00b4 00D0      		rcall __floatunsisf
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s 			page 6


 198               	.LVL6:
 199 00b6 20E0      		ldi r18,0
 200 00b8 30E0      		ldi r19,0
 201 00ba 40E8      		ldi r20,lo8(-128)
 202 00bc 53E4      		ldi r21,lo8(67)
 203 00be 00D0      		rcall fmod
 204               	.LVL7:
 205 00c0 20E0      		ldi r18,0
 206 00c2 30E0      		ldi r19,0
 207 00c4 40E8      		ldi r20,lo8(-128)
 208 00c6 5BE3      		ldi r21,lo8(59)
 209 00c8 00D0      		rcall __mulsf3
 210               	.LVL8:
 211 00ca 20E0      		ldi r18,0
 212 00cc 30E0      		ldi r19,0
 213 00ce 48EC      		ldi r20,lo8(-56)
 214 00d0 52E4      		ldi r21,lo8(66)
 215 00d2 00D0      		rcall __mulsf3
 216               	.LVL9:
 217 00d4 00D0      		rcall __fixsfsi
 218               	.LVL10:
 219 00d6 E62E      		mov r14,r22
 220 00d8 062F      		mov r16,r22
 221 00da 172F      		mov r17,r23
 222               	.LVL11:
  88:src/waveform_generator.c ****     int channel_2_pwm_value = (fmod(*(_self_waveform_gen.channel_target[1]), 256.0)/256.0) * PWM_MA
 223               		.loc 1 88 0
 224 00dc E091 0000 		lds r30,_self_waveform_gen+8
 225 00e0 F091 0000 		lds r31,_self_waveform_gen+8+1
 226 00e4 6081      		ld r22,Z
 227 00e6 70E0      		ldi r23,0
 228 00e8 80E0      		ldi r24,0
 229 00ea 90E0      		ldi r25,0
 230               	.LVL12:
 231 00ec 00D0      		rcall __floatunsisf
 232               	.LVL13:
 233 00ee 20E0      		ldi r18,0
 234 00f0 30E0      		ldi r19,0
 235 00f2 40E8      		ldi r20,lo8(-128)
 236 00f4 53E4      		ldi r21,lo8(67)
 237 00f6 00D0      		rcall fmod
 238               	.LVL14:
 239 00f8 20E0      		ldi r18,0
 240 00fa 30E0      		ldi r19,0
 241 00fc 40E8      		ldi r20,lo8(-128)
 242 00fe 5BE3      		ldi r21,lo8(59)
 243 0100 00D0      		rcall __mulsf3
 244               	.LVL15:
 245 0102 20E0      		ldi r18,0
 246 0104 30E0      		ldi r19,0
 247 0106 48EC      		ldi r20,lo8(-56)
 248 0108 52E4      		ldi r21,lo8(66)
 249 010a 00D0      		rcall __mulsf3
 250               	.LVL16:
 251 010c 00D0      		rcall __fixsfsi
 252               	.LVL17:
 253 010e F62E      		mov r15,r22
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s 			page 7


 254 0110 C62F      		mov r28,r22
 255 0112 D72F      		mov r29,r23
 256               	.LVL18:
  89:src/waveform_generator.c ****     int channel_3_pwm_value = (fmod(*(_self_waveform_gen.channel_target[2]), 256.0)/256.0) * (PWM_M
 257               		.loc 1 89 0
 258 0114 E091 0000 		lds r30,_self_waveform_gen+10
 259 0118 F091 0000 		lds r31,_self_waveform_gen+10+1
 260 011c 6081      		ld r22,Z
 261 011e 70E0      		ldi r23,0
 262               	.LVL19:
 263 0120 80E0      		ldi r24,0
 264 0122 90E0      		ldi r25,0
 265               	.LVL20:
 266 0124 00D0      		rcall __floatunsisf
 267               	.LVL21:
 268 0126 20E0      		ldi r18,0
 269 0128 30E0      		ldi r19,0
 270 012a 40E8      		ldi r20,lo8(-128)
 271 012c 53E4      		ldi r21,lo8(67)
 272 012e 00D0      		rcall fmod
 273               	.LVL22:
 274 0130 20E0      		ldi r18,0
 275 0132 30E0      		ldi r19,0
 276 0134 40E8      		ldi r20,lo8(-128)
 277 0136 5BE3      		ldi r21,lo8(59)
 278 0138 00D0      		rcall __mulsf3
 279               	.LVL23:
 280 013a 20E0      		ldi r18,0
 281 013c 30E0      		ldi r19,0
 282 013e 44EB      		ldi r20,lo8(-76)
 283 0140 52E4      		ldi r21,lo8(66)
 284 0142 00D0      		rcall __mulsf3
 285               	.LVL24:
 286 0144 20E0      		ldi r18,0
 287 0146 30E0      		ldi r19,0
 288 0148 40E2      		ldi r20,lo8(32)
 289 014a 51E4      		ldi r21,lo8(65)
 290 014c 00D0      		rcall __addsf3
 291               	.LVL25:
 292 014e 00D0      		rcall __fixsfsi
 293               	.LVL26:
 294 0150 962F      		mov r25,r22
 295               	.LVL27:
  90:src/waveform_generator.c **** 
  91:src/waveform_generator.c ****     // assign chan1& chan2 values directly to PWM timers
  92:src/waveform_generator.c ****     *(_self_waveform_gen.channel_1_output) = channel_1_pwm_value;
 296               		.loc 1 92 0
 297 0152 E091 0000 		lds r30,_self_waveform_gen
 298 0156 F091 0000 		lds r31,_self_waveform_gen+1
 299 015a E082      		st Z,r14
  93:src/waveform_generator.c ****     *(_self_waveform_gen.channel_2_output) = channel_2_pwm_value;
 300               		.loc 1 93 0
 301 015c E091 0000 		lds r30,_self_waveform_gen+2
 302 0160 F091 0000 		lds r31,_self_waveform_gen+2+1
 303 0164 F082      		st Z,r15
  94:src/waveform_generator.c **** 
  95:src/waveform_generator.c ****     // set pins to input mode, if value is actually zero
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s 			page 8


  96:src/waveform_generator.c ****     if (channel_1_pwm_value == 0) DDRB &= 0b11111011;   //PB2 reset to input
 304               		.loc 1 96 0
 305 0166 012B      		or r16,r17
 306 0168 01F4      		brne .L9
 307               		.loc 1 96 0 is_stmt 0 discriminator 1
 308 016a 2298      		cbi 0x4,2
 309 016c 00C0      		rjmp .L10
 310               	.L9:
  97:src/waveform_generator.c ****     else DDRB |= 0b00000100;                            //PB2 set to output
 311               		.loc 1 97 0 is_stmt 1
 312 016e 229A      		sbi 0x4,2
 313               	.L10:
  98:src/waveform_generator.c **** 
  99:src/waveform_generator.c ****     // set pins to input mode, if value is actually zero
 100:src/waveform_generator.c ****     if (channel_2_pwm_value == 0) DDRB &= 0b11111101;   //PB1 reset to input
 314               		.loc 1 100 0
 315 0170 CD2B      		or r28,r29
 316 0172 01F4      		brne .L11
 317               		.loc 1 100 0 is_stmt 0 discriminator 1
 318 0174 2198      		cbi 0x4,1
 319 0176 00C0      		rjmp .L12
 320               	.L11:
 101:src/waveform_generator.c ****     else DDRB |= 0b00000010;                            //PB1 set to output
 321               		.loc 1 101 0 is_stmt 1
 322 0178 219A      		sbi 0x4,1
 323               	.L12:
 102:src/waveform_generator.c **** 
 103:src/waveform_generator.c **** 
 104:src/waveform_generator.c **** 
 105:src/waveform_generator.c ****     // assign channel 3 value to a proxy
 106:src/waveform_generator.c ****     _self_waveform_gen.channel_3_output = channel_3_pwm_value;
 324               		.loc 1 106 0
 325 017a 6093 0000 		sts _self_waveform_gen+4,r22
 107:src/waveform_generator.c ****     
 108:src/waveform_generator.c ****     // implement a lower threshold for channel3 to enable full off
 109:src/waveform_generator.c ****     _self_waveform_gen.channel_3_enable = (_self_waveform_gen.channel_3_output > 10) ? 1 : 0;
 326               		.loc 1 109 0
 327 017e 81E0      		ldi r24,lo8(1)
 328 0180 9B30      		cpi r25,lo8(11)
 329 0182 00F4      		brsh .L13
 330 0184 80E0      		ldi r24,0
 331               	.L13:
 332 0186 8093 0000 		sts _self_waveform_gen+5,r24
 333               	/* epilogue start */
 110:src/waveform_generator.c **** 
 111:src/waveform_generator.c **** 
 112:src/waveform_generator.c **** }
 334               		.loc 1 112 0
 335 018a DF91      		pop r29
 336 018c CF91      		pop r28
 337 018e 1F91      		pop r17
 338 0190 0F91      		pop r16
 339 0192 FF90      		pop r15
 340 0194 EF90      		pop r14
 341 0196 0895      		ret
 342               		.cfi_endproc
 343               	.LFE5:
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s 			page 9


 345               	.global	__vector_11
 347               	__vector_11:
 348               	.LFB6:
 113:src/waveform_generator.c **** 
 114:src/waveform_generator.c **** // execute a callback on timer1 overflow
 115:src/waveform_generator.c **** ISR(TIMER1_OVF_vect) {
 349               		.loc 1 115 0
 350               		.cfi_startproc
 351 0198 1F92      		push r1
 352               	.LCFI10:
 353               		.cfi_def_cfa_offset 3
 354               		.cfi_offset 1, -2
 355 019a 0F92      		push r0
 356               	.LCFI11:
 357               		.cfi_def_cfa_offset 4
 358               		.cfi_offset 0, -3
 359 019c 0FB6      		in r0,__SREG__
 360 019e 0F92      		push r0
 361 01a0 1124      		clr __zero_reg__
 362 01a2 2F93      		push r18
 363               	.LCFI12:
 364               		.cfi_def_cfa_offset 5
 365               		.cfi_offset 18, -4
 366 01a4 3F93      		push r19
 367               	.LCFI13:
 368               		.cfi_def_cfa_offset 6
 369               		.cfi_offset 19, -5
 370 01a6 4F93      		push r20
 371               	.LCFI14:
 372               		.cfi_def_cfa_offset 7
 373               		.cfi_offset 20, -6
 374 01a8 5F93      		push r21
 375               	.LCFI15:
 376               		.cfi_def_cfa_offset 8
 377               		.cfi_offset 21, -7
 378 01aa 6F93      		push r22
 379               	.LCFI16:
 380               		.cfi_def_cfa_offset 9
 381               		.cfi_offset 22, -8
 382 01ac 7F93      		push r23
 383               	.LCFI17:
 384               		.cfi_def_cfa_offset 10
 385               		.cfi_offset 23, -9
 386 01ae 8F93      		push r24
 387               	.LCFI18:
 388               		.cfi_def_cfa_offset 11
 389               		.cfi_offset 24, -10
 390 01b0 9F93      		push r25
 391               	.LCFI19:
 392               		.cfi_def_cfa_offset 12
 393               		.cfi_offset 25, -11
 394 01b2 AF93      		push r26
 395               	.LCFI20:
 396               		.cfi_def_cfa_offset 13
 397               		.cfi_offset 26, -12
 398 01b4 BF93      		push r27
 399               	.LCFI21:
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s 			page 10


 400               		.cfi_def_cfa_offset 14
 401               		.cfi_offset 27, -13
 402 01b6 EF93      		push r30
 403               	.LCFI22:
 404               		.cfi_def_cfa_offset 15
 405               		.cfi_offset 30, -14
 406 01b8 FF93      		push r31
 407               	.LCFI23:
 408               		.cfi_def_cfa_offset 16
 409               		.cfi_offset 31, -15
 410               	/* prologue: Signal */
 411               	/* frame size = 0 */
 412               	/* stack size = 15 */
 413               	.L__stack_usage = 15
 116:src/waveform_generator.c **** 
 117:src/waveform_generator.c ****     // mark time in light manager
 118:src/waveform_generator.c ****     if (_self_waveform_gen.overflowCallback)
 414               		.loc 1 118 0
 415 01ba E091 0000 		lds r30,_self_waveform_gen+12
 416 01be F091 0000 		lds r31,_self_waveform_gen+12+1
 417 01c2 3097      		sbiw r30,0
 418 01c4 01F0      		breq .L14
 119:src/waveform_generator.c ****         _self_waveform_gen.overflowCallback();
 419               		.loc 1 119 0
 420 01c6 0995      		icall
 421               	.LVL28:
 422               	.L14:
 423               	/* epilogue start */
 120:src/waveform_generator.c ****  
 121:src/waveform_generator.c **** }
 424               		.loc 1 121 0
 425 01c8 FF91      		pop r31
 426 01ca EF91      		pop r30
 427 01cc BF91      		pop r27
 428 01ce AF91      		pop r26
 429 01d0 9F91      		pop r25
 430 01d2 8F91      		pop r24
 431 01d4 7F91      		pop r23
 432 01d6 6F91      		pop r22
 433 01d8 5F91      		pop r21
 434 01da 4F91      		pop r20
 435 01dc 3F91      		pop r19
 436 01de 2F91      		pop r18
 437 01e0 0F90      		pop r0
 438 01e2 0FBE      		out __SREG__,r0
 439 01e4 0F90      		pop r0
 440 01e6 1F90      		pop r1
 441 01e8 1895      		reti
 442               		.cfi_endproc
 443               	.LFE6:
 445               	.global	__vector_14
 447               	__vector_14:
 448               	.LFB7:
 122:src/waveform_generator.c **** 
 123:src/waveform_generator.c **** ISR(TIMER0_OVF_vect) {
 449               		.loc 1 123 0
 450               		.cfi_startproc
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s 			page 11


 451 01ea 1F92      		push r1
 452               	.LCFI24:
 453               		.cfi_def_cfa_offset 3
 454               		.cfi_offset 1, -2
 455 01ec 0F92      		push r0
 456               	.LCFI25:
 457               		.cfi_def_cfa_offset 4
 458               		.cfi_offset 0, -3
 459 01ee 0FB6      		in r0,__SREG__
 460 01f0 0F92      		push r0
 461 01f2 1124      		clr __zero_reg__
 462 01f4 8F93      		push r24
 463               	.LCFI26:
 464               		.cfi_def_cfa_offset 5
 465               		.cfi_offset 24, -4
 466               	/* prologue: Signal */
 467               	/* frame size = 0 */
 468               	/* stack size = 4 */
 469               	.L__stack_usage = 4
 124:src/waveform_generator.c **** 
 125:src/waveform_generator.c ****     // set compare register value
 126:src/waveform_generator.c ****     OCR0B = _self_waveform_gen.channel_3_output;
 470               		.loc 1 126 0
 471 01f6 8091 0000 		lds r24,_self_waveform_gen+4
 472 01fa 88BD      		out 0x28,r24
 127:src/waveform_generator.c **** 
 128:src/waveform_generator.c ****     // if channel 3 value is below threshold,
 129:src/waveform_generator.c ****     // do not turn on the output pin at all
 130:src/waveform_generator.c ****     if (_self_waveform_gen.channel_3_enable) {
 473               		.loc 1 130 0
 474 01fc 8091 0000 		lds r24,_self_waveform_gen+5
 475 0200 8823      		tst r24
 476 0202 01F0      		breq .L20
 131:src/waveform_generator.c ****         // set channel 3 output pin at start of PWM cycle
 132:src/waveform_generator.c ****         PORTB |= 0b00000001; 
 477               		.loc 1 132 0
 478 0204 289A      		sbi 0x5,0
 479 0206 00C0      		rjmp .L19
 480               	.L20:
 133:src/waveform_generator.c ****     } else { 
 134:src/waveform_generator.c ****         // keep output off if below threshold
 135:src/waveform_generator.c ****         PORTB &= 0b11111110;
 481               		.loc 1 135 0
 482 0208 2898      		cbi 0x5,0
 483               	.L19:
 484               	/* epilogue start */
 136:src/waveform_generator.c ****     }
 137:src/waveform_generator.c **** 
 138:src/waveform_generator.c **** }
 485               		.loc 1 138 0
 486 020a 8F91      		pop r24
 487 020c 0F90      		pop r0
 488 020e 0FBE      		out __SREG__,r0
 489 0210 0F90      		pop r0
 490 0212 1F90      		pop r1
 491 0214 1895      		reti
 492               		.cfi_endproc
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s 			page 12


 493               	.LFE7:
 495               	.global	__vector_13
 497               	__vector_13:
 498               	.LFB8:
 139:src/waveform_generator.c **** 
 140:src/waveform_generator.c **** // Implement Channel 3 PWM Signal 
 141:src/waveform_generator.c **** ISR(TIMER0_COMPB_vect) {
 499               		.loc 1 141 0
 500               		.cfi_startproc
 501 0216 1F92      		push r1
 502               	.LCFI27:
 503               		.cfi_def_cfa_offset 3
 504               		.cfi_offset 1, -2
 505 0218 0F92      		push r0
 506               	.LCFI28:
 507               		.cfi_def_cfa_offset 4
 508               		.cfi_offset 0, -3
 509 021a 0FB6      		in r0,__SREG__
 510 021c 0F92      		push r0
 511 021e 1124      		clr __zero_reg__
 512               	/* prologue: Signal */
 513               	/* frame size = 0 */
 514               	/* stack size = 3 */
 515               	.L__stack_usage = 3
 142:src/waveform_generator.c **** 
 143:src/waveform_generator.c ****     // reset channel 3 output pin on compare match
 144:src/waveform_generator.c ****     PORTB &= 0b11111110;
 516               		.loc 1 144 0
 517 0220 2898      		cbi 0x5,0
 518               	/* epilogue start */
 145:src/waveform_generator.c **** 
 146:src/waveform_generator.c **** }...
 519               		.loc 1 146 0
 520 0222 0F90      		pop r0
 521 0224 0FBE      		out __SREG__,r0
 522 0226 0F90      		pop r0
 523 0228 1F90      		pop r1
 524 022a 1895      		reti
 525               		.cfi_endproc
 526               	.LFE8:
 528               		.comm	_self_waveform_gen,14,1
 529               	.Letext0:
 530               		.file 2 "include/waveform_generator.h"
 531               		.file 3 "/usr/local/CrossPack-AVR-20131216/avr/include/stdint.h"
 532               		.file 4 "/usr/local/CrossPack-AVR-20131216/avr/include/math.h"
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s 			page 13


DEFINED SYMBOLS
                            *ABS*:00000000 waveform_generator.c
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s:2      *ABS*:0000003e __SP_H__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s:3      *ABS*:0000003d __SP_L__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s:4      *ABS*:0000003f __SREG__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s:5      *ABS*:00000000 __tmp_reg__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s:6      *ABS*:00000001 __zero_reg__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s:12     .text:00000000 WG_onOverflow
                            *COM*:0000000e _self_waveform_gen
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s:31     .text:0000000a _WG_configureHardware
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s:66     .text:00000030 WG_init
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s:158    .text:00000098 WG_updatePWM
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s:347    .text:00000198 __vector_11
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s:447    .text:000001ea __vector_14
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccTK4Ele.s:497    .text:00000216 __vector_13

UNDEFINED SYMBOLS
__floatunsisf
__mulsf3
__fixsfsi
__addsf3
fmod
__do_clear_bss
