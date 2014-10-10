GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s 			page 1


   1               		.file	"synchro_clock.c"
   2               	__SP_H__ = 0x3e
   3               	__SP_L__ = 0x3d
   4               	__SREG__ = 0x3f
   5               	__tmp_reg__ = 0
   6               	__zero_reg__ = 1
   7               		.text
   8               	.Ltext0:
   9               		.cfi_sections	.debug_frame
  10               	.global	SYNCLK_init
  12               	SYNCLK_init:
  13               	.LFB4:
  14               		.file 1 "src/synchro_clock.c"
   1:src/synchro_clock.c **** /**********************************************************************
   2:src/synchro_clock.c **** 
   3:src/synchro_clock.c ****   synchro_clock.c - implementation, see header for description
   4:src/synchro_clock.c **** 
   5:src/synchro_clock.c **** 
   6:src/synchro_clock.c ****   Authors: 
   7:src/synchro_clock.c ****     Nate Fisher
   8:src/synchro_clock.c **** 
   9:src/synchro_clock.c ****   Created: 
  10:src/synchro_clock.c ****     Wed Oct 1, 2014
  11:src/synchro_clock.c **** 
  12:src/synchro_clock.c **** **********************************************************************/
  13:src/synchro_clock.c **** 
  14:src/synchro_clock.c **** #include <avr/io.h>
  15:src/synchro_clock.c **** #include "math.h"
  16:src/synchro_clock.c **** #include "synchro_clock.h"
  17:src/synchro_clock.c **** 
  18:src/synchro_clock.c **** #include "utilities.h"
  19:src/synchro_clock.c ****   
  20:src/synchro_clock.c **** void SYNCLK_init(void) {
  15               		.loc 1 20 0
  16               		.cfi_startproc
  17               	/* prologue: function */
  18               	/* frame size = 0 */
  19               	/* stack size = 0 */
  20               	.L__stack_usage = 0
  21:src/synchro_clock.c ****     // init instance members
  22:src/synchro_clock.c ****     _self_synchro_clock.clockSkips                = 0;
  21               		.loc 1 22 0
  22 0000 1092 0000 		sts _self_synchro_clock+1,__zero_reg__
  23 0004 1092 0000 		sts _self_synchro_clock,__zero_reg__
  23:src/synchro_clock.c ****     _self_synchro_clock.isPhaseCorrectionUpdated  = 1;
  24               		.loc 1 23 0
  25 0008 81E0      		ldi r24,lo8(1)
  26 000a 8093 0000 		sts _self_synchro_clock+2,r24
  24:src/synchro_clock.c ****     _self_synchro_clock.isCommandFresh            = 0;
  27               		.loc 1 24 0
  28 000e 1092 0000 		sts _self_synchro_clock+3,__zero_reg__
  25:src/synchro_clock.c ****     _self_synchro_clock.nodePhaseError            = 0;
  29               		.loc 1 25 0
  30 0012 1092 0000 		sts _self_synchro_clock+4+1,__zero_reg__
  31 0016 1092 0000 		sts _self_synchro_clock+4,__zero_reg__
  26:src/synchro_clock.c ****     _self_synchro_clock.nodeTimeOffset            = 0;
  32               		.loc 1 26 0
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s 			page 2


  33 001a 1092 0000 		sts _self_synchro_clock+6+1,__zero_reg__
  34 001e 1092 0000 		sts _self_synchro_clock+6,__zero_reg__
  27:src/synchro_clock.c ****     _self_synchro_clock.nodeTime                  = 0;
  35               		.loc 1 27 0
  36 0022 1092 0000 		sts _self_synchro_clock+8,__zero_reg__
  37 0026 1092 0000 		sts _self_synchro_clock+8+1,__zero_reg__
  38 002a 1092 0000 		sts _self_synchro_clock+8+2,__zero_reg__
  39 002e 1092 0000 		sts _self_synchro_clock+8+3,__zero_reg__
  40 0032 0895      		ret
  41               		.cfi_endproc
  42               	.LFE4:
  44               	.global	__floatunsisf
  45               	.global	__divsf3
  46               	.global	__mulsf3
  47               	.global	SYNCLK_getClockPosition
  49               	SYNCLK_getClockPosition:
  50               	.LFB5:
  28:src/synchro_clock.c **** }
  29:src/synchro_clock.c **** 
  30:src/synchro_clock.c **** // return clock position, in radians
  31:src/synchro_clock.c **** double SYNCLK_getClockPosition(void) {
  51               		.loc 1 31 0
  52               		.cfi_startproc
  53               	/* prologue: function */
  54               	/* frame size = 0 */
  55               	/* stack size = 0 */
  56               	.L__stack_usage = 0
  32:src/synchro_clock.c **** 
  33:src/synchro_clock.c ****     return (_self_synchro_clock.nodeTime / _SYNCLK_CLOCK_TOP) * _TWO_PI;
  57               		.loc 1 33 0
  58 0034 6091 0000 		lds r22,_self_synchro_clock+8
  59 0038 7091 0000 		lds r23,_self_synchro_clock+8+1
  60 003c 8091 0000 		lds r24,_self_synchro_clock+8+2
  61 0040 9091 0000 		lds r25,_self_synchro_clock+8+3
  62 0044 00D0      		rcall __floatunsisf
  63               	.LVL0:
  64 0046 20E0      		ldi r18,0
  65 0048 34E2      		ldi r19,lo8(36)
  66 004a 44E7      		ldi r20,lo8(116)
  67 004c 57E4      		ldi r21,lo8(71)
  68 004e 00D0      		rcall __divsf3
  69               	.LVL1:
  70 0050 2BED      		ldi r18,lo8(-37)
  71 0052 3FE0      		ldi r19,lo8(15)
  72 0054 49EC      		ldi r20,lo8(-55)
  73 0056 50E4      		ldi r21,lo8(64)
  74 0058 00D0      		rcall __mulsf3
  75               	.LVL2:
  34:src/synchro_clock.c **** 
  35:src/synchro_clock.c **** }
  76               		.loc 1 35 0
  77 005a 0895      		ret
  78               		.cfi_endproc
  79               	.LFE5:
  81               	.global	__ltsf2
  82               	.global	__addsf3
  83               	.global	__fixunssfsi
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s 			page 3


  84               	.global	_SYNCLK_clockTick
  86               	_SYNCLK_clockTick:
  87               	.LFB8:
  36:src/synchro_clock.c **** 
  37:src/synchro_clock.c **** // advance internal clock
  38:src/synchro_clock.c **** void SYNCLK_updateClock(void) {
  39:src/synchro_clock.c **** 
  40:src/synchro_clock.c ****     // mark time in light manager
  41:src/synchro_clock.c ****     _SYNCLK_clockTick();
  42:src/synchro_clock.c **** 
  43:src/synchro_clock.c ****     // phase correction can be updated
  44:src/synchro_clock.c ****     _SYNCLK_setPhaseCorrectionStale();
  45:src/synchro_clock.c **** 
  46:src/synchro_clock.c **** }
  47:src/synchro_clock.c **** 
  48:src/synchro_clock.c **** // calculate correction for phase error
  49:src/synchro_clock.c **** // NOTE: user must limit execution to once 
  50:src/synchro_clock.c **** //       per call to updateClock
  51:src/synchro_clock.c **** void SYNCLK_calcPhaseCorrection(void) {
  52:src/synchro_clock.c **** 
  53:src/synchro_clock.c ****     // phase correction already updated in this cycle
  54:src/synchro_clock.c ****     if (_self_synchro_clock.isPhaseCorrectionUpdated) return;
  55:src/synchro_clock.c **** 
  56:src/synchro_clock.c ****     // calculate phase error if a phase signal received
  57:src/synchro_clock.c ****     if (_self_synchro_clock.nodeTimeOffset != 0) {
  58:src/synchro_clock.c **** 
  59:src/synchro_clock.c ****         // device is behind system time
  60:src/synchro_clock.c ****         // phase error is negative
  61:src/synchro_clock.c ****         if (_self_synchro_clock.nodeTimeOffset >= _SYNCLK_CLOCK_TOP/2) {
  62:src/synchro_clock.c ****             _self_synchro_clock.nodePhaseError = (_self_synchro_clock.nodeTimeOffset - _SYNCLK_CLOC
  63:src/synchro_clock.c **** 
  64:src/synchro_clock.c ****         // device is ahead of system time
  65:src/synchro_clock.c ****         // phase error is positive
  66:src/synchro_clock.c ****         } else {
  67:src/synchro_clock.c ****             _self_synchro_clock.nodePhaseError = _self_synchro_clock.nodeTimeOffset / _SYNCLK_TICK_
  68:src/synchro_clock.c ****         }
  69:src/synchro_clock.c **** 
  70:src/synchro_clock.c ****         // do not calculate phaseError again until another phase signal received
  71:src/synchro_clock.c ****         _self_synchro_clock.nodeTimeOffset = 0;
  72:src/synchro_clock.c **** 
  73:src/synchro_clock.c ****     }
  74:src/synchro_clock.c **** 
  75:src/synchro_clock.c ****     // only apply correction if magnitude is greater than threshold
  76:src/synchro_clock.c ****     // to minimize some chasing
  77:src/synchro_clock.c ****     if (fabs(_self_synchro_clock.nodePhaseError) >= _SYNCLK_CORRECTION_THRESHOLD) { 
  78:src/synchro_clock.c **** 
  79:src/synchro_clock.c ****         // if phase error negative, add an extra clock tick
  80:src/synchro_clock.c ****         // if positive, remove a clock tick
  81:src/synchro_clock.c ****         if (_self_synchro_clock.nodePhaseError < 0) {
  82:src/synchro_clock.c ****             _SYNCLK_clockTick();
  83:src/synchro_clock.c ****             _self_synchro_clock.nodePhaseError++;
  84:src/synchro_clock.c ****         } else {
  85:src/synchro_clock.c ****             _SYNCLK_clockSkip();
  86:src/synchro_clock.c ****             _self_synchro_clock.nodePhaseError--;
  87:src/synchro_clock.c ****         }        
  88:src/synchro_clock.c ****         
  89:src/synchro_clock.c ****     }
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s 			page 4


  90:src/synchro_clock.c **** 
  91:src/synchro_clock.c ****     // phase correction has been updated
  92:src/synchro_clock.c ****     _self_synchro_clock.isPhaseCorrectionUpdated = 1;
  93:src/synchro_clock.c **** 
  94:src/synchro_clock.c **** }
  95:src/synchro_clock.c **** 
  96:src/synchro_clock.c **** // increment clock and also apply
  97:src/synchro_clock.c **** //  adjustment if local phase is behind 
  98:src/synchro_clock.c **** //  system phase
  99:src/synchro_clock.c **** void _SYNCLK_clockTick(void) {
  88               		.loc 1 99 0
  89               		.cfi_startproc
  90 005c CF92      		push r12
  91               	.LCFI0:
  92               		.cfi_def_cfa_offset 3
  93               		.cfi_offset 12, -2
  94 005e DF92      		push r13
  95               	.LCFI1:
  96               		.cfi_def_cfa_offset 4
  97               		.cfi_offset 13, -3
  98 0060 EF92      		push r14
  99               	.LCFI2:
 100               		.cfi_def_cfa_offset 5
 101               		.cfi_offset 14, -4
 102 0062 FF92      		push r15
 103               	.LCFI3:
 104               		.cfi_def_cfa_offset 6
 105               		.cfi_offset 15, -5
 106               	/* prologue: function */
 107               	/* frame size = 0 */
 108               	/* stack size = 4 */
 109               	.L__stack_usage = 4
 100:src/synchro_clock.c **** 
 101:src/synchro_clock.c **** 
 102:src/synchro_clock.c ****     // adjust clock for phase error
 103:src/synchro_clock.c ****     if (_self_synchro_clock.clockSkips > 0) { 
 110               		.loc 1 103 0
 111 0064 8091 0000 		lds r24,_self_synchro_clock
 112 0068 9091 0000 		lds r25,_self_synchro_clock+1
 113 006c 1816      		cp __zero_reg__,r24
 114 006e 1906      		cpc __zero_reg__,r25
 115 0070 04F4      		brge .L4
 104:src/synchro_clock.c ****         _self_synchro_clock.clockSkips--;
 116               		.loc 1 104 0
 117 0072 0197      		sbiw r24,1
 118 0074 9093 0000 		sts _self_synchro_clock+1,r25
 119 0078 8093 0000 		sts _self_synchro_clock,r24
 105:src/synchro_clock.c ****         return;
 120               		.loc 1 105 0
 121 007c 00C0      		rjmp .L3
 122               	.L4:
 123               	.LBB6:
 124               	.LBB7:
 106:src/synchro_clock.c ****     }
 107:src/synchro_clock.c **** 
 108:src/synchro_clock.c ****     // increment lighting pattern effect clock
 109:src/synchro_clock.c ****     if (_self_synchro_clock.nodeTime < _SYNCLK_CLOCK_TOP) {
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s 			page 5


 125               		.loc 1 109 0
 126 007e 6091 0000 		lds r22,_self_synchro_clock+8
 127 0082 7091 0000 		lds r23,_self_synchro_clock+8+1
 128 0086 8091 0000 		lds r24,_self_synchro_clock+8+2
 129 008a 9091 0000 		lds r25,_self_synchro_clock+8+3
 130 008e 00D0      		rcall __floatunsisf
 131               	.LVL3:
 132 0090 6B01      		movw r12,r22
 133 0092 7C01      		movw r14,r24
 134 0094 20E0      		ldi r18,0
 135 0096 34E2      		ldi r19,lo8(36)
 136 0098 44E7      		ldi r20,lo8(116)
 137 009a 57E4      		ldi r21,lo8(71)
 138 009c 00D0      		rcall __ltsf2
 139               	.LVL4:
 140 009e 87FF      		sbrs r24,7
 141 00a0 00C0      		rjmp .L9
 110:src/synchro_clock.c ****         _self_synchro_clock.nodeTime += _SYNCLK_TICK_INCREMENT;
 142               		.loc 1 110 0
 143 00a2 20E0      		ldi r18,0
 144 00a4 30E0      		ldi r19,0
 145 00a6 40E8      		ldi r20,lo8(-128)
 146 00a8 50E4      		ldi r21,lo8(64)
 147 00aa C701      		movw r24,r14
 148 00ac B601      		movw r22,r12
 149 00ae 00D0      		rcall __addsf3
 150               	.LVL5:
 151 00b0 00D0      		rcall __fixunssfsi
 152               	.LVL6:
 153 00b2 6093 0000 		sts _self_synchro_clock+8,r22
 154 00b6 7093 0000 		sts _self_synchro_clock+8+1,r23
 155 00ba 8093 0000 		sts _self_synchro_clock+8+2,r24
 156 00be 9093 0000 		sts _self_synchro_clock+8+3,r25
 157 00c2 00C0      		rjmp .L3
 158               	.L9:
 111:src/synchro_clock.c ****     } else {
 112:src/synchro_clock.c ****         _self_synchro_clock.nodeTime = _SYNCLK_CLOCK_RESET;
 159               		.loc 1 112 0
 160 00c4 1092 0000 		sts _self_synchro_clock+8,__zero_reg__
 161 00c8 1092 0000 		sts _self_synchro_clock+8+1,__zero_reg__
 162 00cc 1092 0000 		sts _self_synchro_clock+8+2,__zero_reg__
 163 00d0 1092 0000 		sts _self_synchro_clock+8+3,__zero_reg__
 164               	.L3:
 165               	/* epilogue start */
 166               	.LBE7:
 167               	.LBE6:
 113:src/synchro_clock.c ****     } 
 114:src/synchro_clock.c **** 
 115:src/synchro_clock.c **** }
 168               		.loc 1 115 0
 169 00d4 FF90      		pop r15
 170 00d6 EF90      		pop r14
 171 00d8 DF90      		pop r13
 172 00da CF90      		pop r12
 173 00dc 0895      		ret
 174               		.cfi_endproc
 175               	.LFE8:
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s 			page 6


 177               	.global	SYNCLK_updateClock
 179               	SYNCLK_updateClock:
 180               	.LFB6:
  38:src/synchro_clock.c **** void SYNCLK_updateClock(void) {
 181               		.loc 1 38 0
 182               		.cfi_startproc
 183               	/* prologue: function */
 184               	/* frame size = 0 */
 185               	/* stack size = 0 */
 186               	.L__stack_usage = 0
  41:src/synchro_clock.c ****     _SYNCLK_clockTick();
 187               		.loc 1 41 0
 188 00de 00D0      		rcall _SYNCLK_clockTick
 189               	.LVL7:
 190               	.LBB8:
 191               	.LBB9:
 116:src/synchro_clock.c **** 
 117:src/synchro_clock.c **** // clock adjustment to be applied
 118:src/synchro_clock.c **** //  if local phase is ahead of system
 119:src/synchro_clock.c **** void _SYNCLK_clockSkip(void) {
 120:src/synchro_clock.c **** 
 121:src/synchro_clock.c ****     _self_synchro_clock.clockSkips++;
 122:src/synchro_clock.c **** 
 123:src/synchro_clock.c **** }
 124:src/synchro_clock.c **** 
 125:src/synchro_clock.c **** // call on receipt of a phase correction
 126:src/synchro_clock.c **** //  signal to record the local offset from
 127:src/synchro_clock.c **** //  the system value
 128:src/synchro_clock.c **** void SYNCLK_recordPhaseError(void) {
 129:src/synchro_clock.c **** 
 130:src/synchro_clock.c ****     _self_synchro_clock.nodeTimeOffset = _self_synchro_clock.nodeTime;
 131:src/synchro_clock.c **** 
 132:src/synchro_clock.c **** }
 133:src/synchro_clock.c **** 
 134:src/synchro_clock.c **** // indicate to mainloop that a calcPhaseCorrection
 135:src/synchro_clock.c **** //  can be called again
 136:src/synchro_clock.c **** void _SYNCLK_setPhaseCorrectionStale(void) {
 137:src/synchro_clock.c **** 
 138:src/synchro_clock.c ****     // recompute phase correction 
 139:src/synchro_clock.c ****     //  in next mainloop
 140:src/synchro_clock.c ****     _self_synchro_clock.isPhaseCorrectionUpdated = 0;
 192               		.loc 1 140 0
 193 00e0 1092 0000 		sts _self_synchro_clock+2,__zero_reg__
 194 00e4 0895      		ret
 195               	.LBE9:
 196               	.LBE8:
 197               		.cfi_endproc
 198               	.LFE6:
 200               	.global	_SYNCLK_clockSkip
 202               	_SYNCLK_clockSkip:
 203               	.LFB9:
 119:src/synchro_clock.c **** void _SYNCLK_clockSkip(void) {
 204               		.loc 1 119 0
 205               		.cfi_startproc
 206               	/* prologue: function */
 207               	/* frame size = 0 */
 208               	/* stack size = 0 */
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s 			page 7


 209               	.L__stack_usage = 0
 121:src/synchro_clock.c ****     _self_synchro_clock.clockSkips++;
 210               		.loc 1 121 0
 211 00e6 E0E0      		ldi r30,lo8(_self_synchro_clock)
 212 00e8 F0E0      		ldi r31,hi8(_self_synchro_clock)
 213 00ea 8081      		ld r24,Z
 214 00ec 9181      		ldd r25,Z+1
 215 00ee 0196      		adiw r24,1
 216 00f0 9183      		std Z+1,r25
 217 00f2 8083      		st Z,r24
 218 00f4 0895      		ret
 219               		.cfi_endproc
 220               	.LFE9:
 222               	.global	__floatsisf
 223               	.global	__gesf2
 224               	.global	__subsf3
 225               	.global	__fixsfsi
 226               	.global	SYNCLK_calcPhaseCorrection
 228               	SYNCLK_calcPhaseCorrection:
 229               	.LFB7:
  51:src/synchro_clock.c **** void SYNCLK_calcPhaseCorrection(void) {
 230               		.loc 1 51 0
 231               		.cfi_startproc
 232 00f6 CF92      		push r12
 233               	.LCFI4:
 234               		.cfi_def_cfa_offset 3
 235               		.cfi_offset 12, -2
 236 00f8 DF92      		push r13
 237               	.LCFI5:
 238               		.cfi_def_cfa_offset 4
 239               		.cfi_offset 13, -3
 240 00fa EF92      		push r14
 241               	.LCFI6:
 242               		.cfi_def_cfa_offset 5
 243               		.cfi_offset 14, -4
 244 00fc FF92      		push r15
 245               	.LCFI7:
 246               		.cfi_def_cfa_offset 6
 247               		.cfi_offset 15, -5
 248               	/* prologue: function */
 249               	/* frame size = 0 */
 250               	/* stack size = 4 */
 251               	.L__stack_usage = 4
  54:src/synchro_clock.c ****     if (_self_synchro_clock.isPhaseCorrectionUpdated) return;
 252               		.loc 1 54 0
 253 00fe 8091 0000 		lds r24,_self_synchro_clock+2
 254 0102 8111      		cpse r24,__zero_reg__
 255 0104 00C0      		rjmp .L13
  57:src/synchro_clock.c ****     if (_self_synchro_clock.nodeTimeOffset != 0) {
 256               		.loc 1 57 0
 257 0106 6091 0000 		lds r22,_self_synchro_clock+6
 258 010a 7091 0000 		lds r23,_self_synchro_clock+6+1
 259 010e 6115      		cp r22,__zero_reg__
 260 0110 7105      		cpc r23,__zero_reg__
 261 0112 01F0      		breq .L15
  61:src/synchro_clock.c ****         if (_self_synchro_clock.nodeTimeOffset >= _SYNCLK_CLOCK_TOP/2) {
 262               		.loc 1 61 0
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s 			page 8


 263 0114 8827      		clr r24
 264 0116 77FD      		sbrc r23,7
 265 0118 8095      		com r24
 266 011a 982F      		mov r25,r24
 267 011c 00D0      		rcall __floatsisf
 268               	.LVL8:
 269 011e 6B01      		movw r12,r22
 270 0120 7C01      		movw r14,r24
 271 0122 20E0      		ldi r18,0
 272 0124 34E2      		ldi r19,lo8(36)
 273 0126 44EF      		ldi r20,lo8(-12)
 274 0128 56E4      		ldi r21,lo8(70)
 275 012a 00D0      		rcall __gesf2
 276               	.LVL9:
 277 012c 87FD      		sbrc r24,7
 278 012e 00C0      		rjmp .L27
  62:src/synchro_clock.c ****             _self_synchro_clock.nodePhaseError = (_self_synchro_clock.nodeTimeOffset - _SYNCLK_CLOC
 279               		.loc 1 62 0
 280 0130 20E0      		ldi r18,0
 281 0132 34E2      		ldi r19,lo8(36)
 282 0134 44E7      		ldi r20,lo8(116)
 283 0136 57E4      		ldi r21,lo8(71)
 284 0138 C701      		movw r24,r14
 285 013a B601      		movw r22,r12
 286 013c 00D0      		rcall __subsf3
 287               	.LVL10:
 288 013e 20E0      		ldi r18,0
 289 0140 30E0      		ldi r19,0
 290 0142 40E8      		ldi r20,lo8(-128)
 291 0144 5EE3      		ldi r21,lo8(62)
 292 0146 00C0      		rjmp .L28
 293               	.L27:
  67:src/synchro_clock.c ****             _self_synchro_clock.nodePhaseError = _self_synchro_clock.nodeTimeOffset / _SYNCLK_TICK_
 294               		.loc 1 67 0
 295 0148 20E0      		ldi r18,0
 296 014a 30E0      		ldi r19,0
 297 014c 40E8      		ldi r20,lo8(-128)
 298 014e 5EE3      		ldi r21,lo8(62)
 299 0150 C701      		movw r24,r14
 300 0152 B601      		movw r22,r12
 301               	.L28:
 302 0154 00D0      		rcall __mulsf3
 303               	.LVL11:
 304 0156 00D0      		rcall __fixsfsi
 305               	.LVL12:
 306 0158 7093 0000 		sts _self_synchro_clock+4+1,r23
 307 015c 6093 0000 		sts _self_synchro_clock+4,r22
  71:src/synchro_clock.c ****         _self_synchro_clock.nodeTimeOffset = 0;
 308               		.loc 1 71 0
 309 0160 1092 0000 		sts _self_synchro_clock+6+1,__zero_reg__
 310 0164 1092 0000 		sts _self_synchro_clock+6,__zero_reg__
 311               	.L15:
  77:src/synchro_clock.c ****     if (fabs(_self_synchro_clock.nodePhaseError) >= _SYNCLK_CORRECTION_THRESHOLD) { 
 312               		.loc 1 77 0
 313 0168 E090 0000 		lds r14,_self_synchro_clock+4
 314 016c F090 0000 		lds r15,_self_synchro_clock+4+1
 315 0170 B701      		movw r22,r14
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s 			page 9


 316 0172 8827      		clr r24
 317 0174 77FD      		sbrc r23,7
 318 0176 8095      		com r24
 319 0178 982F      		mov r25,r24
 320 017a 00D0      		rcall __floatsisf
 321               	.LVL13:
 322 017c 9F77      		andi r25,0x7f
 323 017e 20E0      		ldi r18,0
 324 0180 30E0      		ldi r19,0
 325 0182 40E0      		ldi r20,0
 326 0184 50E4      		ldi r21,lo8(64)
 327 0186 00D0      		rcall __gesf2
 328               	.LVL14:
 329 0188 87FD      		sbrc r24,7
 330 018a 00C0      		rjmp .L19
  81:src/synchro_clock.c ****         if (_self_synchro_clock.nodePhaseError < 0) {
 331               		.loc 1 81 0
 332 018c F7FE      		sbrs r15,7
 333 018e 00C0      		rjmp .L21
  82:src/synchro_clock.c ****             _SYNCLK_clockTick();
 334               		.loc 1 82 0
 335 0190 00D0      		rcall _SYNCLK_clockTick
 336               	.LVL15:
  83:src/synchro_clock.c ****             _self_synchro_clock.nodePhaseError++;
 337               		.loc 1 83 0
 338 0192 8091 0000 		lds r24,_self_synchro_clock+4
 339 0196 9091 0000 		lds r25,_self_synchro_clock+4+1
 340 019a 0196      		adiw r24,1
 341 019c 00C0      		rjmp .L29
 342               	.L21:
  85:src/synchro_clock.c ****             _SYNCLK_clockSkip();
 343               		.loc 1 85 0
 344 019e 00D0      		rcall _SYNCLK_clockSkip
 345               	.LVL16:
  86:src/synchro_clock.c ****             _self_synchro_clock.nodePhaseError--;
 346               		.loc 1 86 0
 347 01a0 8091 0000 		lds r24,_self_synchro_clock+4
 348 01a4 9091 0000 		lds r25,_self_synchro_clock+4+1
 349 01a8 0197      		sbiw r24,1
 350               	.L29:
 351 01aa 9093 0000 		sts _self_synchro_clock+4+1,r25
 352 01ae 8093 0000 		sts _self_synchro_clock+4,r24
 353               	.L19:
  92:src/synchro_clock.c ****     _self_synchro_clock.isPhaseCorrectionUpdated = 1;
 354               		.loc 1 92 0
 355 01b2 81E0      		ldi r24,lo8(1)
 356 01b4 8093 0000 		sts _self_synchro_clock+2,r24
 357               	.L13:
 358               	/* epilogue start */
  94:src/synchro_clock.c **** }
 359               		.loc 1 94 0
 360 01b8 FF90      		pop r15
 361 01ba EF90      		pop r14
 362 01bc DF90      		pop r13
 363 01be CF90      		pop r12
 364 01c0 0895      		ret
 365               		.cfi_endproc
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s 			page 10


 366               	.LFE7:
 368               	.global	SYNCLK_recordPhaseError
 370               	SYNCLK_recordPhaseError:
 371               	.LFB10:
 128:src/synchro_clock.c **** void SYNCLK_recordPhaseError(void) {
 372               		.loc 1 128 0
 373               		.cfi_startproc
 374               	/* prologue: function */
 375               	/* frame size = 0 */
 376               	/* stack size = 0 */
 377               	.L__stack_usage = 0
 130:src/synchro_clock.c ****     _self_synchro_clock.nodeTimeOffset = _self_synchro_clock.nodeTime;
 378               		.loc 1 130 0
 379 01c2 8091 0000 		lds r24,_self_synchro_clock+8
 380 01c6 9091 0000 		lds r25,_self_synchro_clock+8+1
 381 01ca 9093 0000 		sts _self_synchro_clock+6+1,r25
 382 01ce 8093 0000 		sts _self_synchro_clock+6,r24
 383 01d2 0895      		ret
 384               		.cfi_endproc
 385               	.LFE10:
 387               	.global	_SYNCLK_setPhaseCorrectionStale
 389               	_SYNCLK_setPhaseCorrectionStale:
 390               	.LFB11:
 136:src/synchro_clock.c **** void _SYNCLK_setPhaseCorrectionStale(void) {
 391               		.loc 1 136 0
 392               		.cfi_startproc
 393               	/* prologue: function */
 394               	/* frame size = 0 */
 395               	/* stack size = 0 */
 396               	.L__stack_usage = 0
 397               		.loc 1 140 0
 398 01d4 1092 0000 		sts _self_synchro_clock+2,__zero_reg__
 399 01d8 0895      		ret
 400               		.cfi_endproc
 401               	.LFE11:
 403               		.comm	_self_synchro_clock,14,1
 404               	.Letext0:
 405               		.file 2 "/usr/local/CrossPack-AVR-20131216/avr/include/stdint.h"
 406               		.file 3 "include/synchro_clock.h"
 407               		.file 4 "include/utilities.h"
GAS LISTING /var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s 			page 11


DEFINED SYMBOLS
                            *ABS*:00000000 synchro_clock.c
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s:2      *ABS*:0000003e __SP_H__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s:3      *ABS*:0000003d __SP_L__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s:4      *ABS*:0000003f __SREG__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s:5      *ABS*:00000000 __tmp_reg__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s:6      *ABS*:00000001 __zero_reg__
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s:12     .text:00000000 SYNCLK_init
                            *COM*:0000000e _self_synchro_clock
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s:49     .text:00000034 SYNCLK_getClockPosition
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s:86     .text:0000005c _SYNCLK_clockTick
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s:179    .text:000000de SYNCLK_updateClock
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s:202    .text:000000e6 _SYNCLK_clockSkip
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s:228    .text:000000f6 SYNCLK_calcPhaseCorrection
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s:370    .text:000001c2 SYNCLK_recordPhaseError
/var/folders/jp/wbqg21rx7rb_s0pg5wfdhxj06vjfxw/T//cc9e0JqH.s:389    .text:000001d4 _SYNCLK_setPhaseCorrectionStale

UNDEFINED SYMBOLS
__floatunsisf
__divsf3
__mulsf3
__ltsf2
__addsf3
__fixunssfsi
__floatsisf
__gesf2
__subsf3
__fixsfsi
__do_clear_bss
