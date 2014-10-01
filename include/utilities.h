static const double     _PI= 3.1415926535897932384626433;
static const double _TWO_PI= 6.2831853071795864769252867;

double UTIL_degToRad(double degrees) {
    return degrees / 360.0 / 2.0 * _PI;
}

uint16_t UTIL_charToInt(char msb, char lsb) {
    return ( ( (0x00FF & (uint16_t)msb) << 8) | (0x00FF & (uint16_t)lsb) );
}