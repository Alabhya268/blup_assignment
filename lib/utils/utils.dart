import 'dart:math';

import 'package:flutter/animation.dart';

class Utils {
  static double findDistance(Offset offset1, Offset offset2) {
    num sqOfdist =
        pow((offset2.dx - offset1.dx), 2) + pow((offset2.dy - offset1.dy), 2);
    double dist = sqrt(sqOfdist);
    return dist;
  }

  static double findMiddle(double x) {
    return x / 2;
  }
}
