extension DoubleFormatting on double {
  String toProgressString() {
    return this % 1 == 0 
        ? toInt().toString() 
        : toStringAsFixed(1);
  }
} 