import 'dart:io';
import 'dart:math';

double radians(double degrees) => degrees * pi / 180;
double degrees(double radians) => radians * 180 / pi;

bool isDesktop = Platform.isMacOS || Platform.isWindows || Platform.isLinux;
bool isMobile = Platform.isIOS || Platform.isAndroid;
