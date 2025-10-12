import 'dart:math';

extension StringMixer on String {
  List<String> stringMixer() {
    final chars = split('');
    final random = Random();

    for (var i = chars.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = chars[i];
      chars[i] = chars[j];
      chars[j] = temp;
    }

    return chars;
  }
}
