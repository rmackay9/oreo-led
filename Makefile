
# project config
OBJECT_DIR=build
SRC_DIR=src
INCLUDE_DIR=include
OUTPUT_NAME=main
OBJECTS=${OBJECT_DIR}/light_pattern_protocol.o ${OBJECT_DIR}/node_manager.o 
OBJECTS+= ${OBJECT_DIR}/pattern_generator.o ${OBJECT_DIR}/synchro_clock.o ${OBJECT_DIR}/twi_manager.o 
OBJECTS+= ${OBJECT_DIR}/utilities.o ${OBJECT_DIR}/waveform_generator.o

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

##############################################
# Compile
##############################################

${OBJECT_DIR}/light_pattern_protocol.o: ${SRC_DIR}/light_pattern_protocol.c ${INCLUDE_DIR}/light_pattern_protocol.h
	@${AVRGCC} ${CFLAGS} -c ${SRC_DIR}/light_pattern_protocol.c -o ${OBJECT_DIR}/light_pattern_protocol.o  

${OBJECT_DIR}/node_manager.o: ${SRC_DIR}/node_manager.c ${INCLUDE_DIR}/node_manager.h
	@${AVRGCC} ${CFLAGS} -c ${SRC_DIR}/node_manager.c -o ${OBJECT_DIR}/node_manager.o  

${OBJECT_DIR}/pattern_generator.o: ${SRC_DIR}/pattern_generator.c ${INCLUDE_DIR}/pattern_generator.h
	@${AVRGCC} ${CFLAGS} -c ${SRC_DIR}/pattern_generator.c -o ${OBJECT_DIR}/pattern_generator.o  

${OBJECT_DIR}/synchro_clock.o: ${SRC_DIR}/synchro_clock.c ${INCLUDE_DIR}/synchro_clock.h
	@${AVRGCC} ${CFLAGS} -c ${SRC_DIR}/synchro_clock.c -o ${OBJECT_DIR}/synchro_clock.o  

${OBJECT_DIR}/twi_manager.o: ${SRC_DIR}/twi_manager.c ${INCLUDE_DIR}/twi_manager.h
	@${AVRGCC} ${CFLAGS} -c ${SRC_DIR}/twi_manager.c -o ${OBJECT_DIR}/twi_manager.o  

${OBJECT_DIR}/waveform_generator.o: ${SRC_DIR}/waveform_generator.c ${INCLUDE_DIR}/waveform_generator.h
	@${AVRGCC} ${CFLAGS} -c ${SRC_DIR}/waveform_generator.c -o ${OBJECT_DIR}/waveform_generator.o  

${OBJECT_DIR}/utilities.o: ${SRC_DIR}/utilities.c ${INCLUDE_DIR}/utilities.h
	@${AVRGCC} ${CFLAGS} -c ${SRC_DIR}/utilities.c -o ${OBJECT_DIR}/utilities.o  

${OBJECT_DIR}/main.o: ${SRC_DIR}/main.c ${OBJECTS}
	@${AVRGCC} ${CFLAGS} -c ${SRC_DIR}/main.c -o ${OBJECT_DIR}/main.o  

##############################################
# Link
##############################################

${OBJECT_DIR}/${OUTPUT_NAME}.elf: ${OBJECT_DIR}/main.o ${OBJECTS} 
	@${AVRGCC} ${OBJECT_DIR}/main.o ${OBJECTS} ${CFLAGS} -o ${OBJECT_DIR}/${OUTPUT_NAME}.elf 

${OBJECT_DIR}/${OUTPUT_NAME}.hex: ${OBJECT_DIR}/${OUTPUT_NAME}.elf
	@${RM} -f ${OBJECT_DIR}/${OUTPUT_NAME}.hex
	@${AVROBJCOPY} -j .text -j .data -O ihex ${OBJECT_DIR}/${OUTPUT_NAME}.elf ${OBJECT_DIR}/${OUTPUT_NAME}.hex
	@${AVRSIZE} --format=avr --mcu=${DEVICE} ${OBJECT_DIR}/${OUTPUT_NAME}.elf
