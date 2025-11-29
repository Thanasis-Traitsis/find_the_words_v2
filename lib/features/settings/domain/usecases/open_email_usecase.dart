import 'package:url_launcher/url_launcher.dart';

class OpenEmailUseCase {
  static const String emailValue = "thanasiswd@gmail.com";

  Future<bool> call({
    String? subject,
    String? body,
  }) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailValue,
      query: _encodeQueryParameters({
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      }),
    );

    try {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      return true;
    } catch (e) {
      return false;
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}