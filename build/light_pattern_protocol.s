GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 1


   1               		.file	"light_pattern_protocol.c"
   2               	__SP_H__ = 0x3e
   3               	__SP_L__ = 0x3d
   4               	__SREG__ = 0x3f
   5               	__tmp_reg__ = 0
   6               	__zero_reg__ = 1
   7               		.text
   8               	.Ltext0:
   9               		.cfi_sections	.debug_frame
  10               	.global	LPP_setRedPatternGen
  12               	LPP_setRedPatternGen:
  13               	.LFB2:
  14               		.file 1 "src/light_pattern_protocol.c"
   1:src/light_pattern_protocol.c **** /**********************************************************************
   2:src/light_pattern_protocol.c **** 
   3:src/light_pattern_protocol.c ****   light_pattern_protocol.c - implementation, see header for description
   4:src/light_pattern_protocol.c **** 
   5:src/light_pattern_protocol.c **** 
   6:src/light_pattern_protocol.c ****   Authors: 
   7:src/light_pattern_protocol.c ****     Nate Fisher
   8:src/light_pattern_protocol.c **** 
   9:src/light_pattern_protocol.c ****   Created: 
  10:src/light_pattern_protocol.c ****     Wed Oct 1, 2014
  11:src/light_pattern_protocol.c **** 
  12:src/light_pattern_protocol.c **** **********************************************************************/
  13:src/light_pattern_protocol.c **** 
  14:src/light_pattern_protocol.c **** #include <avr/io.h>
  15:src/light_pattern_protocol.c **** #include "light_pattern_protocol.h"
  16:src/light_pattern_protocol.c **** #include "pattern_generator.h"
  17:src/light_pattern_protocol.c **** #include "utilities.h"
  18:src/light_pattern_protocol.c **** 
  19:src/light_pattern_protocol.c **** void LPP_setRedPatternGen(PatternGenerator* pattern) { 
  15               		.loc 1 19 0
  16               		.cfi_startproc
  17               	.LVL0:
  18               	/* prologue: function */
  19               	/* frame size = 0 */
  20               	/* stack size = 0 */
  21               	.L__stack_usage = 0
  20:src/light_pattern_protocol.c **** 
  21:src/light_pattern_protocol.c ****     _self_pattern_protocol.redPattern = pattern; 
  22               		.loc 1 21 0
  23 0000 9093 0000 		sts _self_pattern_protocol+1+1,r25
  24 0004 8093 0000 		sts _self_pattern_protocol+1,r24
  25 0008 0895      		ret
  26               		.cfi_endproc
  27               	.LFE2:
  29               	.global	LPP_setGreenPatternGen
  31               	LPP_setGreenPatternGen:
  32               	.LFB3:
  22:src/light_pattern_protocol.c **** 
  23:src/light_pattern_protocol.c **** }
  24:src/light_pattern_protocol.c **** 
  25:src/light_pattern_protocol.c **** void LPP_setGreenPatternGen(PatternGenerator* pattern) { 
  33               		.loc 1 25 0
  34               		.cfi_startproc
  35               	.LVL1:
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 2


  36               	/* prologue: function */
  37               	/* frame size = 0 */
  38               	/* stack size = 0 */
  39               	.L__stack_usage = 0
  26:src/light_pattern_protocol.c **** 
  27:src/light_pattern_protocol.c ****     _self_pattern_protocol.greenPattern = pattern; 
  40               		.loc 1 27 0
  41 000a 9093 0000 		sts _self_pattern_protocol+3+1,r25
  42 000e 8093 0000 		sts _self_pattern_protocol+3,r24
  43 0012 0895      		ret
  44               		.cfi_endproc
  45               	.LFE3:
  47               	.global	LPP_setBluePatternGen
  49               	LPP_setBluePatternGen:
  50               	.LFB4:
  28:src/light_pattern_protocol.c **** 
  29:src/light_pattern_protocol.c **** }
  30:src/light_pattern_protocol.c **** 
  31:src/light_pattern_protocol.c **** void LPP_setBluePatternGen(PatternGenerator* pattern) { 
  51               		.loc 1 31 0
  52               		.cfi_startproc
  53               	.LVL2:
  54               	/* prologue: function */
  55               	/* frame size = 0 */
  56               	/* stack size = 0 */
  57               	.L__stack_usage = 0
  32:src/light_pattern_protocol.c **** 
  33:src/light_pattern_protocol.c ****     _self_pattern_protocol.bluePattern = pattern; 
  58               		.loc 1 33 0
  59 0014 9093 0000 		sts _self_pattern_protocol+5+1,r25
  60 0018 8093 0000 		sts _self_pattern_protocol+5,r24
  61 001c 0895      		ret
  62               		.cfi_endproc
  63               	.LFE4:
  65               	.global	LPP_setCommandRefreshed
  67               	LPP_setCommandRefreshed:
  68               	.LFB6:
  34:src/light_pattern_protocol.c **** 
  35:src/light_pattern_protocol.c **** }
  36:src/light_pattern_protocol.c ****         
  37:src/light_pattern_protocol.c **** void LPP_processBuffer(char* twiCommandBuffer, int size) {
  38:src/light_pattern_protocol.c **** 
  39:src/light_pattern_protocol.c ****     // if command is new, re-parse
  40:src/light_pattern_protocol.c ****     // ensure valid length buffer
  41:src/light_pattern_protocol.c ****     // ensure pointer is valid
  42:src/light_pattern_protocol.c ****     if (twiCommandBuffer && 
  43:src/light_pattern_protocol.c ****         size > 0 &&
  44:src/light_pattern_protocol.c ****         _self_pattern_protocol.isCommandFresh) {
  45:src/light_pattern_protocol.c **** 
  46:src/light_pattern_protocol.c ****         // set pattern if command is not a param-only command
  47:src/light_pattern_protocol.c ****         if (twiCommandBuffer[0] != PATTERN_PARAMUPDATE)
  48:src/light_pattern_protocol.c ****             _LPP_setPattern( twiCommandBuffer[0] );
  49:src/light_pattern_protocol.c **** 
  50:src/light_pattern_protocol.c ****         // cycle through remaining params
  51:src/light_pattern_protocol.c ****         // beginning with first param (following pattern byte)
  52:src/light_pattern_protocol.c ****         int buffer_pointer = 1;
  53:src/light_pattern_protocol.c ****         while (buffer_pointer < size) {
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 3


  54:src/light_pattern_protocol.c **** 
  55:src/light_pattern_protocol.c ****             // digest parameters serially
  56:src/light_pattern_protocol.c ****             PatternEnum currParam;
  57:src/light_pattern_protocol.c **** 
  58:src/light_pattern_protocol.c ****             // ensure parameter is valid, stop parsing if invalid
  59:src/light_pattern_protocol.c ****             //    this means that part of a message can be parsed, until
  60:src/light_pattern_protocol.c ****             //    an invalid parameter is seen
  61:src/light_pattern_protocol.c ****             if (twiCommandBuffer[buffer_pointer] < PARAM_ENUM_COUNT &&
  62:src/light_pattern_protocol.c ****                 twiCommandBuffer[buffer_pointer] >= 0) {
  63:src/light_pattern_protocol.c **** 
  64:src/light_pattern_protocol.c ****                 currParam = twiCommandBuffer[buffer_pointer];
  65:src/light_pattern_protocol.c **** 
  66:src/light_pattern_protocol.c ****             } else {
  67:src/light_pattern_protocol.c **** 
  68:src/light_pattern_protocol.c ****                 break;
  69:src/light_pattern_protocol.c **** 
  70:src/light_pattern_protocol.c ****             }
  71:src/light_pattern_protocol.c **** 
  72:src/light_pattern_protocol.c ****             // get size of parameter value
  73:src/light_pattern_protocol.c ****             int paramSize = LightParameterSize[currParam];
  74:src/light_pattern_protocol.c **** 
  75:src/light_pattern_protocol.c ****             // ensure buffer is long enough
  76:src/light_pattern_protocol.c ****             //   stop parsing if remaining buffer length does 
  77:src/light_pattern_protocol.c ****             //   not have enough room for this parameter
  78:src/light_pattern_protocol.c ****             //   ('size-1' accounts for pattern byte)
  79:src/light_pattern_protocol.c ****             if (buffer_pointer + paramSize > size-1) break;
  80:src/light_pattern_protocol.c **** 
  81:src/light_pattern_protocol.c ****             // implement parameter+value update 
  82:src/light_pattern_protocol.c ****             //process(currParam, start, stop, buffer);
  83:src/light_pattern_protocol.c ****             _LPP_processParameterUpdate(currParam, buffer_pointer+1, twiCommandBuffer);
  84:src/light_pattern_protocol.c **** 
  85:src/light_pattern_protocol.c ****             // advance pointer
  86:src/light_pattern_protocol.c ****             buffer_pointer += paramSize + 1;
  87:src/light_pattern_protocol.c **** 
  88:src/light_pattern_protocol.c ****         }
  89:src/light_pattern_protocol.c **** 
  90:src/light_pattern_protocol.c **** 
  91:src/light_pattern_protocol.c ****     }
  92:src/light_pattern_protocol.c **** 
  93:src/light_pattern_protocol.c ****     // signal command has been parsed
  94:src/light_pattern_protocol.c ****     _self_pattern_protocol.isCommandFresh = 0;
  95:src/light_pattern_protocol.c **** 
  96:src/light_pattern_protocol.c **** }
  97:src/light_pattern_protocol.c **** 
  98:src/light_pattern_protocol.c **** void LPP_setCommandRefreshed() {
  69               		.loc 1 98 0
  70               		.cfi_startproc
  71               	/* prologue: function */
  72               	/* frame size = 0 */
  73               	/* stack size = 0 */
  74               	.L__stack_usage = 0
  99:src/light_pattern_protocol.c **** 
 100:src/light_pattern_protocol.c ****     _self_pattern_protocol.isCommandFresh = 1;
  75               		.loc 1 100 0
  76 001e 81E0      		ldi r24,lo8(1)
  77 0020 8093 0000 		sts _self_pattern_protocol,r24
  78 0024 0895      		ret
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 4


  79               		.cfi_endproc
  80               	.LFE6:
  82               	.global	_LPP_setPattern
  84               	_LPP_setPattern:
  85               	.LFB7:
 101:src/light_pattern_protocol.c **** 
 102:src/light_pattern_protocol.c **** }
 103:src/light_pattern_protocol.c **** 
 104:src/light_pattern_protocol.c **** void _LPP_setPattern(int patternEnum) {
  86               		.loc 1 104 0
  87               		.cfi_startproc
  88               	.LVL3:
  89 0026 CF93      		push r28
  90               	.LCFI0:
  91               		.cfi_def_cfa_offset 3
  92               		.cfi_offset 28, -2
  93 0028 DF93      		push r29
  94               	.LCFI1:
  95               		.cfi_def_cfa_offset 4
  96               		.cfi_offset 29, -3
  97               	/* prologue: function */
  98               	/* frame size = 0 */
  99               	/* stack size = 2 */
 100               	.L__stack_usage = 2
 105:src/light_pattern_protocol.c **** 
 106:src/light_pattern_protocol.c ****     // if changing to fadein/fadeout, set cycles to 1
 107:src/light_pattern_protocol.c ****     // TODO create a more robust method of setting defaults
 108:src/light_pattern_protocol.c ****     if (_self_pattern_protocol.greenPattern->pattern != patternEnum &&
 101               		.loc 1 108 0
 102 002a E091 0000 		lds r30,_self_pattern_protocol+3
 103 002e F091 0000 		lds r31,_self_pattern_protocol+3+1
 104 0032 2781      		ldd r18,Z+7
 105 0034 3085      		ldd r19,Z+8
 106 0036 A091 0000 		lds r26,_self_pattern_protocol+1
 107 003a B091 0000 		lds r27,_self_pattern_protocol+1+1
 108 003e 2817      		cp r18,r24
 109 0040 3907      		cpc r19,r25
 110 0042 01F0      		breq .L6
 109:src/light_pattern_protocol.c ****         ((patternEnum == PATTERN_FADEIN) | 
 111               		.loc 1 109 0 discriminator 1
 112 0044 9C01      		movw r18,r24
 113 0046 2550      		subi r18,5
 114 0048 3109      		sbc r19,__zero_reg__
 108:src/light_pattern_protocol.c ****     if (_self_pattern_protocol.greenPattern->pattern != patternEnum &&
 115               		.loc 1 108 0 discriminator 1
 116 004a 2230      		cpi r18,2
 117 004c 3105      		cpc r19,__zero_reg__
 118 004e 00F4      		brsh .L6
 110:src/light_pattern_protocol.c ****          (patternEnum == PATTERN_FADEOUT))) {
 111:src/light_pattern_protocol.c **** 
 112:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->cyclesRemaining = 1;
 119               		.loc 1 112 0
 120 0050 21E0      		ldi r18,lo8(1)
 121 0052 1496      		adiw r26,4
 122 0054 2C93      		st X,r18
 123 0056 1497      		sbiw r26,4
 113:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->cyclesRemaining = 1;
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 5


 124               		.loc 1 113 0
 125 0058 2483      		std Z+4,r18
 114:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->cyclesRemaining = 1;
 126               		.loc 1 114 0
 127 005a C091 0000 		lds r28,_self_pattern_protocol+5
 128 005e D091 0000 		lds r29,_self_pattern_protocol+5+1
 129 0062 2C83      		std Y+4,r18
 130               	.L6:
 115:src/light_pattern_protocol.c **** 
 116:src/light_pattern_protocol.c ****     }
 117:src/light_pattern_protocol.c **** 
 118:src/light_pattern_protocol.c ****     // assign each light pattern 
 119:src/light_pattern_protocol.c ****     _self_pattern_protocol.redPattern->pattern = patternEnum;
 131               		.loc 1 119 0
 132 0064 1896      		adiw r26,7+1
 133 0066 9C93      		st X,r25
 134 0068 8E93      		st -X,r24
 135 006a 1797      		sbiw r26,7
 120:src/light_pattern_protocol.c ****     _self_pattern_protocol.greenPattern->pattern = patternEnum;
 136               		.loc 1 120 0
 137 006c 9087      		std Z+8,r25
 138 006e 8783      		std Z+7,r24
 121:src/light_pattern_protocol.c ****     _self_pattern_protocol.bluePattern->pattern = patternEnum;
 139               		.loc 1 121 0
 140 0070 E091 0000 		lds r30,_self_pattern_protocol+5
 141 0074 F091 0000 		lds r31,_self_pattern_protocol+5+1
 142 0078 9087      		std Z+8,r25
 143 007a 8783      		std Z+7,r24
 144               	/* epilogue start */
 122:src/light_pattern_protocol.c **** 
 123:src/light_pattern_protocol.c **** }
 145               		.loc 1 123 0
 146 007c DF91      		pop r29
 147 007e CF91      		pop r28
 148 0080 0895      		ret
 149               		.cfi_endproc
 150               	.LFE7:
 152               	.global	__floatunsisf
 153               	.global	__addsf3
 154               	.global	__fixunssfsi
 155               	.global	_LPP_setParamMacro
 157               	_LPP_setParamMacro:
 158               	.LFB9:
 124:src/light_pattern_protocol.c **** 
 125:src/light_pattern_protocol.c **** void _LPP_processParameterUpdate(LightProtocolParameter param, int start, char* buffer) {
 126:src/light_pattern_protocol.c **** 
 127:src/light_pattern_protocol.c ****     // validate arguments
 128:src/light_pattern_protocol.c ****     if (!buffer) return;
 129:src/light_pattern_protocol.c **** 
 130:src/light_pattern_protocol.c ****     // temp storage variables to reduce calculations
 131:src/light_pattern_protocol.c ****     // in each case statement
 132:src/light_pattern_protocol.c ****     uint16_t received_uint;
 133:src/light_pattern_protocol.c ****     uint16_t received_uint_radians;
 134:src/light_pattern_protocol.c ****     
 135:src/light_pattern_protocol.c ****     switch(param) {
 136:src/light_pattern_protocol.c **** 
 137:src/light_pattern_protocol.c ****         case PARAM_BIAS_RED: 
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 6


 138:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->bias = buffer[start];
 139:src/light_pattern_protocol.c ****             break;
 140:src/light_pattern_protocol.c **** 
 141:src/light_pattern_protocol.c ****         case PARAM_BIAS_GREEN: 
 142:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->bias = buffer[start];
 143:src/light_pattern_protocol.c ****             break;
 144:src/light_pattern_protocol.c **** 
 145:src/light_pattern_protocol.c ****         case PARAM_BIAS_BLUE: 
 146:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->bias = buffer[start];
 147:src/light_pattern_protocol.c ****             break;
 148:src/light_pattern_protocol.c **** 
 149:src/light_pattern_protocol.c ****         case PARAM_AMPLITUDE_RED: 
 150:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->amplitude = buffer[start];
 151:src/light_pattern_protocol.c ****             break;
 152:src/light_pattern_protocol.c **** 
 153:src/light_pattern_protocol.c ****         case PARAM_AMPLITUDE_GREEN: 
 154:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->amplitude = buffer[start];
 155:src/light_pattern_protocol.c ****             break;
 156:src/light_pattern_protocol.c **** 
 157:src/light_pattern_protocol.c ****         case PARAM_AMPLITUDE_BLUE: 
 158:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->amplitude = buffer[start];
 159:src/light_pattern_protocol.c ****             break;
 160:src/light_pattern_protocol.c **** 
 161:src/light_pattern_protocol.c ****         case PARAM_PERIOD: 
 162:src/light_pattern_protocol.c ****             received_uint = UTIL_charToInt(buffer[start], buffer[start+1]);
 163:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->speed    = MAX_PATTERN_PERIOD / received_uint;
 164:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->speed  = MAX_PATTERN_PERIOD / received_uint;
 165:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->speed   = MAX_PATTERN_PERIOD / received_uint;
 166:src/light_pattern_protocol.c ****             break;
 167:src/light_pattern_protocol.c **** 
 168:src/light_pattern_protocol.c ****         case PARAM_REPEAT: 
 169:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->cyclesRemaining    = buffer[start];
 170:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->cyclesRemaining  = buffer[start];
 171:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->cyclesRemaining   = buffer[start];
 172:src/light_pattern_protocol.c ****             break;
 173:src/light_pattern_protocol.c **** 
 174:src/light_pattern_protocol.c ****         case PARAM_PHASEOFFSET: 
 175:src/light_pattern_protocol.c ****             received_uint_radians = UTIL_degToRad(UTIL_charToInt(buffer[start], buffer[start+1]));
 176:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->phase    = received_uint_radians;
 177:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->phase  = received_uint_radians;
 178:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->phase   = received_uint_radians;
 179:src/light_pattern_protocol.c ****             break;
 180:src/light_pattern_protocol.c **** 
 181:src/light_pattern_protocol.c ****         case PARAM_MACRO:
 182:src/light_pattern_protocol.c ****             if (buffer[start] < PARAM_MACRO_ENUM_COUNT)
 183:src/light_pattern_protocol.c ****                 _LPP_setParamMacro(buffer[start]);
 184:src/light_pattern_protocol.c ****             break;
 185:src/light_pattern_protocol.c **** 
 186:src/light_pattern_protocol.c ****         default:
 187:src/light_pattern_protocol.c ****             break;
 188:src/light_pattern_protocol.c ****     }
 189:src/light_pattern_protocol.c **** 
 190:src/light_pattern_protocol.c **** }
 191:src/light_pattern_protocol.c **** 
 192:src/light_pattern_protocol.c **** // Pre-canned patterns and setting combinations
 193:src/light_pattern_protocol.c **** // tuned through testing on lighting hardware
 194:src/light_pattern_protocol.c **** void _LPP_setParamMacro(LightParamMacro macro) {
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 7


 159               		.loc 1 194 0
 160               		.cfi_startproc
 161               	.LVL4:
 162 0082 EF92      		push r14
 163               	.LCFI2:
 164               		.cfi_def_cfa_offset 3
 165               		.cfi_offset 14, -2
 166 0084 FF92      		push r15
 167               	.LCFI3:
 168               		.cfi_def_cfa_offset 4
 169               		.cfi_offset 15, -3
 170 0086 0F93      		push r16
 171               	.LCFI4:
 172               		.cfi_def_cfa_offset 5
 173               		.cfi_offset 16, -4
 174 0088 1F93      		push r17
 175               	.LCFI5:
 176               		.cfi_def_cfa_offset 6
 177               		.cfi_offset 17, -5
 178 008a CF93      		push r28
 179               	.LCFI6:
 180               		.cfi_def_cfa_offset 7
 181               		.cfi_offset 28, -6
 182 008c DF93      		push r29
 183               	.LCFI7:
 184               		.cfi_def_cfa_offset 8
 185               		.cfi_offset 29, -7
 186               	/* prologue: function */
 187               	/* frame size = 0 */
 188               	/* stack size = 6 */
 189               	.L__stack_usage = 6
 195:src/light_pattern_protocol.c **** 
 196:src/light_pattern_protocol.c ****     switch(macro) {
 190               		.loc 1 196 0
 191 008e 8B30      		cpi r24,11
 192 0090 9105      		cpc r25,__zero_reg__
 193 0092 00F0      		brlo .+2
 194 0094 00C0      		rjmp .L8
 195 0096 FC01      		movw r30,r24
 196 0098 E050      		subi r30,lo8(-(gs(.L11)))
 197 009a F040      		sbci r31,hi8(-(gs(.L11)))
 198 009c C091 0000 		lds r28,_self_pattern_protocol+1
 199 00a0 D091 0000 		lds r29,_self_pattern_protocol+1+1
 200 00a4 0994      		ijmp
 201               		.section	.progmem.gcc_sw_table,"ax",@progbits
 202               		.p2align	1
 203               	.L11:
 204 0000 00C0      		rjmp .L10
 205 0002 00C0      		rjmp .L12
 206 0004 00C0      		rjmp .L13
 207 0006 00C0      		rjmp .L14
 208 0008 00C0      		rjmp .L15
 209 000a 00C0      		rjmp .L16
 210 000c 00C0      		rjmp .L17
 211 000e 00C0      		rjmp .L18
 212 0010 00C0      		rjmp .L19
 213 0012 00C0      		rjmp .L20
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 8


 214 0014 00C0      		rjmp .L21
 215               		.text
 216               	.L12:
 197:src/light_pattern_protocol.c **** 
 198:src/light_pattern_protocol.c ****         case PARAM_MACRO_FWUPDATE:
 199:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->cyclesRemaining      = CYCLES_INFINITE;
 217               		.loc 1 199 0
 218 00a6 8EEF      		ldi r24,lo8(-2)
 219               	.LVL5:
 220 00a8 8C83      		std Y+4,r24
 200:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->cyclesRemaining    = CYCLES_INFINITE;
 221               		.loc 1 200 0
 222 00aa E090 0000 		lds r14,_self_pattern_protocol+3
 223 00ae F090 0000 		lds r15,_self_pattern_protocol+3+1
 224 00b2 F701      		movw r30,r14
 225 00b4 8483      		std Z+4,r24
 201:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->cyclesRemaining     = CYCLES_INFINITE;
 226               		.loc 1 201 0
 227 00b6 0091 0000 		lds r16,_self_pattern_protocol+5
 228 00ba 1091 0000 		lds r17,_self_pattern_protocol+5+1
 229 00be F801      		movw r30,r16
 230 00c0 8483      		std Z+4,r24
 202:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->speed                = 1;
 231               		.loc 1 202 0
 232 00c2 40E0      		ldi r20,0
 233 00c4 50E0      		ldi r21,0
 234 00c6 60E8      		ldi r22,lo8(-128)
 235 00c8 7FE3      		ldi r23,lo8(63)
 236 00ca 4987      		std Y+9,r20
 237 00cc 5A87      		std Y+10,r21
 238 00ce 6B87      		std Y+11,r22
 239 00d0 7C87      		std Y+12,r23
 203:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->speed              = 1;
 240               		.loc 1 203 0
 241 00d2 F701      		movw r30,r14
 242 00d4 4187      		std Z+9,r20
 243 00d6 5287      		std Z+10,r21
 244 00d8 6387      		std Z+11,r22
 245 00da 7487      		std Z+12,r23
 204:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->speed               = 1;
 246               		.loc 1 204 0
 247 00dc F801      		movw r30,r16
 248 00de 4187      		std Z+9,r20
 249 00e0 5287      		std Z+10,r21
 250 00e2 6387      		std Z+11,r22
 251 00e4 7487      		std Z+12,r23
 252               	.LVL6:
 205:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->phase                += UTIL_degToRad(270);
 253               		.loc 1 205 0
 254 00e6 6D85      		ldd r22,Y+13
 255 00e8 7E85      		ldd r23,Y+14
 256 00ea 80E0      		ldi r24,0
 257 00ec 90E0      		ldi r25,0
 258 00ee 00D0      		rcall __floatunsisf
 259               	.LVL7:
 260 00f0 24EE      		ldi r18,lo8(-28)
 261 00f2 3BEC      		ldi r19,lo8(-53)
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 9


 262 00f4 46E9      		ldi r20,lo8(-106)
 263 00f6 50E4      		ldi r21,lo8(64)
 264 00f8 00D0      		rcall __addsf3
 265               	.LVL8:
 266 00fa 00D0      		rcall __fixunssfsi
 267               	.LVL9:
 268 00fc 7E87      		std Y+14,r23
 269 00fe 6D87      		std Y+13,r22
 270               	.LVL10:
 206:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->phase              += UTIL_degToRad(90);
 271               		.loc 1 206 0
 272 0100 F701      		movw r30,r14
 273 0102 6585      		ldd r22,Z+13
 274 0104 7685      		ldd r23,Z+14
 275 0106 80E0      		ldi r24,0
 276 0108 90E0      		ldi r25,0
 277 010a 00D0      		rcall __floatunsisf
 278               	.LVL11:
 279 010c 2BED      		ldi r18,lo8(-37)
 280 010e 3FE0      		ldi r19,lo8(15)
 281 0110 49EC      		ldi r20,lo8(-55)
 282 0112 5FE3      		ldi r21,lo8(63)
 283 0114 00D0      		rcall __addsf3
 284               	.LVL12:
 285 0116 00D0      		rcall __fixunssfsi
 286               	.LVL13:
 287 0118 F701      		movw r30,r14
 288 011a 7687      		std Z+14,r23
 289 011c 6587      		std Z+13,r22
 290               	.LVL14:
 207:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->phase               += UTIL_degToRad(180);
 291               		.loc 1 207 0
 292 011e F801      		movw r30,r16
 293 0120 6585      		ldd r22,Z+13
 294 0122 7685      		ldd r23,Z+14
 295 0124 80E0      		ldi r24,0
 296 0126 90E0      		ldi r25,0
 297 0128 00D0      		rcall __floatunsisf
 298               	.LVL15:
 299 012a 2BED      		ldi r18,lo8(-37)
 300 012c 3FE0      		ldi r19,lo8(15)
 301 012e 49E4      		ldi r20,lo8(73)
 302 0130 50E4      		ldi r21,lo8(64)
 303 0132 00D0      		rcall __addsf3
 304               	.LVL16:
 305 0134 00D0      		rcall __fixunssfsi
 306               	.LVL17:
 307 0136 F801      		movw r30,r16
 308 0138 7687      		std Z+14,r23
 309 013a 6587      		std Z+13,r22
 208:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->amplitude            = 120;
 310               		.loc 1 208 0
 311 013c 80E0      		ldi r24,0
 312 013e 90E0      		ldi r25,0
 313 0140 A0EF      		ldi r26,lo8(-16)
 314 0142 B2E4      		ldi r27,lo8(66)
 315 0144 8F87      		std Y+15,r24
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 10


 316 0146 988B      		std Y+16,r25
 317 0148 A98B      		std Y+17,r26
 318 014a BA8B      		std Y+18,r27
 209:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->bias                 = 120;
 319               		.loc 1 209 0
 320 014c 8B8B      		std Y+19,r24
 321 014e 9C8B      		std Y+20,r25
 322 0150 AD8B      		std Y+21,r26
 323 0152 BE8B      		std Y+22,r27
 210:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->amplitude          = 50;
 324               		.loc 1 210 0
 325 0154 80E0      		ldi r24,0
 326 0156 90E0      		ldi r25,0
 327 0158 A8E4      		ldi r26,lo8(72)
 328 015a B2E4      		ldi r27,lo8(66)
 329 015c F701      		movw r30,r14
 330 015e 8787      		std Z+15,r24
 331 0160 908B      		std Z+16,r25
 332 0162 A18B      		std Z+17,r26
 333 0164 B28B      		std Z+18,r27
 211:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->bias               = 50;
 334               		.loc 1 211 0
 335 0166 838B      		std Z+19,r24
 336 0168 948B      		std Z+20,r25
 337 016a A58B      		std Z+21,r26
 338 016c B68B      		std Z+22,r27
 212:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->amplitude           = 70;
 339               		.loc 1 212 0
 340 016e 80E0      		ldi r24,0
 341 0170 90E0      		ldi r25,0
 342 0172 ACE8      		ldi r26,lo8(-116)
 343 0174 B2E4      		ldi r27,lo8(66)
 344 0176 F801      		movw r30,r16
 345 0178 8787      		std Z+15,r24
 346 017a 908B      		std Z+16,r25
 347 017c A18B      		std Z+17,r26
 348 017e B28B      		std Z+18,r27
 213:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->bias                = 70;
 349               		.loc 1 213 0
 350 0180 838B      		std Z+19,r24
 351 0182 948B      		std Z+20,r25
 352 0184 A58B      		std Z+21,r26
 353 0186 B68B      		std Z+22,r27
 354 0188 00C0      		rjmp .L25
 355               	.LVL18:
 356               	.L13:
 214:src/light_pattern_protocol.c ****             _LPP_setPattern(PATTERN_SINE);
 215:src/light_pattern_protocol.c ****             break;
 216:src/light_pattern_protocol.c ****             
 217:src/light_pattern_protocol.c ****         case PARAM_MACRO_AUTOPILOT:
 218:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->cyclesRemaining      = CYCLES_INFINITE;
 357               		.loc 1 218 0
 358 018a 8EEF      		ldi r24,lo8(-2)
 359               	.LVL19:
 360 018c 8C83      		std Y+4,r24
 219:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->cyclesRemaining    = CYCLES_INFINITE;
 361               		.loc 1 219 0
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 11


 362 018e A091 0000 		lds r26,_self_pattern_protocol+3
 363 0192 B091 0000 		lds r27,_self_pattern_protocol+3+1
 364 0196 1496      		adiw r26,4
 365 0198 8C93      		st X,r24
 366 019a 1497      		sbiw r26,4
 220:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->cyclesRemaining     = CYCLES_INFINITE;
 367               		.loc 1 220 0
 368 019c E091 0000 		lds r30,_self_pattern_protocol+5
 369 01a0 F091 0000 		lds r31,_self_pattern_protocol+5+1
 370 01a4 8483      		std Z+4,r24
 221:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->speed                = 1;
 371               		.loc 1 221 0
 372 01a6 40E0      		ldi r20,0
 373 01a8 50E0      		ldi r21,0
 374 01aa 60E8      		ldi r22,lo8(-128)
 375 01ac 7FE3      		ldi r23,lo8(63)
 376 01ae 4987      		std Y+9,r20
 377 01b0 5A87      		std Y+10,r21
 378 01b2 6B87      		std Y+11,r22
 379 01b4 7C87      		std Y+12,r23
 222:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->speed              = 1;
 380               		.loc 1 222 0
 381 01b6 1996      		adiw r26,9
 382 01b8 4D93      		st X+,r20
 383 01ba 5D93      		st X+,r21
 384 01bc 6D93      		st X+,r22
 385 01be 7C93      		st X,r23
 386 01c0 1C97      		sbiw r26,9+3
 223:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->speed               = 1;
 387               		.loc 1 223 0
 388 01c2 4187      		std Z+9,r20
 389 01c4 5287      		std Z+10,r21
 390 01c6 6387      		std Z+11,r22
 391 01c8 7487      		std Z+12,r23
 392               	.L25:
 224:src/light_pattern_protocol.c ****             _LPP_setPattern(PATTERN_SINE);
 393               		.loc 1 224 0
 394 01ca 81E0      		ldi r24,lo8(1)
 395 01cc 90E0      		ldi r25,0
 396               	.L26:
 397               	/* epilogue start */
 225:src/light_pattern_protocol.c ****             break;
 226:src/light_pattern_protocol.c ****             
 227:src/light_pattern_protocol.c ****         case PARAM_MACRO_CALIBRATE:
 228:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->cyclesRemaining      = CYCLES_INFINITE;
 229:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->cyclesRemaining    = CYCLES_INFINITE;
 230:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->cyclesRemaining     = CYCLES_INFINITE;
 231:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->speed                = 12;
 232:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->speed              = 12;
 233:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->speed               = 12;
 234:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->bias                 = 0;
 235:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->bias               = 0;
 236:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->bias                = 0;
 237:src/light_pattern_protocol.c ****             _LPP_setPattern(PATTERN_STROBE);
 238:src/light_pattern_protocol.c ****             break;
 239:src/light_pattern_protocol.c ****             
 240:src/light_pattern_protocol.c ****         case PARAM_MACRO_POWERON:
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 12


 241:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->cyclesRemaining      = 1;
 242:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->cyclesRemaining    = 1;
 243:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->cyclesRemaining     = 1;
 244:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->speed                = 1;
 245:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->speed              = 1;
 246:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->speed               = 1;
 247:src/light_pattern_protocol.c ****             _LPP_setPattern(PATTERN_FADEIN);
 248:src/light_pattern_protocol.c ****             break;
 249:src/light_pattern_protocol.c ****             
 250:src/light_pattern_protocol.c ****         case PARAM_MACRO_POWEROFF:
 251:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->cyclesRemaining      = 1;
 252:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->cyclesRemaining    = 1;
 253:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->cyclesRemaining     = 1;
 254:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->speed                = 1;
 255:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->speed              = 1;
 256:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->speed               = 1;
 257:src/light_pattern_protocol.c ****             _LPP_setPattern(PATTERN_FADEOUT);
 258:src/light_pattern_protocol.c ****             break;
 259:src/light_pattern_protocol.c ****             
 260:src/light_pattern_protocol.c ****         case PARAM_MACRO_RED:
 261:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->amplitude            = 115;
 262:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->bias                 = 120;
 263:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->amplitude          = 0;
 264:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->bias               = 0;
 265:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->amplitude           = 0;
 266:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->bias                = 0;
 267:src/light_pattern_protocol.c ****             break;
 268:src/light_pattern_protocol.c ****             
 269:src/light_pattern_protocol.c ****         case PARAM_MACRO_GREEN:
 270:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->amplitude            = 0;
 271:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->bias                 = 0;
 272:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->amplitude          = 115;
 273:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->bias               = 120;
 274:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->amplitude           = 0;
 275:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->bias                = 0;
 276:src/light_pattern_protocol.c ****             break;
 277:src/light_pattern_protocol.c ****             
 278:src/light_pattern_protocol.c ****         case PARAM_MACRO_BLUE:
 279:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->amplitude            = 0;
 280:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->bias                 = 0;
 281:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->amplitude          = 0;
 282:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->bias               = 0;
 283:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->amplitude           = 115;
 284:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->bias                = 120;
 285:src/light_pattern_protocol.c ****             break;
 286:src/light_pattern_protocol.c ****             
 287:src/light_pattern_protocol.c ****         case PARAM_MACRO_AMBER:
 288:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->amplitude            = 115;
 289:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->bias                 = 120;
 290:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->amplitude          = 45;
 291:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->bias               = 50;
 292:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->amplitude           = 0;
 293:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->bias                = 0;
 294:src/light_pattern_protocol.c ****             break;
 295:src/light_pattern_protocol.c ****             
 296:src/light_pattern_protocol.c ****         case PARAM_MACRO_WHITE:
 297:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->amplitude            = 115;
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 13


 298:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->bias                 = 120;
 299:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->amplitude          = 95;
 300:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->bias               = 100;
 301:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->amplitude           = 27;
 302:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->bias                = 30;
 303:src/light_pattern_protocol.c ****             break;
 304:src/light_pattern_protocol.c **** 
 305:src/light_pattern_protocol.c ****         case PARAM_MACRO_RESET:
 306:src/light_pattern_protocol.c ****             PG_init(_self_pattern_protocol.redPattern);
 307:src/light_pattern_protocol.c ****             PG_init(_self_pattern_protocol.greenPattern);
 308:src/light_pattern_protocol.c ****             PG_init(_self_pattern_protocol.bluePattern);
 309:src/light_pattern_protocol.c ****             break;
 310:src/light_pattern_protocol.c **** 
 311:src/light_pattern_protocol.c ****         default:
 312:src/light_pattern_protocol.c ****             break;
 313:src/light_pattern_protocol.c **** 
 314:src/light_pattern_protocol.c ****     }
 315:src/light_pattern_protocol.c **** 
 316:src/light_pattern_protocol.c **** }
 398               		.loc 1 316 0
 399 01ce DF91      		pop r29
 400 01d0 CF91      		pop r28
 401 01d2 1F91      		pop r17
 402 01d4 0F91      		pop r16
 403 01d6 FF90      		pop r15
 404 01d8 EF90      		pop r14
 224:src/light_pattern_protocol.c ****             _LPP_setPattern(PATTERN_SINE);
 405               		.loc 1 224 0
 406 01da 00C0      		rjmp _LPP_setPattern
 407               	.LVL20:
 408               	.L14:
 228:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->cyclesRemaining      = CYCLES_INFINITE;
 409               		.loc 1 228 0
 410 01dc 8EEF      		ldi r24,lo8(-2)
 411               	.LVL21:
 412 01de 8C83      		std Y+4,r24
 229:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->cyclesRemaining    = CYCLES_INFINITE;
 413               		.loc 1 229 0
 414 01e0 A091 0000 		lds r26,_self_pattern_protocol+3
 415 01e4 B091 0000 		lds r27,_self_pattern_protocol+3+1
 416 01e8 1496      		adiw r26,4
 417 01ea 8C93      		st X,r24
 418 01ec 1497      		sbiw r26,4
 230:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->cyclesRemaining     = CYCLES_INFINITE;
 419               		.loc 1 230 0
 420 01ee E091 0000 		lds r30,_self_pattern_protocol+5
 421 01f2 F091 0000 		lds r31,_self_pattern_protocol+5+1
 422 01f6 8483      		std Z+4,r24
 231:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->speed                = 12;
 423               		.loc 1 231 0
 424 01f8 40E0      		ldi r20,0
 425 01fa 50E0      		ldi r21,0
 426 01fc 60E4      		ldi r22,lo8(64)
 427 01fe 71E4      		ldi r23,lo8(65)
 428 0200 4987      		std Y+9,r20
 429 0202 5A87      		std Y+10,r21
 430 0204 6B87      		std Y+11,r22
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 14


 431 0206 7C87      		std Y+12,r23
 232:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->speed              = 12;
 432               		.loc 1 232 0
 433 0208 1996      		adiw r26,9
 434 020a 4D93      		st X+,r20
 435 020c 5D93      		st X+,r21
 436 020e 6D93      		st X+,r22
 437 0210 7C93      		st X,r23
 438 0212 1C97      		sbiw r26,9+3
 233:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->speed               = 12;
 439               		.loc 1 233 0
 440 0214 4187      		std Z+9,r20
 441 0216 5287      		std Z+10,r21
 442 0218 6387      		std Z+11,r22
 443 021a 7487      		std Z+12,r23
 234:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->bias                 = 0;
 444               		.loc 1 234 0
 445 021c 1B8A      		std Y+19,__zero_reg__
 446 021e 1C8A      		std Y+20,__zero_reg__
 447 0220 1D8A      		std Y+21,__zero_reg__
 448 0222 1E8A      		std Y+22,__zero_reg__
 235:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->bias               = 0;
 449               		.loc 1 235 0
 450 0224 5396      		adiw r26,19
 451 0226 1D92      		st X+,__zero_reg__
 452 0228 1D92      		st X+,__zero_reg__
 453 022a 1D92      		st X+,__zero_reg__
 454 022c 1C92      		st X,__zero_reg__
 455 022e 5697      		sbiw r26,19+3
 236:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->bias                = 0;
 456               		.loc 1 236 0
 457 0230 138A      		std Z+19,__zero_reg__
 458 0232 148A      		std Z+20,__zero_reg__
 459 0234 158A      		std Z+21,__zero_reg__
 460 0236 168A      		std Z+22,__zero_reg__
 237:src/light_pattern_protocol.c ****             _LPP_setPattern(PATTERN_STROBE);
 461               		.loc 1 237 0
 462 0238 84E0      		ldi r24,lo8(4)
 463 023a 90E0      		ldi r25,0
 464 023c 00C0      		rjmp .L26
 465               	.LVL22:
 466               	.L15:
 241:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->cyclesRemaining      = 1;
 467               		.loc 1 241 0
 468 023e 81E0      		ldi r24,lo8(1)
 469               	.LVL23:
 470 0240 8C83      		std Y+4,r24
 242:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->cyclesRemaining    = 1;
 471               		.loc 1 242 0
 472 0242 A091 0000 		lds r26,_self_pattern_protocol+3
 473 0246 B091 0000 		lds r27,_self_pattern_protocol+3+1
 474 024a 1496      		adiw r26,4
 475 024c 8C93      		st X,r24
 476 024e 1497      		sbiw r26,4
 243:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->cyclesRemaining     = 1;
 477               		.loc 1 243 0
 478 0250 E091 0000 		lds r30,_self_pattern_protocol+5
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 15


 479 0254 F091 0000 		lds r31,_self_pattern_protocol+5+1
 480 0258 8483      		std Z+4,r24
 244:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->speed                = 1;
 481               		.loc 1 244 0
 482 025a 40E0      		ldi r20,0
 483 025c 50E0      		ldi r21,0
 484 025e 60E8      		ldi r22,lo8(-128)
 485 0260 7FE3      		ldi r23,lo8(63)
 486 0262 4987      		std Y+9,r20
 487 0264 5A87      		std Y+10,r21
 488 0266 6B87      		std Y+11,r22
 489 0268 7C87      		std Y+12,r23
 245:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->speed              = 1;
 490               		.loc 1 245 0
 491 026a 1996      		adiw r26,9
 492 026c 4D93      		st X+,r20
 493 026e 5D93      		st X+,r21
 494 0270 6D93      		st X+,r22
 495 0272 7C93      		st X,r23
 496 0274 1C97      		sbiw r26,9+3
 246:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->speed               = 1;
 497               		.loc 1 246 0
 498 0276 4187      		std Z+9,r20
 499 0278 5287      		std Z+10,r21
 500 027a 6387      		std Z+11,r22
 501 027c 7487      		std Z+12,r23
 247:src/light_pattern_protocol.c ****             _LPP_setPattern(PATTERN_FADEIN);
 502               		.loc 1 247 0
 503 027e 85E0      		ldi r24,lo8(5)
 504 0280 90E0      		ldi r25,0
 505 0282 00C0      		rjmp .L26
 506               	.LVL24:
 507               	.L16:
 251:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->cyclesRemaining      = 1;
 508               		.loc 1 251 0
 509 0284 81E0      		ldi r24,lo8(1)
 510               	.LVL25:
 511 0286 8C83      		std Y+4,r24
 252:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->cyclesRemaining    = 1;
 512               		.loc 1 252 0
 513 0288 A091 0000 		lds r26,_self_pattern_protocol+3
 514 028c B091 0000 		lds r27,_self_pattern_protocol+3+1
 515 0290 1496      		adiw r26,4
 516 0292 8C93      		st X,r24
 517 0294 1497      		sbiw r26,4
 253:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->cyclesRemaining     = 1;
 518               		.loc 1 253 0
 519 0296 E091 0000 		lds r30,_self_pattern_protocol+5
 520 029a F091 0000 		lds r31,_self_pattern_protocol+5+1
 521 029e 8483      		std Z+4,r24
 254:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->speed                = 1;
 522               		.loc 1 254 0
 523 02a0 40E0      		ldi r20,0
 524 02a2 50E0      		ldi r21,0
 525 02a4 60E8      		ldi r22,lo8(-128)
 526 02a6 7FE3      		ldi r23,lo8(63)
 527 02a8 4987      		std Y+9,r20
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 16


 528 02aa 5A87      		std Y+10,r21
 529 02ac 6B87      		std Y+11,r22
 530 02ae 7C87      		std Y+12,r23
 255:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->speed              = 1;
 531               		.loc 1 255 0
 532 02b0 1996      		adiw r26,9
 533 02b2 4D93      		st X+,r20
 534 02b4 5D93      		st X+,r21
 535 02b6 6D93      		st X+,r22
 536 02b8 7C93      		st X,r23
 537 02ba 1C97      		sbiw r26,9+3
 256:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->speed               = 1;
 538               		.loc 1 256 0
 539 02bc 4187      		std Z+9,r20
 540 02be 5287      		std Z+10,r21
 541 02c0 6387      		std Z+11,r22
 542 02c2 7487      		std Z+12,r23
 257:src/light_pattern_protocol.c ****             _LPP_setPattern(PATTERN_FADEOUT);
 543               		.loc 1 257 0
 544 02c4 86E0      		ldi r24,lo8(6)
 545 02c6 90E0      		ldi r25,0
 546 02c8 00C0      		rjmp .L26
 547               	.LVL26:
 548               	.L17:
 261:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->amplitude            = 115;
 549               		.loc 1 261 0
 550 02ca 80E0      		ldi r24,0
 551 02cc 90E0      		ldi r25,0
 552 02ce A6EE      		ldi r26,lo8(-26)
 553 02d0 B2E4      		ldi r27,lo8(66)
 554               	.LVL27:
 555 02d2 8F87      		std Y+15,r24
 556 02d4 988B      		std Y+16,r25
 557 02d6 A98B      		std Y+17,r26
 558 02d8 BA8B      		std Y+18,r27
 262:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->bias                 = 120;
 559               		.loc 1 262 0
 560 02da 80E0      		ldi r24,0
 561 02dc 90E0      		ldi r25,0
 562 02de A0EF      		ldi r26,lo8(-16)
 563 02e0 B2E4      		ldi r27,lo8(66)
 564 02e2 8B8B      		std Y+19,r24
 565 02e4 9C8B      		std Y+20,r25
 566 02e6 AD8B      		std Y+21,r26
 567 02e8 BE8B      		std Y+22,r27
 263:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->amplitude          = 0;
 568               		.loc 1 263 0
 569 02ea E091 0000 		lds r30,_self_pattern_protocol+3
 570 02ee F091 0000 		lds r31,_self_pattern_protocol+3+1
 571 02f2 1786      		std Z+15,__zero_reg__
 572 02f4 108A      		std Z+16,__zero_reg__
 573 02f6 118A      		std Z+17,__zero_reg__
 574 02f8 128A      		std Z+18,__zero_reg__
 264:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->bias               = 0;
 575               		.loc 1 264 0
 576 02fa 138A      		std Z+19,__zero_reg__
 577 02fc 148A      		std Z+20,__zero_reg__
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 17


 578 02fe 158A      		std Z+21,__zero_reg__
 579 0300 168A      		std Z+22,__zero_reg__
 580 0302 00C0      		rjmp .L23
 581               	.LVL28:
 582               	.L18:
 270:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->amplitude            = 0;
 583               		.loc 1 270 0
 584 0304 1F86      		std Y+15,__zero_reg__
 585 0306 188A      		std Y+16,__zero_reg__
 586 0308 198A      		std Y+17,__zero_reg__
 587 030a 1A8A      		std Y+18,__zero_reg__
 271:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->bias                 = 0;
 588               		.loc 1 271 0
 589 030c 1B8A      		std Y+19,__zero_reg__
 590 030e 1C8A      		std Y+20,__zero_reg__
 591 0310 1D8A      		std Y+21,__zero_reg__
 592 0312 1E8A      		std Y+22,__zero_reg__
 272:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->amplitude          = 115;
 593               		.loc 1 272 0
 594 0314 E091 0000 		lds r30,_self_pattern_protocol+3
 595 0318 F091 0000 		lds r31,_self_pattern_protocol+3+1
 596 031c 80E0      		ldi r24,0
 597 031e 90E0      		ldi r25,0
 598 0320 A6EE      		ldi r26,lo8(-26)
 599 0322 B2E4      		ldi r27,lo8(66)
 600               	.LVL29:
 601 0324 8787      		std Z+15,r24
 602 0326 908B      		std Z+16,r25
 603 0328 A18B      		std Z+17,r26
 604 032a B28B      		std Z+18,r27
 273:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->bias               = 120;
 605               		.loc 1 273 0
 606 032c 80E0      		ldi r24,0
 607 032e 90E0      		ldi r25,0
 608 0330 A0EF      		ldi r26,lo8(-16)
 609 0332 B2E4      		ldi r27,lo8(66)
 610 0334 00C0      		rjmp .L24
 611               	.LVL30:
 612               	.L19:
 279:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->amplitude            = 0;
 613               		.loc 1 279 0
 614 0336 1F86      		std Y+15,__zero_reg__
 615 0338 188A      		std Y+16,__zero_reg__
 616 033a 198A      		std Y+17,__zero_reg__
 617 033c 1A8A      		std Y+18,__zero_reg__
 280:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->bias                 = 0;
 618               		.loc 1 280 0
 619 033e 1B8A      		std Y+19,__zero_reg__
 620 0340 1C8A      		std Y+20,__zero_reg__
 621 0342 1D8A      		std Y+21,__zero_reg__
 622 0344 1E8A      		std Y+22,__zero_reg__
 281:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->amplitude          = 0;
 623               		.loc 1 281 0
 624 0346 E091 0000 		lds r30,_self_pattern_protocol+3
 625 034a F091 0000 		lds r31,_self_pattern_protocol+3+1
 626 034e 1786      		std Z+15,__zero_reg__
 627 0350 108A      		std Z+16,__zero_reg__
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 18


 628 0352 118A      		std Z+17,__zero_reg__
 629 0354 128A      		std Z+18,__zero_reg__
 282:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->bias               = 0;
 630               		.loc 1 282 0
 631 0356 138A      		std Z+19,__zero_reg__
 632 0358 148A      		std Z+20,__zero_reg__
 633 035a 158A      		std Z+21,__zero_reg__
 634 035c 168A      		std Z+22,__zero_reg__
 283:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->amplitude           = 115;
 635               		.loc 1 283 0
 636 035e E091 0000 		lds r30,_self_pattern_protocol+5
 637 0362 F091 0000 		lds r31,_self_pattern_protocol+5+1
 638 0366 80E0      		ldi r24,0
 639 0368 90E0      		ldi r25,0
 640 036a A6EE      		ldi r26,lo8(-26)
 641 036c B2E4      		ldi r27,lo8(66)
 642               	.LVL31:
 643 036e 8787      		std Z+15,r24
 644 0370 908B      		std Z+16,r25
 645 0372 A18B      		std Z+17,r26
 646 0374 B28B      		std Z+18,r27
 284:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->bias                = 120;
 647               		.loc 1 284 0
 648 0376 80E0      		ldi r24,0
 649 0378 90E0      		ldi r25,0
 650 037a A0EF      		ldi r26,lo8(-16)
 651 037c B2E4      		ldi r27,lo8(66)
 652 037e 00C0      		rjmp .L22
 653               	.LVL32:
 654               	.L20:
 288:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->amplitude            = 115;
 655               		.loc 1 288 0
 656 0380 80E0      		ldi r24,0
 657 0382 90E0      		ldi r25,0
 658 0384 A6EE      		ldi r26,lo8(-26)
 659 0386 B2E4      		ldi r27,lo8(66)
 660               	.LVL33:
 661 0388 8F87      		std Y+15,r24
 662 038a 988B      		std Y+16,r25
 663 038c A98B      		std Y+17,r26
 664 038e BA8B      		std Y+18,r27
 289:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->bias                 = 120;
 665               		.loc 1 289 0
 666 0390 80E0      		ldi r24,0
 667 0392 90E0      		ldi r25,0
 668 0394 A0EF      		ldi r26,lo8(-16)
 669 0396 B2E4      		ldi r27,lo8(66)
 670 0398 8B8B      		std Y+19,r24
 671 039a 9C8B      		std Y+20,r25
 672 039c AD8B      		std Y+21,r26
 673 039e BE8B      		std Y+22,r27
 290:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->amplitude          = 45;
 674               		.loc 1 290 0
 675 03a0 E091 0000 		lds r30,_self_pattern_protocol+3
 676 03a4 F091 0000 		lds r31,_self_pattern_protocol+3+1
 677 03a8 80E0      		ldi r24,0
 678 03aa 90E0      		ldi r25,0
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 19


 679 03ac A4E3      		ldi r26,lo8(52)
 680 03ae B2E4      		ldi r27,lo8(66)
 681 03b0 8787      		std Z+15,r24
 682 03b2 908B      		std Z+16,r25
 683 03b4 A18B      		std Z+17,r26
 684 03b6 B28B      		std Z+18,r27
 291:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->bias               = 50;
 685               		.loc 1 291 0
 686 03b8 80E0      		ldi r24,0
 687 03ba 90E0      		ldi r25,0
 688 03bc A8E4      		ldi r26,lo8(72)
 689 03be B2E4      		ldi r27,lo8(66)
 690               	.L24:
 691 03c0 838B      		std Z+19,r24
 692 03c2 948B      		std Z+20,r25
 693 03c4 A58B      		std Z+21,r26
 694 03c6 B68B      		std Z+22,r27
 695               	.L23:
 292:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->amplitude           = 0;
 696               		.loc 1 292 0
 697 03c8 E091 0000 		lds r30,_self_pattern_protocol+5
 698 03cc F091 0000 		lds r31,_self_pattern_protocol+5+1
 699 03d0 1786      		std Z+15,__zero_reg__
 700 03d2 108A      		std Z+16,__zero_reg__
 701 03d4 118A      		std Z+17,__zero_reg__
 702 03d6 128A      		std Z+18,__zero_reg__
 293:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->bias                = 0;
 703               		.loc 1 293 0
 704 03d8 138A      		std Z+19,__zero_reg__
 705 03da 148A      		std Z+20,__zero_reg__
 706 03dc 158A      		std Z+21,__zero_reg__
 707 03de 168A      		std Z+22,__zero_reg__
 294:src/light_pattern_protocol.c ****             break;
 708               		.loc 1 294 0
 709 03e0 00C0      		rjmp .L8
 710               	.LVL34:
 711               	.L21:
 297:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->amplitude            = 115;
 712               		.loc 1 297 0
 713 03e2 80E0      		ldi r24,0
 714 03e4 90E0      		ldi r25,0
 715 03e6 A6EE      		ldi r26,lo8(-26)
 716 03e8 B2E4      		ldi r27,lo8(66)
 717               	.LVL35:
 718 03ea 8F87      		std Y+15,r24
 719 03ec 988B      		std Y+16,r25
 720 03ee A98B      		std Y+17,r26
 721 03f0 BA8B      		std Y+18,r27
 298:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->bias                 = 120;
 722               		.loc 1 298 0
 723 03f2 80E0      		ldi r24,0
 724 03f4 90E0      		ldi r25,0
 725 03f6 A0EF      		ldi r26,lo8(-16)
 726 03f8 B2E4      		ldi r27,lo8(66)
 727 03fa 8B8B      		std Y+19,r24
 728 03fc 9C8B      		std Y+20,r25
 729 03fe AD8B      		std Y+21,r26
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 20


 730 0400 BE8B      		std Y+22,r27
 299:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->amplitude          = 95;
 731               		.loc 1 299 0
 732 0402 E091 0000 		lds r30,_self_pattern_protocol+3
 733 0406 F091 0000 		lds r31,_self_pattern_protocol+3+1
 734 040a 80E0      		ldi r24,0
 735 040c 90E0      		ldi r25,0
 736 040e AEEB      		ldi r26,lo8(-66)
 737 0410 B2E4      		ldi r27,lo8(66)
 738 0412 8787      		std Z+15,r24
 739 0414 908B      		std Z+16,r25
 740 0416 A18B      		std Z+17,r26
 741 0418 B28B      		std Z+18,r27
 300:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->bias               = 100;
 742               		.loc 1 300 0
 743 041a 80E0      		ldi r24,0
 744 041c 90E0      		ldi r25,0
 745 041e A8EC      		ldi r26,lo8(-56)
 746 0420 B2E4      		ldi r27,lo8(66)
 747 0422 838B      		std Z+19,r24
 748 0424 948B      		std Z+20,r25
 749 0426 A58B      		std Z+21,r26
 750 0428 B68B      		std Z+22,r27
 301:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->amplitude           = 27;
 751               		.loc 1 301 0
 752 042a E091 0000 		lds r30,_self_pattern_protocol+5
 753 042e F091 0000 		lds r31,_self_pattern_protocol+5+1
 754 0432 80E0      		ldi r24,0
 755 0434 90E0      		ldi r25,0
 756 0436 A8ED      		ldi r26,lo8(-40)
 757 0438 B1E4      		ldi r27,lo8(65)
 758 043a 8787      		std Z+15,r24
 759 043c 908B      		std Z+16,r25
 760 043e A18B      		std Z+17,r26
 761 0440 B28B      		std Z+18,r27
 302:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->bias                = 30;
 762               		.loc 1 302 0
 763 0442 80E0      		ldi r24,0
 764 0444 90E0      		ldi r25,0
 765 0446 A0EF      		ldi r26,lo8(-16)
 766 0448 B1E4      		ldi r27,lo8(65)
 767               	.L22:
 768 044a 838B      		std Z+19,r24
 769 044c 948B      		std Z+20,r25
 770 044e A58B      		std Z+21,r26
 771 0450 B68B      		std Z+22,r27
 303:src/light_pattern_protocol.c ****             break;
 772               		.loc 1 303 0
 773 0452 00C0      		rjmp .L8
 774               	.LVL36:
 775               	.L10:
 306:src/light_pattern_protocol.c ****             PG_init(_self_pattern_protocol.redPattern);
 776               		.loc 1 306 0
 777 0454 CE01      		movw r24,r28
 778               	.LVL37:
 779 0456 00D0      		rcall PG_init
 780               	.LVL38:
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 21


 307:src/light_pattern_protocol.c ****             PG_init(_self_pattern_protocol.greenPattern);
 781               		.loc 1 307 0
 782 0458 8091 0000 		lds r24,_self_pattern_protocol+3
 783 045c 9091 0000 		lds r25,_self_pattern_protocol+3+1
 784 0460 00D0      		rcall PG_init
 785               	.LVL39:
 308:src/light_pattern_protocol.c ****             PG_init(_self_pattern_protocol.bluePattern);
 786               		.loc 1 308 0
 787 0462 8091 0000 		lds r24,_self_pattern_protocol+5
 788 0466 9091 0000 		lds r25,_self_pattern_protocol+5+1
 789               	/* epilogue start */
 790               		.loc 1 316 0
 791 046a DF91      		pop r29
 792 046c CF91      		pop r28
 793 046e 1F91      		pop r17
 794 0470 0F91      		pop r16
 795 0472 FF90      		pop r15
 796 0474 EF90      		pop r14
 308:src/light_pattern_protocol.c ****             PG_init(_self_pattern_protocol.bluePattern);
 797               		.loc 1 308 0
 798 0476 00C0      		rjmp PG_init
 799               	.LVL40:
 800               	.L8:
 801               	/* epilogue start */
 802               		.loc 1 316 0
 803 0478 DF91      		pop r29
 804 047a CF91      		pop r28
 805 047c 1F91      		pop r17
 806 047e 0F91      		pop r16
 807 0480 FF90      		pop r15
 808 0482 EF90      		pop r14
 809 0484 0895      		ret
 810               		.cfi_endproc
 811               	.LFE9:
 813               	.global	__floatsisf
 814               	.global	__divsf3
 815               	.global	__mulsf3
 816               	.global	_LPP_processParameterUpdate
 818               	_LPP_processParameterUpdate:
 819               	.LFB8:
 125:src/light_pattern_protocol.c **** void _LPP_processParameterUpdate(LightProtocolParameter param, int start, char* buffer) {
 820               		.loc 1 125 0
 821               		.cfi_startproc
 822               	.LVL41:
 823 0486 CF93      		push r28
 824               	.LCFI8:
 825               		.cfi_def_cfa_offset 3
 826               		.cfi_offset 28, -2
 827 0488 DF93      		push r29
 828               	.LCFI9:
 829               		.cfi_def_cfa_offset 4
 830               		.cfi_offset 29, -3
 831               	/* prologue: function */
 832               	/* frame size = 0 */
 833               	/* stack size = 2 */
 834               	.L__stack_usage = 2
 128:src/light_pattern_protocol.c ****     if (!buffer) return;
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 22


 835               		.loc 1 128 0
 836 048a 4115      		cp r20,__zero_reg__
 837 048c 5105      		cpc r21,__zero_reg__
 838 048e 01F4      		brne .+2
 839 0490 00C0      		rjmp .L27
 135:src/light_pattern_protocol.c ****     switch(param) {
 840               		.loc 1 135 0
 841 0492 8A30      		cpi r24,10
 842 0494 9105      		cpc r25,__zero_reg__
 843 0496 00F0      		brlo .+2
 844 0498 00C0      		rjmp .L27
 845 049a 8050      		subi r24,lo8(-(gs(.L30)))
 846 049c 9040      		sbci r25,hi8(-(gs(.L30)))
 847               	.LVL42:
 848 049e FA01      		movw r30,r20
 849 04a0 E60F      		add r30,r22
 850 04a2 F71F      		adc r31,r23
 851 04a4 8F93      		push r24
 852 04a6 9F93      		push r25
 853 04a8 0895      		ret
 854               		.section	.progmem.gcc_sw_table,"ax",@progbits
 855               		.p2align	1
 856               	.L30:
 857 0016 00C0      		rjmp .L29
 858 0018 00C0      		rjmp .L31
 859 001a 00C0      		rjmp .L32
 860 001c 00C0      		rjmp .L33
 861 001e 00C0      		rjmp .L34
 862 0020 00C0      		rjmp .L35
 863 0022 00C0      		rjmp .L36
 864 0024 00C0      		rjmp .L37
 865 0026 00C0      		rjmp .L38
 866 0028 00C0      		rjmp .L39
 867               		.text
 868               	.L29:
 138:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->bias = buffer[start];
 869               		.loc 1 138 0
 870 04aa C091 0000 		lds r28,_self_pattern_protocol+1
 871 04ae D091 0000 		lds r29,_self_pattern_protocol+1+1
 872 04b2 00C0      		rjmp .L43
 873               	.L31:
 142:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->bias = buffer[start];
 874               		.loc 1 142 0
 875 04b4 C091 0000 		lds r28,_self_pattern_protocol+3
 876 04b8 D091 0000 		lds r29,_self_pattern_protocol+3+1
 877               	.L43:
 878 04bc 6081      		ld r22,Z
 879               	.LVL43:
 880 04be 7727      		clr r23
 881 04c0 67FD      		sbrc r22,7
 882 04c2 7095      		com r23
 883 04c4 872F      		mov r24,r23
 884 04c6 972F      		mov r25,r23
 885 04c8 00D0      		rcall __floatsisf
 886               	.LVL44:
 887 04ca 6B8B      		std Y+19,r22
 888 04cc 7C8B      		std Y+20,r23
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 23


 889 04ce 8D8B      		std Y+21,r24
 890 04d0 9E8B      		std Y+22,r25
 143:src/light_pattern_protocol.c ****             break;
 891               		.loc 1 143 0
 892 04d2 00C0      		rjmp .L27
 893               	.LVL45:
 894               	.L32:
 146:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->bias = buffer[start];
 895               		.loc 1 146 0
 896 04d4 C091 0000 		lds r28,_self_pattern_protocol+5
 897 04d8 D091 0000 		lds r29,_self_pattern_protocol+5+1
 898 04dc 00C0      		rjmp .L43
 899               	.L33:
 150:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->amplitude = buffer[start];
 900               		.loc 1 150 0
 901 04de C091 0000 		lds r28,_self_pattern_protocol+1
 902 04e2 D091 0000 		lds r29,_self_pattern_protocol+1+1
 903 04e6 00C0      		rjmp .L44
 904               	.L34:
 154:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->amplitude = buffer[start];
 905               		.loc 1 154 0
 906 04e8 C091 0000 		lds r28,_self_pattern_protocol+3
 907 04ec D091 0000 		lds r29,_self_pattern_protocol+3+1
 908               	.L44:
 909 04f0 6081      		ld r22,Z
 910               	.LVL46:
 911 04f2 7727      		clr r23
 912 04f4 67FD      		sbrc r22,7
 913 04f6 7095      		com r23
 914 04f8 872F      		mov r24,r23
 915 04fa 972F      		mov r25,r23
 916 04fc 00D0      		rcall __floatsisf
 917               	.LVL47:
 918 04fe 6F87      		std Y+15,r22
 919 0500 788B      		std Y+16,r23
 920 0502 898B      		std Y+17,r24
 921 0504 9A8B      		std Y+18,r25
 155:src/light_pattern_protocol.c ****             break;
 922               		.loc 1 155 0
 923 0506 00C0      		rjmp .L27
 924               	.LVL48:
 925               	.L35:
 158:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->amplitude = buffer[start];
 926               		.loc 1 158 0
 927 0508 C091 0000 		lds r28,_self_pattern_protocol+5
 928 050c D091 0000 		lds r29,_self_pattern_protocol+5+1
 929 0510 00C0      		rjmp .L44
 930               	.L36:
 931               	.LVL49:
 932               	.LBB14:
 933               	.LBB15:
 934               		.file 2 "include/utilities.h"
   1:include/utilities.h **** /**********************************************************************
   2:include/utilities.h **** 
   3:include/utilities.h ****   utilities.h - miscellaneous code snippets to improve codebase 
   4:include/utilities.h ****     readability and maintainability. Append to this file with functions
   5:include/utilities.h ****     such as unit and type conversion.
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 24


   6:include/utilities.h **** 
   7:include/utilities.h **** 
   8:include/utilities.h ****   Authors: 
   9:include/utilities.h ****     Nate Fisher
  10:include/utilities.h **** 
  11:include/utilities.h ****   Created: 
  12:include/utilities.h ****     Wed Oct 1, 2014
  13:include/utilities.h **** 
  14:include/utilities.h **** **********************************************************************/
  15:include/utilities.h **** 
  16:include/utilities.h **** #ifndef  UTILITIES_H
  17:include/utilities.h **** #define  UTILITIES_H
  18:include/utilities.h **** 
  19:include/utilities.h **** #define ZERO                0b00000000
  20:include/utilities.h **** static const double     _PI = 3.1415926535897932384626433;
  21:include/utilities.h **** static const double _TWO_PI = 6.2831853071795864769252867;
  22:include/utilities.h **** 
  23:include/utilities.h **** static inline double UTIL_degToRad(double degrees) {
  24:include/utilities.h ****     return (degrees / 360.0) * 2.0 * _PI;
  25:include/utilities.h **** }
  26:include/utilities.h **** 
  27:include/utilities.h **** static inline uint16_t UTIL_charToInt(char msb, char lsb) {
  28:include/utilities.h ****     return ( ( (0x00FF & (uint16_t)msb) << 8) | (0x00FF & (uint16_t)lsb) );
 935               		.loc 2 28 0
 936 0512 8181      		ldd r24,Z+1
 937 0514 6081      		ld r22,Z
 938               	.LVL50:
 939 0516 7727      		clr r23
 940 0518 67FD      		sbrc r22,7
 941 051a 7095      		com r23
 942 051c 762F      		mov r23,r22
 943 051e 6627      		clr r22
 944 0520 682B      		or r22,r24
 945               	.LBE15:
 946               	.LBE14:
 163:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->speed    = MAX_PATTERN_PERIOD / received_uint;
 947               		.loc 1 163 0
 948 0522 80E0      		ldi r24,0
 949 0524 90E0      		ldi r25,0
 950 0526 00D0      		rcall __floatunsisf
 951               	.LVL51:
 952 0528 9B01      		movw r18,r22
 953 052a AC01      		movw r20,r24
 954 052c 60E0      		ldi r22,0
 955 052e 70E0      		ldi r23,0
 956 0530 8AE7      		ldi r24,lo8(122)
 957 0532 95E4      		ldi r25,lo8(69)
 958 0534 00D0      		rcall __divsf3
 959               	.LVL52:
 960 0536 E091 0000 		lds r30,_self_pattern_protocol+1
 961 053a F091 0000 		lds r31,_self_pattern_protocol+1+1
 962 053e 6187      		std Z+9,r22
 963 0540 7287      		std Z+10,r23
 964 0542 8387      		std Z+11,r24
 965 0544 9487      		std Z+12,r25
 164:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->speed  = MAX_PATTERN_PERIOD / received_uint;
 966               		.loc 1 164 0
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 25


 967 0546 E091 0000 		lds r30,_self_pattern_protocol+3
 968 054a F091 0000 		lds r31,_self_pattern_protocol+3+1
 969 054e 6187      		std Z+9,r22
 970 0550 7287      		std Z+10,r23
 971 0552 8387      		std Z+11,r24
 972 0554 9487      		std Z+12,r25
 165:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->speed   = MAX_PATTERN_PERIOD / received_uint;
 973               		.loc 1 165 0
 974 0556 E091 0000 		lds r30,_self_pattern_protocol+5
 975 055a F091 0000 		lds r31,_self_pattern_protocol+5+1
 976 055e 6187      		std Z+9,r22
 977 0560 7287      		std Z+10,r23
 978 0562 8387      		std Z+11,r24
 979 0564 9487      		std Z+12,r25
 166:src/light_pattern_protocol.c ****             break;
 980               		.loc 1 166 0
 981 0566 00C0      		rjmp .L27
 982               	.LVL53:
 983               	.L37:
 169:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->cyclesRemaining    = buffer[start];
 984               		.loc 1 169 0
 985 0568 8081      		ld r24,Z
 986 056a A091 0000 		lds r26,_self_pattern_protocol+1
 987 056e B091 0000 		lds r27,_self_pattern_protocol+1+1
 988 0572 1496      		adiw r26,4
 989 0574 8C93      		st X,r24
 170:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->cyclesRemaining  = buffer[start];
 990               		.loc 1 170 0
 991 0576 8081      		ld r24,Z
 992 0578 A091 0000 		lds r26,_self_pattern_protocol+3
 993 057c B091 0000 		lds r27,_self_pattern_protocol+3+1
 994 0580 1496      		adiw r26,4
 995 0582 8C93      		st X,r24
 171:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->cyclesRemaining   = buffer[start];
 996               		.loc 1 171 0
 997 0584 8081      		ld r24,Z
 998 0586 E091 0000 		lds r30,_self_pattern_protocol+5
 999 058a F091 0000 		lds r31,_self_pattern_protocol+5+1
 1000 058e 8483      		std Z+4,r24
 172:src/light_pattern_protocol.c ****             break;
 1001               		.loc 1 172 0
 1002 0590 00C0      		rjmp .L27
 1003               	.L38:
 1004               	.LVL54:
 1005               	.LBB16:
 1006               	.LBB17:
 1007               		.loc 2 28 0
 1008 0592 8181      		ldd r24,Z+1
 1009 0594 6081      		ld r22,Z
 1010               	.LVL55:
 1011 0596 7727      		clr r23
 1012 0598 67FD      		sbrc r22,7
 1013 059a 7095      		com r23
 1014 059c 762F      		mov r23,r22
 1015 059e 6627      		clr r22
 1016 05a0 682B      		or r22,r24
 1017               	.LBE17:
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 26


 1018               	.LBE16:
 175:src/light_pattern_protocol.c ****             received_uint_radians = UTIL_degToRad(UTIL_charToInt(buffer[start], buffer[start+1]));
 1019               		.loc 1 175 0
 1020 05a2 80E0      		ldi r24,0
 1021 05a4 90E0      		ldi r25,0
 1022 05a6 00D0      		rcall __floatunsisf
 1023               	.LVL56:
 1024               	.LBB18:
 1025               	.LBB19:
  24:include/utilities.h ****     return (degrees / 360.0) * 2.0 * _PI;
 1026               		.loc 2 24 0
 1027 05a8 20E0      		ldi r18,0
 1028 05aa 30E0      		ldi r19,0
 1029 05ac 44EB      		ldi r20,lo8(-76)
 1030 05ae 53E4      		ldi r21,lo8(67)
 1031 05b0 00D0      		rcall __divsf3
 1032               	.LVL57:
 1033 05b2 9B01      		movw r18,r22
 1034 05b4 AC01      		movw r20,r24
 1035 05b6 00D0      		rcall __addsf3
 1036               	.LVL58:
 1037 05b8 2BED      		ldi r18,lo8(-37)
 1038 05ba 3FE0      		ldi r19,lo8(15)
 1039 05bc 49E4      		ldi r20,lo8(73)
 1040 05be 50E4      		ldi r21,lo8(64)
 1041 05c0 00D0      		rcall __mulsf3
 1042               	.LVL59:
 1043               	.LBE19:
 1044               	.LBE18:
 175:src/light_pattern_protocol.c ****             received_uint_radians = UTIL_degToRad(UTIL_charToInt(buffer[start], buffer[start+1]));
 1045               		.loc 1 175 0
 1046 05c2 00D0      		rcall __fixunssfsi
 1047               	.LVL60:
 176:src/light_pattern_protocol.c ****             _self_pattern_protocol.redPattern->phase    = received_uint_radians;
 1048               		.loc 1 176 0
 1049 05c4 E091 0000 		lds r30,_self_pattern_protocol+1
 1050 05c8 F091 0000 		lds r31,_self_pattern_protocol+1+1
 1051 05cc 7687      		std Z+14,r23
 1052 05ce 6587      		std Z+13,r22
 177:src/light_pattern_protocol.c ****             _self_pattern_protocol.greenPattern->phase  = received_uint_radians;
 1053               		.loc 1 177 0
 1054 05d0 E091 0000 		lds r30,_self_pattern_protocol+3
 1055 05d4 F091 0000 		lds r31,_self_pattern_protocol+3+1
 1056 05d8 7687      		std Z+14,r23
 1057 05da 6587      		std Z+13,r22
 178:src/light_pattern_protocol.c ****             _self_pattern_protocol.bluePattern->phase   = received_uint_radians;
 1058               		.loc 1 178 0
 1059 05dc E091 0000 		lds r30,_self_pattern_protocol+5
 1060 05e0 F091 0000 		lds r31,_self_pattern_protocol+5+1
 1061 05e4 7687      		std Z+14,r23
 1062 05e6 6587      		std Z+13,r22
 179:src/light_pattern_protocol.c ****             break;
 1063               		.loc 1 179 0
 1064 05e8 00C0      		rjmp .L27
 1065               	.LVL61:
 1066               	.L39:
 182:src/light_pattern_protocol.c ****             if (buffer[start] < PARAM_MACRO_ENUM_COUNT)
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 27


 1067               		.loc 1 182 0
 1068 05ea 8081      		ld r24,Z
 1069 05ec 8B30      		cpi r24,lo8(11)
 1070 05ee 04F4      		brge .L27
 183:src/light_pattern_protocol.c ****                 _LPP_setParamMacro(buffer[start]);
 1071               		.loc 1 183 0
 1072 05f0 9927      		clr r25
 1073 05f2 87FD      		sbrc r24,7
 1074 05f4 9095      		com r25
 1075               	/* epilogue start */
 190:src/light_pattern_protocol.c **** }
 1076               		.loc 1 190 0
 1077 05f6 DF91      		pop r29
 1078 05f8 CF91      		pop r28
 183:src/light_pattern_protocol.c ****                 _LPP_setParamMacro(buffer[start]);
 1079               		.loc 1 183 0
 1080 05fa 00C0      		rjmp _LPP_setParamMacro
 1081               	.LVL62:
 1082               	.L27:
 1083               	/* epilogue start */
 190:src/light_pattern_protocol.c **** }
 1084               		.loc 1 190 0
 1085 05fc DF91      		pop r29
 1086 05fe CF91      		pop r28
 1087 0600 0895      		ret
 1088               		.cfi_endproc
 1089               	.LFE8:
 1091               	.global	LPP_processBuffer
 1093               	LPP_processBuffer:
 1094               	.LFB5:
  37:src/light_pattern_protocol.c **** void LPP_processBuffer(char* twiCommandBuffer, int size) {
 1095               		.loc 1 37 0
 1096               		.cfi_startproc
 1097               	.LVL63:
 1098 0602 CF92      		push r12
 1099               	.LCFI10:
 1100               		.cfi_def_cfa_offset 3
 1101               		.cfi_offset 12, -2
 1102 0604 DF92      		push r13
 1103               	.LCFI11:
 1104               		.cfi_def_cfa_offset 4
 1105               		.cfi_offset 13, -3
 1106 0606 EF92      		push r14
 1107               	.LCFI12:
 1108               		.cfi_def_cfa_offset 5
 1109               		.cfi_offset 14, -4
 1110 0608 FF92      		push r15
 1111               	.LCFI13:
 1112               		.cfi_def_cfa_offset 6
 1113               		.cfi_offset 15, -5
 1114 060a 0F93      		push r16
 1115               	.LCFI14:
 1116               		.cfi_def_cfa_offset 7
 1117               		.cfi_offset 16, -6
 1118 060c 1F93      		push r17
 1119               	.LCFI15:
 1120               		.cfi_def_cfa_offset 8
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 28


 1121               		.cfi_offset 17, -7
 1122 060e CF93      		push r28
 1123               	.LCFI16:
 1124               		.cfi_def_cfa_offset 9
 1125               		.cfi_offset 28, -8
 1126 0610 DF93      		push r29
 1127               	.LCFI17:
 1128               		.cfi_def_cfa_offset 10
 1129               		.cfi_offset 29, -9
 1130               	/* prologue: function */
 1131               	/* frame size = 0 */
 1132               	/* stack size = 8 */
 1133               	.L__stack_usage = 8
 1134 0612 8C01      		movw r16,r24
 1135 0614 7B01      		movw r14,r22
  42:src/light_pattern_protocol.c ****     if (twiCommandBuffer && 
 1136               		.loc 1 42 0
 1137 0616 0097      		sbiw r24,0
 1138 0618 01F4      		brne .L46
 1139               	.LVL64:
 1140               	.L47:
  94:src/light_pattern_protocol.c ****     _self_pattern_protocol.isCommandFresh = 0;
 1141               		.loc 1 94 0
 1142 061a 1092 0000 		sts _self_pattern_protocol,__zero_reg__
 1143               	/* epilogue start */
  96:src/light_pattern_protocol.c **** }
 1144               		.loc 1 96 0
 1145 061e DF91      		pop r29
 1146 0620 CF91      		pop r28
 1147 0622 1F91      		pop r17
 1148 0624 0F91      		pop r16
 1149               	.LVL65:
 1150 0626 FF90      		pop r15
 1151 0628 EF90      		pop r14
 1152               	.LVL66:
 1153 062a DF90      		pop r13
 1154 062c CF90      		pop r12
 1155 062e 0895      		ret
 1156               	.LVL67:
 1157               	.L46:
  42:src/light_pattern_protocol.c ****     if (twiCommandBuffer && 
 1158               		.loc 1 42 0 discriminator 1
 1159 0630 1616      		cp __zero_reg__,r22
 1160 0632 1706      		cpc __zero_reg__,r23
 1161 0634 04F4      		brge .L47
  43:src/light_pattern_protocol.c ****         size > 0 &&
 1162               		.loc 1 43 0
 1163 0636 8091 0000 		lds r24,_self_pattern_protocol
 1164 063a 8823      		tst r24
 1165 063c 01F0      		breq .L47
 1166               	.LBB20:
  47:src/light_pattern_protocol.c ****         if (twiCommandBuffer[0] != PATTERN_PARAMUPDATE)
 1167               		.loc 1 47 0
 1168 063e F801      		movw r30,r16
 1169 0640 8081      		ld r24,Z
 1170 0642 8730      		cpi r24,lo8(7)
 1171 0644 01F0      		breq .L48
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 29


  48:src/light_pattern_protocol.c ****             _LPP_setPattern( twiCommandBuffer[0] );
 1172               		.loc 1 48 0
 1173 0646 9927      		clr r25
 1174 0648 87FD      		sbrc r24,7
 1175 064a 9095      		com r25
 1176 064c 00D0      		rcall _LPP_setPattern
 1177               	.LVL68:
 1178               	.L48:
 1179               	.LBE20:
  37:src/light_pattern_protocol.c **** void LPP_processBuffer(char* twiCommandBuffer, int size) {
 1180               		.loc 1 37 0 discriminator 1
 1181 064e C1E0      		ldi r28,lo8(1)
 1182 0650 D0E0      		ldi r29,0
 1183               	.L49:
 1184               	.LVL69:
 1185               	.LBB22:
  53:src/light_pattern_protocol.c ****         while (buffer_pointer < size) {
 1186               		.loc 1 53 0 discriminator 1
 1187 0652 CE15      		cp r28,r14
 1188 0654 DF05      		cpc r29,r15
 1189 0656 04F4      		brge .L47
 1190               	.LBB21:
  61:src/light_pattern_protocol.c ****             if (twiCommandBuffer[buffer_pointer] < PARAM_ENUM_COUNT &&
 1191               		.loc 1 61 0
 1192 0658 F801      		movw r30,r16
 1193 065a EC0F      		add r30,r28
 1194 065c FD1F      		adc r31,r29
 1195 065e 8081      		ld r24,Z
 1196 0660 8A30      		cpi r24,lo8(10)
 1197 0662 00F4      		brsh .L47
  64:src/light_pattern_protocol.c ****                 currParam = twiCommandBuffer[buffer_pointer];
 1198               		.loc 1 64 0
 1199 0664 9927      		clr r25
 1200 0666 87FD      		sbrc r24,7
 1201 0668 9095      		com r25
 1202               	.LVL70:
  73:src/light_pattern_protocol.c ****             int paramSize = LightParameterSize[currParam];
 1203               		.loc 1 73 0
 1204 066a FC01      		movw r30,r24
 1205 066c EE0F      		lsl r30
 1206 066e FF1F      		rol r31
 1207 0670 E050      		subi r30,lo8(-(LightParameterSize))
 1208 0672 F040      		sbci r31,hi8(-(LightParameterSize))
 1209 0674 C080      		ld r12,Z
 1210 0676 D180      		ldd r13,Z+1
 1211               	.LVL71:
  79:src/light_pattern_protocol.c ****             if (buffer_pointer + paramSize > size-1) break;
 1212               		.loc 1 79 0
 1213 0678 9E01      		movw r18,r28
 1214 067a 2C0D      		add r18,r12
 1215 067c 3D1D      		adc r19,r13
 1216 067e 2E15      		cp r18,r14
 1217 0680 3F05      		cpc r19,r15
 1218 0682 04F4      		brge .L47
  83:src/light_pattern_protocol.c ****             _LPP_processParameterUpdate(currParam, buffer_pointer+1, twiCommandBuffer);
 1219               		.loc 1 83 0
 1220 0684 BE01      		movw r22,r28
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 30


 1221 0686 6F5F      		subi r22,-1
 1222 0688 7F4F      		sbci r23,-1
 1223 068a A801      		movw r20,r16
 1224 068c 00D0      		rcall _LPP_processParameterUpdate
 1225               	.LVL72:
  86:src/light_pattern_protocol.c ****             buffer_pointer += paramSize + 1;
 1226               		.loc 1 86 0
 1227 068e FFEF      		ldi r31,-1
 1228 0690 CF1A      		sub r12,r31
 1229 0692 DF0A      		sbc r13,r31
 1230               	.LVL73:
 1231 0694 CC0D      		add r28,r12
 1232 0696 DD1D      		adc r29,r13
 1233               	.LVL74:
 1234 0698 00C0      		rjmp .L49
 1235               	.LBE21:
 1236               	.LBE22:
 1237               		.cfi_endproc
 1238               	.LFE5:
 1240               		.comm	_self_pattern_protocol,7,1
 1241               		.section	.rodata
 1244               	LightParameterSize:
 1245 0000 0100      		.word	1
 1246 0002 0100      		.word	1
 1247 0004 0100      		.word	1
 1248 0006 0100      		.word	1
 1249 0008 0100      		.word	1
 1250 000a 0100      		.word	1
 1251 000c 0200      		.word	2
 1252 000e 0100      		.word	1
 1253 0010 0200      		.word	2
 1254 0012 0100      		.word	1
 1255               		.text
 1256               	.Letext0:
 1257               		.file 3 "/usr/local/CrossPack-AVR-20131216/avr/include/stdint.h"
 1258               		.file 4 "include/pattern_generator.h"
 1259               		.file 5 "include/light_pattern_protocol.h"
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s 			page 31


DEFINED SYMBOLS
                            *ABS*:00000000 light_pattern_protocol.c
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s:2      *ABS*:0000003e __SP_H__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s:3      *ABS*:0000003d __SP_L__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s:4      *ABS*:0000003f __SREG__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s:5      *ABS*:00000000 __tmp_reg__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s:6      *ABS*:00000001 __zero_reg__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s:12     .text:00000000 LPP_setRedPatternGen
                            *COM*:00000007 _self_pattern_protocol
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s:31     .text:0000000a LPP_setGreenPatternGen
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s:49     .text:00000014 LPP_setBluePatternGen
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s:67     .text:0000001e LPP_setCommandRefreshed
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s:84     .text:00000026 _LPP_setPattern
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s:157    .text:00000082 _LPP_setParamMacro
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s:818    .text:00000486 _LPP_processParameterUpdate
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s:1093   .text:00000602 LPP_processBuffer
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//ccF1mop8.s:1244   .rodata:00000000 LightParameterSize

UNDEFINED SYMBOLS
__floatunsisf
__addsf3
__fixunssfsi
PG_init
__floatsisf
__divsf3
__mulsf3
__do_copy_data
__do_clear_bss
