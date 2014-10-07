
# project config
OBJECT_DIR=build
SRC_DIR=src
INCLUDE_DIR=include
OUTPUT_NAME=main
OBJECTS=${OBJECT_DIR}/light_pattern_protocol.o ${OBJECT_DIR}/twi_manager.o 
OBJECTS+= ${OBJECT_DIR}/pattern_generator.o ${OBJECT_DIR}/synchro_clock.o
OBJECTS+= ${OBJECT_DIR}/waveform_generator.o

# shell commands
CP=cp 
MKDIR=mkdir -p
RM=rm -f 
MV=mv 

# build commands
AVRDUDE=avrdude -c dragon_isp -p attiny88 -V 
AVROBJCOPY=avr-objcopy 
AVRSIZE=avr-size 
AVRGCC=avr-gcc 
CFLAGS=-Wall -Os -DF_CPU=8000000 -mmcu=attiny88 -Iinclude 

##############################################
# High level directives
##############################################

all: 
	make clean
	@${MKDIR} ${OBJECT_DIR}
	make ${OBJECT_DIR}/${OUTPUT_NAME}.hex
	
flash: all
	@${AVRDUDE} -U flash:w:${OBJECT_DIR}/${OUTPUT_NAME}.hex:i

clean:
	@${RM} -r ${OBJECT_DIR}

# sets high speed (full rate) clock: 8MHz
fuse:
	@${AVRDUDE} -U lfuse:w:0xEE:m

##############################################
# Compile
##############################################

${OBJECT_DIR}/light_pattern_protocol.o: ${SRC_DIR}/light_pattern_protocol.c ${INCLUDE_DIR}/light_pattern_protocol.h
	@${AVRGCC} ${CFLAGS} -c ${SRC_DIR}/light_pattern_protocol.c -o ${OBJECT_DIR}/light_pattern_protocol.o  
	@${AVRGCC} ${CFLAGS} -c -g -Wa,-a,-ad ${SRC_DIR}/light_pattern_protocol.c > ${OBJECT_DIR}/light_pattern_protocol.s

${OBJECT_DIR}/pattern_generator.o: ${SRC_DIR}/pattern_generator.c ${INCLUDE_DIR}/pattern_generator.h
	@${AVRGCC} ${CFLAGS} -c ${SRC_DIR}/pattern_generator.c -o ${OBJECT_DIR}/pattern_generator.o
	@${AVRGCC} ${CFLAGS} -c -g -Wa,-a,-ad ${SRC_DIR}/pattern_generator.c > ${OBJECT_DIR}/pattern_generator.s 

${OBJECT_DIR}/synchro_clock.o: ${SRC_DIR}/synchro_clock.c ${INCLUDE_DIR}/synchro_clock.h
	@${AVRGCC} ${CFLAGS} -c ${SRC_DIR}/synchro_clock.c -o ${OBJECT_DIR}/synchro_clock.o  
	@${AVRGCC} ${CFLAGS} -c -g -Wa,-a,-ad ${SRC_DIR}/synchro_clock.c > ${OBJECT_DIR}/synchro_clock.s

${OBJECT_DIR}/twi_manager.o: ${SRC_DIR}/twi_manager.c ${INCLUDE_DIR}/twi_manager.h
	@${AVRGCC} ${CFLAGS} -c ${SRC_DIR}/twi_manager.c -o ${OBJECT_DIR}/twi_manager.o  
	@${AVRGCC} ${CFLAGS} -c -g -Wa,-a,-ad ${SRC_DIR}/twi_manager.c > ${OBJECT_DIR}/twi_manager.s

${OBJECT_DIR}/waveform_generator.o: ${SRC_DIR}/waveform_generator.c ${INCLUDE_DIR}/waveform_generator.h
	@${AVRGCC} ${CFLAGS} -c ${SRC_DIR}/waveform_generator.c -o ${OBJECT_DIR}/waveform_generator.o 
	@${AVRGCC} ${CFLAGS} -c -g -Wa,-a,-ad ${SRC_DIR}/waveform_generator.c > ${OBJECT_DIR}/waveform_generator.s

${OBJECT_DIR}/main.o: ${SRC_DIR}/main.c ${OBJECTS} ${INCLUDE_DIR}/utilities.h ${INCLUDE_DIR}/node_manager.h
	@${AVRGCC} ${CFLAGS} -c ${SRC_DIR}/main.c -o ${OBJECT_DIR}/main.o  
	@${AVRGCC} ${CFLAGS} -c -g -Wa,-a,-ad ${SRC_DIR}/main.c > ${OBJECT_DIR}/main.s

##############################################
# Link
##############################################

${OBJECT_DIR}/${OUTPUT_NAME}.elf: ${OBJECT_DIR}/main.o ${OBJECTS} 
	@${AVRGCC} ${OBJECT_DIR}/main.o ${OBJECTS} ${CFLAGS} -o ${OBJECT_DIR}/${OUTPUT_NAME}.elf 

${OBJECT_DIR}/${OUTPUT_NAME}.hex: ${OBJECT_DIR}/${OUTPUT_NAME}.elf
	@${RM} -f ${OBJECT_DIR}/${OUTPUT_NAME}.hex
	@${AVROBJCOPY} -j .text -j .data -O ihex ${OBJECT_DIR}/${OUTPUT_NAME}.elf ${OBJECT_DIR}/${OUTPUT_NAME}.hex
	@${AVRSIZE} --format=avr --mcu=${DEVICE} ${OBJECT_DIR}/${OUTPUT_NAME}.elf
