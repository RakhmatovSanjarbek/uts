import 'package:intl/intl.dart';

class DateUtilsHelper {
  static String formatDay(int ms) {
    final date = DateTime.fromMillisecondsSinceEpoch(ms);
    return DateFormat('dd MMMM yyyy').format(date);
  }

  static String formatTime(int ms) {
    final date = DateTime.fromMillisecondsSinceEpoch(ms);
    return DateFormat('HH:mm').format(date);
  }
}
