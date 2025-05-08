import 'package:flutter/material.dart';

Color getEfficiencyColor(double kmPerLiter) {
  if (kmPerLiter < 8) return Colors.red;
  if (kmPerLiter < 12) return Colors.orange;
  if (kmPerLiter < 15) return Colors.amber;
  return Colors.green;
}

double calculateProgressValue(double kmPerLiter, [double max = 20]) {
  return kmPerLiter / max;
}