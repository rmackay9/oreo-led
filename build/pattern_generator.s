GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 1


   1               		.file	"pattern_generator.c"
   2               	__SP_H__ = 0x3e
   3               	__SP_L__ = 0x3d
   4               	__SREG__ = 0x3f
   5               	__tmp_reg__ = 0
   6               	__zero_reg__ = 1
   7               		.text
   8               	.Ltext0:
   9               		.cfi_sections	.debug_frame
  10               	.global	PG_init
  12               	PG_init:
  13               	.LFB4:
  14               		.file 1 "src/pattern_generator.c"
   1:src/pattern_generator.c **** /**********************************************************************
   2:src/pattern_generator.c **** 
   3:src/pattern_generator.c ****   pattern_generator.c - implementation, see header for description
   4:src/pattern_generator.c **** 
   5:src/pattern_generator.c **** 
   6:src/pattern_generator.c ****   Authors: 
   7:src/pattern_generator.c ****     Nate Fisher
   8:src/pattern_generator.c **** 
   9:src/pattern_generator.c ****   Created: 
  10:src/pattern_generator.c ****     Wed Oct 1, 2014
  11:src/pattern_generator.c **** 
  12:src/pattern_generator.c **** **********************************************************************/
  13:src/pattern_generator.c **** 
  14:src/pattern_generator.c **** #include <avr/io.h>
  15:src/pattern_generator.c **** #include "pattern_generator.h"
  16:src/pattern_generator.c **** #include "utilities.h"
  17:src/pattern_generator.c **** #include "math.h"
  18:src/pattern_generator.c **** 
  19:src/pattern_generator.c **** void PG_init(PatternGenerator* self) {
  15               		.loc 1 19 0
  16               		.cfi_startproc
  17               	.LVL0:
  18               	/* prologue: function */
  19               	/* frame size = 0 */
  20               	/* stack size = 0 */
  21               	.L__stack_usage = 0
  22 0000 FC01      		movw r30,r24
  20:src/pattern_generator.c ****     
  21:src/pattern_generator.c ****     self->cyclesRemaining     = CYCLES_INFINITE; 
  23               		.loc 1 21 0
  24 0002 8EEF      		ldi r24,lo8(-2)
  25               	.LVL1:
  26 0004 8483      		std Z+4,r24
  22:src/pattern_generator.c ****     self->theta               = 0;
  27               		.loc 1 22 0
  28 0006 1082      		st Z,__zero_reg__
  29 0008 1182      		std Z+1,__zero_reg__
  30 000a 1282      		std Z+2,__zero_reg__
  31 000c 1382      		std Z+3,__zero_reg__
  23:src/pattern_generator.c ****     self->isNewCycle          = 0;
  32               		.loc 1 23 0
  33 000e 1682      		std Z+6,__zero_reg__
  34 0010 1582      		std Z+5,__zero_reg__
  24:src/pattern_generator.c ****     self->pattern             = PATTERN_OFF;
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 2


  35               		.loc 1 24 0
  36 0012 1086      		std Z+8,__zero_reg__
  37 0014 1782      		std Z+7,__zero_reg__
  25:src/pattern_generator.c ****     self->speed               = 1;
  38               		.loc 1 25 0
  39 0016 40E0      		ldi r20,0
  40 0018 50E0      		ldi r21,0
  41 001a 60E8      		ldi r22,lo8(-128)
  42 001c 7FE3      		ldi r23,lo8(63)
  43 001e 4187      		std Z+9,r20
  44 0020 5287      		std Z+10,r21
  45 0022 6387      		std Z+11,r22
  46 0024 7487      		std Z+12,r23
  26:src/pattern_generator.c ****     self->phase               = 0;
  47               		.loc 1 26 0
  48 0026 1686      		std Z+14,__zero_reg__
  49 0028 1586      		std Z+13,__zero_reg__
  27:src/pattern_generator.c ****     self->amplitude           = 0;
  50               		.loc 1 27 0
  51 002a 1786      		std Z+15,__zero_reg__
  52 002c 108A      		std Z+16,__zero_reg__
  53 002e 118A      		std Z+17,__zero_reg__
  54 0030 128A      		std Z+18,__zero_reg__
  28:src/pattern_generator.c ****     self->bias                = 0;
  55               		.loc 1 28 0
  56 0032 138A      		std Z+19,__zero_reg__
  57 0034 148A      		std Z+20,__zero_reg__
  58 0036 158A      		std Z+21,__zero_reg__
  59 0038 168A      		std Z+22,__zero_reg__
  29:src/pattern_generator.c ****     self->value               = 0;
  60               		.loc 1 29 0
  61 003a 178A      		std Z+23,__zero_reg__
  62 003c 0895      		ret
  63               		.cfi_endproc
  64               	.LFE4:
  66               	.global	__mulsf3
  67               	.global	__floatunsisf
  68               	.global	__addsf3
  69               	.global	__gtsf2
  70               	.global	_PG_calcTheta
  72               	_PG_calcTheta:
  73               	.LFB6:
  30:src/pattern_generator.c **** 
  31:src/pattern_generator.c **** }
  32:src/pattern_generator.c **** 
  33:src/pattern_generator.c **** void PG_calc(PatternGenerator* self, double clock_position) { 
  34:src/pattern_generator.c **** 
  35:src/pattern_generator.c ****     // update pattern instance theta 
  36:src/pattern_generator.c ****     _PG_calcTheta(self, clock_position);
  37:src/pattern_generator.c **** 
  38:src/pattern_generator.c ****     // decrement the cycles remaining until
  39:src/pattern_generator.c ****     // equals CYCLES_STOP
  40:src/pattern_generator.c ****     if (self->isNewCycle && self->cyclesRemaining >= 0) 
  41:src/pattern_generator.c ****         self->cyclesRemaining--;
  42:src/pattern_generator.c **** 
  43:src/pattern_generator.c ****     // update pattern value
  44:src/pattern_generator.c ****     switch(self->pattern) {
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 3


  45:src/pattern_generator.c **** 
  46:src/pattern_generator.c ****         case PATTERN_SINE: 
  47:src/pattern_generator.c ****             _PG_patternSine(self); 
  48:src/pattern_generator.c ****             break;
  49:src/pattern_generator.c ****         case PATTERN_STROBE: 
  50:src/pattern_generator.c ****             _PG_patternStrobe(self); 
  51:src/pattern_generator.c ****             break;
  52:src/pattern_generator.c ****         case PATTERN_SIREN: 
  53:src/pattern_generator.c ****             _PG_patternSiren(self); 
  54:src/pattern_generator.c ****             break;
  55:src/pattern_generator.c ****         case PATTERN_SOLID: 
  56:src/pattern_generator.c ****             _PG_patternSolid(self); 
  57:src/pattern_generator.c ****             break;
  58:src/pattern_generator.c ****         case PATTERN_FADEOUT: 
  59:src/pattern_generator.c ****             _PG_patternFadeOut(self); 
  60:src/pattern_generator.c ****             break;
  61:src/pattern_generator.c ****         case PATTERN_FADEIN: 
  62:src/pattern_generator.c ****             _PG_patternFadeIn(self); 
  63:src/pattern_generator.c ****             break;
  64:src/pattern_generator.c ****         case PATTERN_OFF:
  65:src/pattern_generator.c ****         default: 
  66:src/pattern_generator.c ****             _PG_patternOff(self);
  67:src/pattern_generator.c **** 
  68:src/pattern_generator.c ****     }
  69:src/pattern_generator.c **** 
  70:src/pattern_generator.c **** }
  71:src/pattern_generator.c **** 
  72:src/pattern_generator.c **** // PRIVATE METHODS BELOW
  73:src/pattern_generator.c **** 
  74:src/pattern_generator.c **** // clock position in radians
  75:src/pattern_generator.c **** void _PG_calcTheta(PatternGenerator* self, double clock_position) {
  74               		.loc 1 75 0
  75               		.cfi_startproc
  76               	.LVL2:
  77 003e CF92      		push r12
  78               	.LCFI0:
  79               		.cfi_def_cfa_offset 3
  80               		.cfi_offset 12, -2
  81 0040 DF92      		push r13
  82               	.LCFI1:
  83               		.cfi_def_cfa_offset 4
  84               		.cfi_offset 13, -3
  85 0042 EF92      		push r14
  86               	.LCFI2:
  87               		.cfi_def_cfa_offset 5
  88               		.cfi_offset 14, -4
  89 0044 FF92      		push r15
  90               	.LCFI3:
  91               		.cfi_def_cfa_offset 6
  92               		.cfi_offset 15, -5
  93 0046 0F93      		push r16
  94               	.LCFI4:
  95               		.cfi_def_cfa_offset 7
  96               		.cfi_offset 16, -6
  97 0048 1F93      		push r17
  98               	.LCFI5:
  99               		.cfi_def_cfa_offset 8
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 4


 100               		.cfi_offset 17, -7
 101 004a CF93      		push r28
 102               	.LCFI6:
 103               		.cfi_def_cfa_offset 9
 104               		.cfi_offset 28, -8
 105 004c DF93      		push r29
 106               	.LCFI7:
 107               		.cfi_def_cfa_offset 10
 108               		.cfi_offset 29, -9
 109               	/* prologue: function */
 110               	/* frame size = 0 */
 111               	/* stack size = 8 */
 112               	.L__stack_usage = 8
 113 004e EC01      		movw r28,r24
 114 0050 CB01      		movw r24,r22
 115 0052 BA01      		movw r22,r20
 116               	.LVL3:
  76:src/pattern_generator.c **** 
  77:src/pattern_generator.c ****     // calculate theta, in radians, from the current timer
  78:src/pattern_generator.c ****     double theta_at_speed = clock_position * self->speed;
 117               		.loc 1 78 0
 118 0054 2985      		ldd r18,Y+9
 119 0056 3A85      		ldd r19,Y+10
 120 0058 4B85      		ldd r20,Y+11
 121 005a 5C85      		ldd r21,Y+12
 122 005c 00D0      		rcall __mulsf3
 123               	.LVL4:
 124 005e 6B01      		movw r12,r22
 125 0060 7C01      		movw r14,r24
  79:src/pattern_generator.c **** 
  80:src/pattern_generator.c ****     // calculate the speed and phase adjusted theta
  81:src/pattern_generator.c ****     double new_theta = fmod(theta_at_speed + self->phase, _TWO_PI);
 126               		.loc 1 81 0
 127 0062 6D85      		ldd r22,Y+13
 128 0064 7E85      		ldd r23,Y+14
 129 0066 80E0      		ldi r24,0
 130 0068 90E0      		ldi r25,0
 131 006a 00D0      		rcall __floatunsisf
 132               	.LVL5:
 133 006c 9B01      		movw r18,r22
 134 006e AC01      		movw r20,r24
 135 0070 C701      		movw r24,r14
 136 0072 B601      		movw r22,r12
 137 0074 00D0      		rcall __addsf3
 138               	.LVL6:
 139 0076 2BED      		ldi r18,lo8(-37)
 140 0078 3FE0      		ldi r19,lo8(15)
 141 007a 49EC      		ldi r20,lo8(-55)
 142 007c 50E4      		ldi r21,lo8(64)
 143 007e 00D0      		rcall fmod
 144               	.LVL7:
 145 0080 6B01      		movw r12,r22
 146 0082 7C01      		movw r14,r24
 147               	.LVL8:
  82:src/pattern_generator.c **** 
  83:src/pattern_generator.c ****     // set zero crossing flag
  84:src/pattern_generator.c ****     self->isNewCycle = (self->theta > new_theta) ? 1 : 0;
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 5


 148               		.loc 1 84 0
 149 0084 01E0      		ldi r16,lo8(1)
 150 0086 10E0      		ldi r17,0
 151 0088 9B01      		movw r18,r22
 152 008a AC01      		movw r20,r24
 153 008c 6881      		ld r22,Y
 154 008e 7981      		ldd r23,Y+1
 155 0090 8A81      		ldd r24,Y+2
 156 0092 9B81      		ldd r25,Y+3
 157 0094 00D0      		rcall __gtsf2
 158               	.LVL9:
 159 0096 1816      		cp __zero_reg__,r24
 160 0098 04F0      		brlt .L3
 161 009a 00E0      		ldi r16,0
 162 009c 10E0      		ldi r17,0
 163               	.L3:
 164 009e 1E83      		std Y+6,r17
 165 00a0 0D83      		std Y+5,r16
  85:src/pattern_generator.c **** 
  86:src/pattern_generator.c ****     // set pattern theta
  87:src/pattern_generator.c ****     self->theta = new_theta;
 166               		.loc 1 87 0
 167 00a2 C882      		st Y,r12
 168 00a4 D982      		std Y+1,r13
 169 00a6 EA82      		std Y+2,r14
 170 00a8 FB82      		std Y+3,r15
 171               	/* epilogue start */
  88:src/pattern_generator.c **** 
  89:src/pattern_generator.c **** }
 172               		.loc 1 89 0
 173 00aa DF91      		pop r29
 174 00ac CF91      		pop r28
 175               	.LVL10:
 176 00ae 1F91      		pop r17
 177 00b0 0F91      		pop r16
 178 00b2 FF90      		pop r15
 179 00b4 EF90      		pop r14
 180 00b6 DF90      		pop r13
 181 00b8 CF90      		pop r12
 182               	.LVL11:
 183 00ba 0895      		ret
 184               		.cfi_endproc
 185               	.LFE6:
 187               	.global	_PG_patternOff
 189               	_PG_patternOff:
 190               	.LFB7:
  90:src/pattern_generator.c **** 
  91:src/pattern_generator.c **** void _PG_patternOff(PatternGenerator* self) {
 191               		.loc 1 91 0
 192               		.cfi_startproc
 193               	.LVL12:
 194               	/* prologue: function */
 195               	/* frame size = 0 */
 196               	/* stack size = 0 */
 197               	.L__stack_usage = 0
  92:src/pattern_generator.c **** 
  93:src/pattern_generator.c ****     self->value = 0; 
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 6


 198               		.loc 1 93 0
 199 00bc FC01      		movw r30,r24
 200 00be 178A      		std Z+23,__zero_reg__
 201 00c0 0895      		ret
 202               		.cfi_endproc
 203               	.LFE7:
 205               	.global	__fixunssfsi
 206               	.global	_PG_patternSolid
 208               	_PG_patternSolid:
 209               	.LFB8:
  94:src/pattern_generator.c **** 
  95:src/pattern_generator.c **** }
  96:src/pattern_generator.c **** 
  97:src/pattern_generator.c **** void _PG_patternSolid(PatternGenerator* self) {
 210               		.loc 1 97 0
 211               		.cfi_startproc
 212               	.LVL13:
 213 00c2 CF93      		push r28
 214               	.LCFI8:
 215               		.cfi_def_cfa_offset 3
 216               		.cfi_offset 28, -2
 217 00c4 DF93      		push r29
 218               	.LCFI9:
 219               		.cfi_def_cfa_offset 4
 220               		.cfi_offset 29, -3
 221               	/* prologue: function */
 222               	/* frame size = 0 */
 223               	/* stack size = 2 */
 224               	.L__stack_usage = 2
 225 00c6 EC01      		movw r28,r24
  98:src/pattern_generator.c **** 
  99:src/pattern_generator.c ****     self->value = self->bias;
 226               		.loc 1 99 0
 227 00c8 6B89      		ldd r22,Y+19
 228 00ca 7C89      		ldd r23,Y+20
 229 00cc 8D89      		ldd r24,Y+21
 230 00ce 9E89      		ldd r25,Y+22
 231 00d0 00D0      		rcall __fixunssfsi
 232               	.LVL14:
 233 00d2 6F8B      		std Y+23,r22
 234               	/* epilogue start */
 100:src/pattern_generator.c **** 
 101:src/pattern_generator.c **** }
 235               		.loc 1 101 0
 236 00d4 DF91      		pop r29
 237 00d6 CF91      		pop r28
 238               	.LVL15:
 239 00d8 0895      		ret
 240               		.cfi_endproc
 241               	.LFE8:
 243               	.global	_PG_patternStrobe
 245               	_PG_patternStrobe:
 246               	.LFB9:
 102:src/pattern_generator.c **** 
 103:src/pattern_generator.c **** void _PG_patternStrobe(PatternGenerator* self) {
 247               		.loc 1 103 0
 248               		.cfi_startproc
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 7


 249               	.LVL16:
 250 00da CF93      		push r28
 251               	.LCFI10:
 252               		.cfi_def_cfa_offset 3
 253               		.cfi_offset 28, -2
 254 00dc DF93      		push r29
 255               	.LCFI11:
 256               		.cfi_def_cfa_offset 4
 257               		.cfi_offset 29, -3
 258               	/* prologue: function */
 259               	/* frame size = 0 */
 260               	/* stack size = 2 */
 261               	.L__stack_usage = 2
 262 00de EC01      		movw r28,r24
 104:src/pattern_generator.c **** 
 105:src/pattern_generator.c ****     if (self->cyclesRemaining != CYCLES_STOP) {
 263               		.loc 1 105 0
 264 00e0 8C81      		ldd r24,Y+4
 265               	.LVL17:
 266 00e2 8F3F      		cpi r24,lo8(-1)
 267 00e4 01F0      		breq .L7
 268               	.LBB6:
 106:src/pattern_generator.c **** 
 107:src/pattern_generator.c ****         // calculate the carrier signal 
 108:src/pattern_generator.c ****         // as square wave
 109:src/pattern_generator.c ****         double carrier = (sin(self->theta) > 0) ? 1 : 0;
 269               		.loc 1 109 0
 270 00e6 6881      		ld r22,Y
 271 00e8 7981      		ldd r23,Y+1
 272 00ea 8A81      		ldd r24,Y+2
 273 00ec 9B81      		ldd r25,Y+3
 274 00ee 00D0      		rcall sin
 275               	.LVL18:
 276 00f0 20E0      		ldi r18,0
 277 00f2 30E0      		ldi r19,0
 278 00f4 A901      		movw r20,r18
 279 00f6 00D0      		rcall __gtsf2
 280               	.LVL19:
 281 00f8 1816      		cp __zero_reg__,r24
 282 00fa 04F4      		brge .L16
 283 00fc 60E0      		ldi r22,0
 284 00fe 70E0      		ldi r23,0
 285 0100 80E8      		ldi r24,lo8(-128)
 286 0102 9FE3      		ldi r25,lo8(63)
 287 0104 00C0      		rjmp .L9
 288               	.L16:
 289 0106 60E0      		ldi r22,0
 290 0108 70E0      		ldi r23,0
 291 010a CB01      		movw r24,r22
 292               	.L9:
 293               	.LVL20:
 110:src/pattern_generator.c **** 
 111:src/pattern_generator.c ****         // value is a square wave with an 
 112:src/pattern_generator.c ****         // adjustable amplitude and bias
 113:src/pattern_generator.c ****         self->value = self->bias + self->amplitude * carrier;
 294               		.loc 1 113 0 discriminator 3
 295 010c 2F85      		ldd r18,Y+15
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 8


 296 010e 3889      		ldd r19,Y+16
 297 0110 4989      		ldd r20,Y+17
 298 0112 5A89      		ldd r21,Y+18
 299 0114 00D0      		rcall __mulsf3
 300               	.LVL21:
 301 0116 2B89      		ldd r18,Y+19
 302 0118 3C89      		ldd r19,Y+20
 303 011a 4D89      		ldd r20,Y+21
 304 011c 5E89      		ldd r21,Y+22
 305 011e 00D0      		rcall __addsf3
 306               	.LVL22:
 307 0120 00D0      		rcall __fixunssfsi
 308               	.LVL23:
 309 0122 6F8B      		std Y+23,r22
 310               	.L7:
 311               	/* epilogue start */
 312               	.LBE6:
 114:src/pattern_generator.c **** 
 115:src/pattern_generator.c ****     }
 116:src/pattern_generator.c **** 
 117:src/pattern_generator.c **** }
 313               		.loc 1 117 0
 314 0124 DF91      		pop r29
 315 0126 CF91      		pop r28
 316               	.LVL24:
 317 0128 0895      		ret
 318               		.cfi_endproc
 319               	.LFE9:
 321               	.global	_PG_patternSine
 323               	_PG_patternSine:
 324               	.LFB10:
 118:src/pattern_generator.c **** 
 119:src/pattern_generator.c **** void _PG_patternSine(PatternGenerator* self) {
 325               		.loc 1 119 0
 326               		.cfi_startproc
 327               	.LVL25:
 328 012a CF93      		push r28
 329               	.LCFI12:
 330               		.cfi_def_cfa_offset 3
 331               		.cfi_offset 28, -2
 332 012c DF93      		push r29
 333               	.LCFI13:
 334               		.cfi_def_cfa_offset 4
 335               		.cfi_offset 29, -3
 336               	/* prologue: function */
 337               	/* frame size = 0 */
 338               	/* stack size = 2 */
 339               	.L__stack_usage = 2
 340 012e EC01      		movw r28,r24
 120:src/pattern_generator.c **** 
 121:src/pattern_generator.c ****     if (self->cyclesRemaining != CYCLES_STOP) {
 341               		.loc 1 121 0
 342 0130 8C81      		ldd r24,Y+4
 343               	.LVL26:
 344 0132 8F3F      		cpi r24,lo8(-1)
 345 0134 01F0      		breq .L17
 346               	.LBB7:
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 9


 122:src/pattern_generator.c **** 
 123:src/pattern_generator.c ****         // calculate the carrier signal 
 124:src/pattern_generator.c ****         double carrier = sin(self->theta);
 347               		.loc 1 124 0
 348 0136 6881      		ld r22,Y
 349 0138 7981      		ldd r23,Y+1
 350 013a 8A81      		ldd r24,Y+2
 351 013c 9B81      		ldd r25,Y+3
 352 013e 00D0      		rcall sin
 353               	.LVL27:
 125:src/pattern_generator.c **** 
 126:src/pattern_generator.c ****         // value is a sin function output of the form
 127:src/pattern_generator.c ****         // B + A * sin(theta)
 128:src/pattern_generator.c ****         self->value = self->bias + self->amplitude * carrier;
 354               		.loc 1 128 0
 355 0140 2F85      		ldd r18,Y+15
 356 0142 3889      		ldd r19,Y+16
 357 0144 4989      		ldd r20,Y+17
 358 0146 5A89      		ldd r21,Y+18
 359 0148 00D0      		rcall __mulsf3
 360               	.LVL28:
 361 014a 2B89      		ldd r18,Y+19
 362 014c 3C89      		ldd r19,Y+20
 363 014e 4D89      		ldd r20,Y+21
 364 0150 5E89      		ldd r21,Y+22
 365 0152 00D0      		rcall __addsf3
 366               	.LVL29:
 367 0154 00D0      		rcall __fixunssfsi
 368               	.LVL30:
 369 0156 6F8B      		std Y+23,r22
 370               	.L17:
 371               	/* epilogue start */
 372               	.LBE7:
 129:src/pattern_generator.c **** 
 130:src/pattern_generator.c ****     }
 131:src/pattern_generator.c **** 
 132:src/pattern_generator.c **** }
 373               		.loc 1 132 0
 374 0158 DF91      		pop r29
 375 015a CF91      		pop r28
 376               	.LVL31:
 377 015c 0895      		ret
 378               		.cfi_endproc
 379               	.LFE10:
 381               	.global	_PG_patternSiren
 383               	_PG_patternSiren:
 384               	.LFB11:
 133:src/pattern_generator.c **** 
 134:src/pattern_generator.c **** void _PG_patternSiren(PatternGenerator* self) {
 385               		.loc 1 134 0
 386               		.cfi_startproc
 387               	.LVL32:
 388 015e CF93      		push r28
 389               	.LCFI14:
 390               		.cfi_def_cfa_offset 3
 391               		.cfi_offset 28, -2
 392 0160 DF93      		push r29
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 10


 393               	.LCFI15:
 394               		.cfi_def_cfa_offset 4
 395               		.cfi_offset 29, -3
 396               	/* prologue: function */
 397               	/* frame size = 0 */
 398               	/* stack size = 2 */
 399               	.L__stack_usage = 2
 400 0162 EC01      		movw r28,r24
 135:src/pattern_generator.c **** 
 136:src/pattern_generator.c ****     if (self->cyclesRemaining != CYCLES_STOP) {
 401               		.loc 1 136 0
 402 0164 8C81      		ldd r24,Y+4
 403               	.LVL33:
 404 0166 8F3F      		cpi r24,lo8(-1)
 405 0168 01F0      		breq .L22
 406               	.LBB8:
 137:src/pattern_generator.c **** 
 138:src/pattern_generator.c ****         // calculate the carrier signal 
 139:src/pattern_generator.c ****         double carrier = sin(tan(self->theta)*.5);
 407               		.loc 1 139 0
 408 016a 6881      		ld r22,Y
 409 016c 7981      		ldd r23,Y+1
 410 016e 8A81      		ldd r24,Y+2
 411 0170 9B81      		ldd r25,Y+3
 412 0172 00D0      		rcall tan
 413               	.LVL34:
 414 0174 20E0      		ldi r18,0
 415 0176 30E0      		ldi r19,0
 416 0178 40E0      		ldi r20,0
 417 017a 5FE3      		ldi r21,lo8(63)
 418 017c 00D0      		rcall __mulsf3
 419               	.LVL35:
 420 017e 00D0      		rcall sin
 421               	.LVL36:
 140:src/pattern_generator.c **** 
 141:src/pattern_generator.c ****         // value is an annoying strobe-like pattern
 142:src/pattern_generator.c ****         self->value = self->bias + self->amplitude * carrier;
 422               		.loc 1 142 0
 423 0180 2F85      		ldd r18,Y+15
 424 0182 3889      		ldd r19,Y+16
 425 0184 4989      		ldd r20,Y+17
 426 0186 5A89      		ldd r21,Y+18
 427 0188 00D0      		rcall __mulsf3
 428               	.LVL37:
 429 018a 2B89      		ldd r18,Y+19
 430 018c 3C89      		ldd r19,Y+20
 431 018e 4D89      		ldd r20,Y+21
 432 0190 5E89      		ldd r21,Y+22
 433 0192 00D0      		rcall __addsf3
 434               	.LVL38:
 435 0194 00D0      		rcall __fixunssfsi
 436               	.LVL39:
 437 0196 6F8B      		std Y+23,r22
 438               	.L22:
 439               	/* epilogue start */
 440               	.LBE8:
 143:src/pattern_generator.c **** 
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 11


 144:src/pattern_generator.c ****     }
 145:src/pattern_generator.c **** 
 146:src/pattern_generator.c **** }
 441               		.loc 1 146 0
 442 0198 DF91      		pop r29
 443 019a CF91      		pop r28
 444               	.LVL40:
 445 019c 0895      		ret
 446               		.cfi_endproc
 447               	.LFE11:
 449               	.global	_PG_patternFadeIn
 451               	_PG_patternFadeIn:
 452               	.LFB12:
 147:src/pattern_generator.c **** 
 148:src/pattern_generator.c **** void _PG_patternFadeIn(PatternGenerator* self) {
 453               		.loc 1 148 0
 454               		.cfi_startproc
 455               	.LVL41:
 456 019e CF93      		push r28
 457               	.LCFI16:
 458               		.cfi_def_cfa_offset 3
 459               		.cfi_offset 28, -2
 460 01a0 DF93      		push r29
 461               	.LCFI17:
 462               		.cfi_def_cfa_offset 4
 463               		.cfi_offset 29, -3
 464               	/* prologue: function */
 465               	/* frame size = 0 */
 466               	/* stack size = 2 */
 467               	.L__stack_usage = 2
 468 01a2 EC01      		movw r28,r24
 149:src/pattern_generator.c **** 
 150:src/pattern_generator.c ****     if (self->cyclesRemaining > 0) return;
 469               		.loc 1 150 0
 470 01a4 8C81      		ldd r24,Y+4
 471               	.LVL42:
 472 01a6 1816      		cp __zero_reg__,r24
 473 01a8 04F0      		brlt .L27
 151:src/pattern_generator.c **** 
 152:src/pattern_generator.c ****     if (self->cyclesRemaining == 0) {
 474               		.loc 1 152 0
 475 01aa 8111      		cpse r24,__zero_reg__
 476 01ac 00C0      		rjmp .L29
 477               	.LBB9:
 153:src/pattern_generator.c **** 
 154:src/pattern_generator.c ****         // calculate the carrier signal 
 155:src/pattern_generator.c ****         double carrier = sin(self->theta/4);
 478               		.loc 1 155 0
 479 01ae 20E0      		ldi r18,0
 480 01b0 30E0      		ldi r19,0
 481 01b2 40E8      		ldi r20,lo8(-128)
 482 01b4 5EE3      		ldi r21,lo8(62)
 483 01b6 6881      		ld r22,Y
 484 01b8 7981      		ldd r23,Y+1
 485 01ba 8A81      		ldd r24,Y+2
 486 01bc 9B81      		ldd r25,Y+3
 487 01be 00D0      		rcall __mulsf3
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 12


 488               	.LVL43:
 489 01c0 00D0      		rcall sin
 490               	.LVL44:
 156:src/pattern_generator.c **** 
 157:src/pattern_generator.c ****         // update output
 158:src/pattern_generator.c ****         self->value = self->amplitude * carrier;
 491               		.loc 1 158 0
 492 01c2 2F85      		ldd r18,Y+15
 493 01c4 3889      		ldd r19,Y+16
 494 01c6 4989      		ldd r20,Y+17
 495 01c8 5A89      		ldd r21,Y+18
 496 01ca 00D0      		rcall __mulsf3
 497               	.LVL45:
 498 01cc 00C0      		rjmp .L30
 499               	.L29:
 500               	.LBE9:
 159:src/pattern_generator.c **** 
 160:src/pattern_generator.c ****     } else {
 161:src/pattern_generator.c **** 
 162:src/pattern_generator.c ****         self->value = self->amplitude;
 501               		.loc 1 162 0
 502 01ce 6F85      		ldd r22,Y+15
 503 01d0 7889      		ldd r23,Y+16
 504 01d2 8989      		ldd r24,Y+17
 505 01d4 9A89      		ldd r25,Y+18
 506               	.L30:
 507 01d6 00D0      		rcall __fixunssfsi
 508               	.LVL46:
 509 01d8 6F8B      		std Y+23,r22
 510               	.L27:
 511               	/* epilogue start */
 163:src/pattern_generator.c **** 
 164:src/pattern_generator.c ****     }
 165:src/pattern_generator.c **** 
 166:src/pattern_generator.c **** }
 512               		.loc 1 166 0
 513 01da DF91      		pop r29
 514 01dc CF91      		pop r28
 515               	.LVL47:
 516 01de 0895      		ret
 517               		.cfi_endproc
 518               	.LFE12:
 520               	.global	_PG_patternFadeOut
 522               	_PG_patternFadeOut:
 523               	.LFB13:
 167:src/pattern_generator.c **** 
 168:src/pattern_generator.c **** void _PG_patternFadeOut(PatternGenerator* self) {
 524               		.loc 1 168 0
 525               		.cfi_startproc
 526               	.LVL48:
 527 01e0 CF93      		push r28
 528               	.LCFI18:
 529               		.cfi_def_cfa_offset 3
 530               		.cfi_offset 28, -2
 531 01e2 DF93      		push r29
 532               	.LCFI19:
 533               		.cfi_def_cfa_offset 4
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 13


 534               		.cfi_offset 29, -3
 535               	/* prologue: function */
 536               	/* frame size = 0 */
 537               	/* stack size = 2 */
 538               	.L__stack_usage = 2
 539 01e4 EC01      		movw r28,r24
 169:src/pattern_generator.c **** 
 170:src/pattern_generator.c ****     if (self->cyclesRemaining > 0) return;
 540               		.loc 1 170 0
 541 01e6 8C81      		ldd r24,Y+4
 542               	.LVL49:
 543 01e8 1816      		cp __zero_reg__,r24
 544 01ea 04F0      		brlt .L31
 171:src/pattern_generator.c **** 
 172:src/pattern_generator.c ****     if (self->cyclesRemaining == 0) {
 545               		.loc 1 172 0
 546 01ec 8111      		cpse r24,__zero_reg__
 547 01ee 00C0      		rjmp .L33
 548               	.LBB10:
 173:src/pattern_generator.c **** 
 174:src/pattern_generator.c ****         // calculate the carrier signal 
 175:src/pattern_generator.c ****         double carrier = cos(self->theta/4);
 549               		.loc 1 175 0
 550 01f0 20E0      		ldi r18,0
 551 01f2 30E0      		ldi r19,0
 552 01f4 40E8      		ldi r20,lo8(-128)
 553 01f6 5EE3      		ldi r21,lo8(62)
 554 01f8 6881      		ld r22,Y
 555 01fa 7981      		ldd r23,Y+1
 556 01fc 8A81      		ldd r24,Y+2
 557 01fe 9B81      		ldd r25,Y+3
 558 0200 00D0      		rcall __mulsf3
 559               	.LVL50:
 560 0202 00D0      		rcall cos
 561               	.LVL51:
 176:src/pattern_generator.c **** 
 177:src/pattern_generator.c ****         // update output
 178:src/pattern_generator.c ****         self->value = self->amplitude * carrier;
 562               		.loc 1 178 0
 563 0204 2F85      		ldd r18,Y+15
 564 0206 3889      		ldd r19,Y+16
 565 0208 4989      		ldd r20,Y+17
 566 020a 5A89      		ldd r21,Y+18
 567 020c 00D0      		rcall __mulsf3
 568               	.LVL52:
 569 020e 00D0      		rcall __fixunssfsi
 570               	.LVL53:
 571 0210 6F8B      		std Y+23,r22
 572               	.LBE10:
 573 0212 00C0      		rjmp .L31
 574               	.L33:
 179:src/pattern_generator.c **** 
 180:src/pattern_generator.c ****     } else {
 181:src/pattern_generator.c **** 
 182:src/pattern_generator.c ****         self->value = 0;
 575               		.loc 1 182 0
 576 0214 1F8A      		std Y+23,__zero_reg__
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 14


 577               	.L31:
 578               	/* epilogue start */
 183:src/pattern_generator.c **** 
 184:src/pattern_generator.c ****     }
 185:src/pattern_generator.c **** 
 186:src/pattern_generator.c **** }
 579               		.loc 1 186 0
 580 0216 DF91      		pop r29
 581 0218 CF91      		pop r28
 582               	.LVL54:
 583 021a 0895      		ret
 584               		.cfi_endproc
 585               	.LFE13:
 587               	.global	PG_calc
 589               	PG_calc:
 590               	.LFB5:
  33:src/pattern_generator.c **** void PG_calc(PatternGenerator* self, double clock_position) { 
 591               		.loc 1 33 0
 592               		.cfi_startproc
 593               	.LVL55:
 594 021c CF93      		push r28
 595               	.LCFI20:
 596               		.cfi_def_cfa_offset 3
 597               		.cfi_offset 28, -2
 598 021e DF93      		push r29
 599               	.LCFI21:
 600               		.cfi_def_cfa_offset 4
 601               		.cfi_offset 29, -3
 602               	/* prologue: function */
 603               	/* frame size = 0 */
 604               	/* stack size = 2 */
 605               	.L__stack_usage = 2
 606 0220 EC01      		movw r28,r24
  36:src/pattern_generator.c ****     _PG_calcTheta(self, clock_position);
 607               		.loc 1 36 0
 608 0222 00D0      		rcall _PG_calcTheta
 609               	.LVL56:
  40:src/pattern_generator.c ****     if (self->isNewCycle && self->cyclesRemaining >= 0) 
 610               		.loc 1 40 0
 611 0224 8D81      		ldd r24,Y+5
 612 0226 9E81      		ldd r25,Y+6
 613 0228 892B      		or r24,r25
 614 022a 01F0      		breq .L35
  40:src/pattern_generator.c ****     if (self->isNewCycle && self->cyclesRemaining >= 0) 
 615               		.loc 1 40 0 is_stmt 0 discriminator 1
 616 022c 8C81      		ldd r24,Y+4
 617 022e 87FD      		sbrc r24,7
 618 0230 00C0      		rjmp .L35
  41:src/pattern_generator.c ****         self->cyclesRemaining--;
 619               		.loc 1 41 0 is_stmt 1
 620 0232 8150      		subi r24,lo8(-(-1))
 621 0234 8C83      		std Y+4,r24
 622               	.L35:
  44:src/pattern_generator.c ****     switch(self->pattern) {
 623               		.loc 1 44 0
 624 0236 8F81      		ldd r24,Y+7
 625 0238 9885      		ldd r25,Y+8
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 15


 626 023a 8330      		cpi r24,3
 627 023c 9105      		cpc r25,__zero_reg__
 628 023e 01F0      		breq .L37
 629 0240 00F4      		brsh .L38
 630 0242 8130      		cpi r24,1
 631 0244 9105      		cpc r25,__zero_reg__
 632 0246 01F0      		breq .L39
 633 0248 0297      		sbiw r24,2
 634 024a 01F4      		brne .L36
 635               	.LVL57:
 636               	.LBB11:
 637               	.LBB12:
  99:src/pattern_generator.c ****     self->value = self->bias;
 638               		.loc 1 99 0
 639 024c 6B89      		ldd r22,Y+19
 640 024e 7C89      		ldd r23,Y+20
 641 0250 8D89      		ldd r24,Y+21
 642 0252 9E89      		ldd r25,Y+22
 643 0254 00D0      		rcall __fixunssfsi
 644               	.LVL58:
 645 0256 6F8B      		std Y+23,r22
 646 0258 00C0      		rjmp .L34
 647               	.LVL59:
 648               	.L38:
 649               	.LBE12:
 650               	.LBE11:
  44:src/pattern_generator.c ****     switch(self->pattern) {
 651               		.loc 1 44 0
 652 025a 8530      		cpi r24,5
 653 025c 9105      		cpc r25,__zero_reg__
 654 025e 01F0      		breq .L41
 655 0260 00F0      		brlo .L42
 656 0262 0697      		sbiw r24,6
 657 0264 01F4      		brne .L36
  59:src/pattern_generator.c ****             _PG_patternFadeOut(self); 
 658               		.loc 1 59 0
 659 0266 CE01      		movw r24,r28
 660               	/* epilogue start */
  70:src/pattern_generator.c **** }
 661               		.loc 1 70 0
 662 0268 DF91      		pop r29
 663 026a CF91      		pop r28
 664               	.LVL60:
  59:src/pattern_generator.c ****             _PG_patternFadeOut(self); 
 665               		.loc 1 59 0
 666 026c 00C0      		rjmp _PG_patternFadeOut
 667               	.LVL61:
 668               	.L39:
  47:src/pattern_generator.c ****             _PG_patternSine(self); 
 669               		.loc 1 47 0
 670 026e CE01      		movw r24,r28
 671               	/* epilogue start */
  70:src/pattern_generator.c **** }
 672               		.loc 1 70 0
 673 0270 DF91      		pop r29
 674 0272 CF91      		pop r28
 675               	.LVL62:
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 16


  47:src/pattern_generator.c ****             _PG_patternSine(self); 
 676               		.loc 1 47 0
 677 0274 00C0      		rjmp _PG_patternSine
 678               	.LVL63:
 679               	.L42:
  50:src/pattern_generator.c ****             _PG_patternStrobe(self); 
 680               		.loc 1 50 0
 681 0276 CE01      		movw r24,r28
 682               	/* epilogue start */
  70:src/pattern_generator.c **** }
 683               		.loc 1 70 0
 684 0278 DF91      		pop r29
 685 027a CF91      		pop r28
 686               	.LVL64:
  50:src/pattern_generator.c ****             _PG_patternStrobe(self); 
 687               		.loc 1 50 0
 688 027c 00C0      		rjmp _PG_patternStrobe
 689               	.LVL65:
 690               	.L37:
  53:src/pattern_generator.c ****             _PG_patternSiren(self); 
 691               		.loc 1 53 0
 692 027e CE01      		movw r24,r28
 693               	/* epilogue start */
  70:src/pattern_generator.c **** }
 694               		.loc 1 70 0
 695 0280 DF91      		pop r29
 696 0282 CF91      		pop r28
 697               	.LVL66:
  53:src/pattern_generator.c ****             _PG_patternSiren(self); 
 698               		.loc 1 53 0
 699 0284 00C0      		rjmp _PG_patternSiren
 700               	.LVL67:
 701               	.L41:
  62:src/pattern_generator.c ****             _PG_patternFadeIn(self); 
 702               		.loc 1 62 0
 703 0286 CE01      		movw r24,r28
 704               	/* epilogue start */
  70:src/pattern_generator.c **** }
 705               		.loc 1 70 0
 706 0288 DF91      		pop r29
 707 028a CF91      		pop r28
 708               	.LVL68:
  62:src/pattern_generator.c ****             _PG_patternFadeIn(self); 
 709               		.loc 1 62 0
 710 028c 00C0      		rjmp _PG_patternFadeIn
 711               	.LVL69:
 712               	.L36:
 713               	.LBB13:
 714               	.LBB14:
  93:src/pattern_generator.c ****     self->value = 0; 
 715               		.loc 1 93 0
 716 028e 1F8A      		std Y+23,__zero_reg__
 717               	.LVL70:
 718               	.L34:
 719               	/* epilogue start */
 720               	.LBE14:
 721               	.LBE13:
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 17


  70:src/pattern_generator.c **** }
 722               		.loc 1 70 0
 723 0290 DF91      		pop r29
 724 0292 CF91      		pop r28
 725               	.LVL71:
 726 0294 0895      		ret
 727               		.cfi_endproc
 728               	.LFE5:
 730               	.Letext0:
 731               		.file 2 "/usr/local/CrossPack-AVR-20131216/avr/include/stdint.h"
 732               		.file 3 "include/pattern_generator.h"
 733               		.file 4 "include/utilities.h"
 734               		.file 5 "/usr/local/CrossPack-AVR-20131216/avr/include/math.h"
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s 			page 18


DEFINED SYMBOLS
                            *ABS*:00000000 pattern_generator.c
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s:2      *ABS*:0000003e __SP_H__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s:3      *ABS*:0000003d __SP_L__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s:4      *ABS*:0000003f __SREG__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s:5      *ABS*:00000000 __tmp_reg__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s:6      *ABS*:00000001 __zero_reg__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s:12     .text:00000000 PG_init
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s:72     .text:0000003e _PG_calcTheta
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s:189    .text:000000bc _PG_patternOff
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s:208    .text:000000c2 _PG_patternSolid
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s:245    .text:000000da _PG_patternStrobe
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s:323    .text:0000012a _PG_patternSine
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s:383    .text:0000015e _PG_patternSiren
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s:451    .text:0000019e _PG_patternFadeIn
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s:522    .text:000001e0 _PG_patternFadeOut
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cchrueu7.s:589    .text:0000021c PG_calc

UNDEFINED SYMBOLS
__mulsf3
__floatunsisf
__addsf3
__gtsf2
fmod
__fixunssfsi
sin
tan
cos
