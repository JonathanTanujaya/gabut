import 'package:flutter/material.dart';

Color getEfficiencyColor(double kmPerLiter, ThemeData theme) {
  if (kmPerLiter < 8) return theme.colorScheme.error;
  if (kmPerLiter < 12) return theme.colorScheme.tertiary;
  if (kmPerLiter < 15) return theme.colorScheme.secondary.withOpacity(0.7);
  return theme.colorScheme.secondary;
}

double calculateProgressValue(double kmPerLiter, [double max = 20]) {
  return kmPerLiter / max;
}