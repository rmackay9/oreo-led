extern static const double     _PI= 3.1415926535897932384626433;
extern static const double _TWO_PI= 6.2831853071795864769252867;

double Util_degToRad(double degrees) {

    return degrees / 360.0 / 2.0 * _PI;

}