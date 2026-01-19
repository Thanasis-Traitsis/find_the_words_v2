import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  /// Formats date as "17 Jan 2025"
  String toShortDate() {
    return DateFormat('d MMM yyyy').format(this);
  }

  /// Formats date as "January 17, 2025"
  String toLongDate() {
    return DateFormat('MMMM d, yyyy').format(this);
  }

  /// Formats date as "17/01/2025"
  String toNumericDate() {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}