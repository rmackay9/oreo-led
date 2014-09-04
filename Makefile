
# project config
OBJECT_DIR=build
SRC_DIR=src
INCLUDE_DIR=include
OUTPUT_NAME=main
OBJECTS=${OBJECT_DIR}/I2C_Lighting.o ${OBJECT_DIR}/Light_Manager.o ${OBJECT_DIR}/TWI_slave.o 

# shell commands
CP=cp 
MKDIR=mkdir -p
RM=rm -f 
MV=mv 

# build commands
AVRDUDE=avrdude -c dragon_isp -p attiny88
AVROBJCOPY=avr-objcopy 
AVRSIZE=avr-size 
AVRGCC=avr-gcc 
CFLAGS=-Wall -Os -DF_CPU=8000000 -mmcu=attiny88 -Iinclude 

##############################################
# High level directives
##############################################

all: 
	@${MKDIR} ${OBJECT_DIR}
	make ${OBJECT_DIR}/${OUTPUT_NAME}.hex
	
flash: 
	@${AVRDUDE} -U flash:w:${OUTPUT_NAME}.hex:i

clean:
	@${RM} -r ${OBJECT_DIR}

##############################################
# Compile
##############################################

${OBJECT_DIR}/Light_Manager.o: ${SRC_DIR}/Light_Manager.c ${INCLUDE_DIR}/Light_Manager.h
	@${AVRGCC} ${CFLAGS} -c ${SRC_DIR}/Light_Manager.c -o ${OBJECT_DIR}/Light_Manager.o  

${OBJECT_DIR}/TWI_slave.o: ${SRC_DIR}/TWI_slave.c ${INCLUDE_DIR}/TWI_slave.h
	@${AVRGCC} ${CFLAGS} -c ${SRC_DIR}/TWI_slave.c -o ${OBJECT_DIR}/TWI_slave.o 

${OBJECT_DIR}/I2C_Lighting.o: ${SRC_DIR}/I2C_Lighting.c ${INCLUDE_DIR}/Light_Manager.h
	@${AVRGCC} ${CFLAGS} -c ${SRC_DIR}/I2C_Lighting.c -o ${OBJECT_DIR}/I2C_Lighting.o  

##############################################
# Link
##############################################

${OBJECT_DIR}/${OUTPUT_NAME}.elf: ${OBJECTS}
	@${AVRGCC} ${OBJECTS} ${CFLAGS} -o ${OBJECT_DIR}/${OUTPUT_NAME}.elf 

${OBJECT_DIR}/${OUTPUT_NAME}.hex: ${OBJECT_DIR}/${OUTPUT_NAME}.elf
	@${RM} -f ${OBJECT_DIR}/${OUTPUT_NAME}.hex
	@${AVROBJCOPY} -j .text -j .data -O ihex ${OBJECT_DIR}/${OUTPUT_NAME}.elf ${OBJECT_DIR}/${OUTPUT_NAME}.hex
	@${AVRSIZE} --format=avr --mcu=${DEVICE} ${OBJECT_DIR}/${OUTPUT_NAME}.elf
