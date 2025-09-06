import 'dart:math';

class TokenUtils {
  static String generateGuestToken() {
    return 'g_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
  }

  static String generateAuthenticatedToken(String token) {
    return 'a_$token';
  }
}
