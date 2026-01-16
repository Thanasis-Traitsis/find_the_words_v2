import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:flutter/material.dart';

enum ErrorScenarios {
  notEnoughPoints
}

class ErrorUtils {
  static String getErrorMessage(BuildContext context, ErrorScenarios error) {
    switch (error) {
      case ErrorScenarios.notEnoughPoints:
        return context.translate.notEnoughPointsErrorMessage;
    }
  }
}