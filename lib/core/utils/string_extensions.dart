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

  String toUpperCaseGreek() {
    String result = toUpperCase();

    const Map<String, String> greekAccentMap = {
      
      // Uppercase vowels with tonos (΄)
      'Ά': 'Α', // Alpha with tonos
      'Έ': 'Ε', // Epsilon with tonos
      'Ή': 'Η', // Eta with tonos
      'Ί': 'Ι', // Iota with tonos
      'Ό': 'Ο', // Omicron with tonos
      'Ύ': 'Υ', // Upsilon with tonos
      'Ώ': 'Ω', // Omega with tonos
      // Lowercase vowels with tonos (will be uppercase already, but just in case)
      'ά': 'Α',
      'έ': 'Ε',
      'ή': 'Η',
      'ί': 'Ι',
      'ό': 'Ο',
      'ύ': 'Υ',
      'ώ': 'Ω',

      // Iota with dialytika
      'Ϊ': 'Ι',
      'ϊ': 'Ι',
      'ΐ': 'Ι', // Iota with dialytika and tonos

      // Upsilon with dialytika
      'Ϋ': 'Υ',
      'ϋ': 'Υ',
      'ΰ': 'Υ', // Upsilon with dialytika and tonos
    };

    greekAccentMap.forEach((accented, plain) {
      result = result.replaceAll(accented, plain);
    });

    return result;
  }
}
