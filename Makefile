
# project config
OBJECT_DIR=build
SRC_DIR=src
INCLUDE_DIR=include
OUTPUT_NAME=main
OBJECTS=${OBJECT_DIR}/light_pattern_protocol.o ${OBJECT_DIR}/twi_manager.o 
OBJECTS+= ${OBJECT_DIR}/pattern_generator.o ${OBJECT_DIR}/synchro_clock.o
OBJECTS+= ${OBJECT_DIR}/waveform_generator.o ${OBJECT_DIR}/node_manager.o

# shell commands
CP=cp 
MKDIR=mkdir -p
RM=rm -f 
MV=mv 

# build commands
#PROGRAMMER=dragon_isp
#PROGRAMMER=jtag3isp -B 8.0
PROGRAMMER=avrisp2
PROG=avrdude -c ${PROGRAMMER} -p attiny88 
AVROBJCOPY=avr-objcopy 
AVRSIZE=avr-size 
AVRGCC=avr-gcc 
CFLAGS=-Wall -Wpadded -Os -DF_CPU=8000000 -mmcu=attiny88 -Iinclude 

##############################################
# High level directives
##############################################

all: 
	@${MKDIR} ${OBJECT_DIR}
	make ${OBJECT_DIR}/${OUTPUT_NAME}.hex
	
flash: all
	@${PROG} -U flash:w:${OBJECT_DIR}/${OUTPUT_NAME}.hex:i

clean:
	@${RM} -r ${OBJECT_DIR}

# sets high speed (full rate) clock: 8MHz
fuse:
	@${PROG} -U lfuse:w:0xEE:m

##############################################
# Compile
##############################################

${OBJECT_DIR}/light_pattern_protocol.o: ${SRC_DIR}/light_pattern_protocol.c ${INCLUDE_DIR}/light_pattern_protocol.h ${INCLUDE_DIR}/utilities.h 
	@${AVRGCC} ${CFLAGS} -c -g -Wa,-a,-ad ${SRC_DIR}/light_pattern_protocol.c -o ${OBJECT_DIR}/light_pattern_protocol.o > ${OBJECT_DIR}/light_pattern_protocol.s

${OBJECT_DIR}/pattern_generator.o: ${SRC_DIR}/pattern_generator.c ${INCLUDE_DIR}/pattern_generator.h 
	@${AVRGCC} ${CFLAGS} -c -g -Wa,-a,-ad ${SRC_DIR}/pattern_generator.c -o ${OBJECT_DIR}/pattern_generator.o > ${OBJECT_DIR}/pattern_generator.s 

${OBJECT_DIR}/synchro_clock.o: ${SRC_DIR}/synchro_clock.c ${INCLUDE_DIR}/synchro_clock.h
	@${AVRGCC} ${CFLAGS} -c -g -Wa,-a,-ad ${SRC_DIR}/synchro_clock.c -o ${OBJECT_DIR}/synchro_clock.o > ${OBJECT_DIR}/synchro_clock.s

${OBJECT_DIR}/twi_manager.o: ${SRC_DIR}/twi_manager.c ${INCLUDE_DIR}/twi_manager.h
	@${AVRGCC} ${CFLAGS} -c -g -Wa,-a,-ad ${SRC_DIR}/twi_manager.c -o ${OBJECT_DIR}/twi_manager.o > ${OBJECT_DIR}/twi_manager.s

${OBJECT_DIR}/waveform_generator.o: ${SRC_DIR}/waveform_generator.c ${INCLUDE_DIR}/waveform_generator.h
	@${AVRGCC} ${CFLAGS} -c -g -Wa,-a,-ad ${SRC_DIR}/waveform_generator.c -o ${OBJECT_DIR}/waveform_generator.o > ${OBJECT_DIR}/waveform_generator.s

${OBJECT_DIR}/node_manager.o: ${SRC_DIR}/node_manager.c ${INCLUDE_DIR}/node_manager.h
	@${AVRGCC} ${CFLAGS} -c -g -Wa,-a,-ad ${SRC_DIR}/node_manager.c -o ${OBJECT_DIR}/node_manager.o > ${OBJECT_DIR}/node_manager.s

${OBJECT_DIR}/main.o: ${SRC_DIR}/main.c ${OBJECTS} ${INCLUDE_DIR}/utilities.h ${OBJECT_DIR}/node_manager.o
	@${AVRGCC} ${CFLAGS} -c -g -Wa,-a,-ad ${SRC_DIR}/main.c -o ${OBJECT_DIR}/main.o > ${OBJECT_DIR}/main.s

##############################################
# Link
##############################################

${OBJECT_DIR}/${OUTPUT_NAME}.elf: ${OBJECT_DIR}/main.o ${OBJECTS} 
	@${AVRGCC} ${OBJECT_DIR}/main.o ${OBJECTS} ${CFLAGS} -o ${OBJECT_DIR}/${OUTPUT_NAME}.elf 

${OBJECT_DIR}/${OUTPUT_NAME}.hex: ${OBJECT_DIR}/${OUTPUT_NAME}.elf
	@${RM} -f ${OBJECT_DIR}/${OUTPUT_NAME}.hex
	@${AVROBJCOPY} -j .text -j .data -O ihex ${OBJECT_DIR}/${OUTPUT_NAME}.elf ${OBJECT_DIR}/${OUTPUT_NAME}.hex
	@${AVRSIZE} --format=avr --mcu=${DEVICE} ${OBJECT_DIR}/${OUTPUT_NAME}.elf
