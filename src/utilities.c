/**********************************************************************

  utilities.c - 

  Authors: 
    Nate Fisher

  Created at: 
    Wed Oct 1, 2014

  <License> 
  <Copyright>

**********************************************************************/

#include <avr/io.h>

#include "utilities.h"

double UTIL_degToRad(double degrees) {
    return degrees / 360.0 / 2.0 * _PI;
}

uint16_t UTIL_charToInt(char msb, char lsb) {
    return ( ( (0x00FF & (uint16_t)msb) << 8) | (0x00FF & (uint16_t)lsb) );
}
