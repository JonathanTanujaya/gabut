import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat currency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  static final NumberFormat compactNumber = NumberFormat.compact();

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }
  

  static String formatChartDate(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }
}