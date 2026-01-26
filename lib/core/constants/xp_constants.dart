import 'package:find_the_words/config/language/app_language.dart';

class XPConstants {
  static const greekConsonants = [
    "Β",
    "Γ",
    "Δ",
    "Ζ",
    "Θ",
    "Κ",
    "Λ",
    "Μ",
    "Ν",
    "Ξ",
    "Π",
    "Ρ",
    "Σ",
    "Τ",
    "Φ",
    "Χ",
    "Ψ",
  ];

  static const Map<String, double> greekLetterRarity = {
    'Α': 1.0,
    'Ε': 1.0,
    'Ο': 1.0,
    'Ι': 1.2,
    'Η': 1.2,
    'Τ': 1.3,
    'Ν': 1.3,
    'Σ': 1.4,
    'Ρ': 1.5,
    'Κ': 1.5,
    'Π': 1.6,
    'Λ': 1.6,
    'Μ': 1.7,
    'Υ': 1.8,
    'Δ': 1.8,
    'Γ': 1.9,
    'Β': 2.0,
    'Ϊ': 2.0,
    'Ω': 2.1,
    'Φ': 2.3,
    'Χ': 2.5,
    'Θ': 2.7,
    'Ξ': 3.0,
    'Ζ': 3.2,
    'Ψ': 3.5,
  };

  static const englishConsonants = [
    "B",
    "C",
    "D",
    "F",
    "G",
    "H",
    "J",
    "K",
    "L",
    "M",
    "N",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "V",
    "W",
    "X",
    "Y",
    "Z",
  ];

  static const Map<String, double> englishLetterRarity = {
    'E': 1.0,
    'A': 1.0,
    'I': 1.0,
    'O': 1.0,
    'N': 1.1,
    'R': 1.1,
    'T': 1.1,
    'L': 1.2,
    'S': 1.2,
    'U': 1.2,

    'D': 1.3,
    'G': 1.3,
    'B': 1.5,
    'C': 1.5,
    'M': 1.5,
    'P': 1.5,
    'F': 1.6,
    'H': 1.6,
    'V': 1.6,
    'W': 1.6,
    'Y': 1.6,

    'K': 2.0,

    'J': 2.5,
    'X': 2.8,

    'Q': 3.5,
    'Z': 3.5,
  };

  static List<String> getConsonants(AppLanguage language) {
    return switch (language) {
      AppLanguage.greek => greekConsonants,
      AppLanguage.english => englishConsonants,
    };
  }

  static Map<String, double> getLetterRarity(AppLanguage language) {
    return switch (language) {
      AppLanguage.greek => greekLetterRarity,
      AppLanguage.english => englishLetterRarity,
    };
  }

  static int getXPForLevel(int level) {
    if (level <= 1) return 800;
    if (level == 2) return 1200;
    if (level == 3) return 1800;
    if (level == 4) return 2500;
    if (level == 5) return 3500;
    if (level == 6) return 4500;
    if (level == 7) return 6000;
    if (level == 8) return 7500;
    if (level == 9) return 9000;
    return 10000 + ((level - 10) * 2000);
  }
}
