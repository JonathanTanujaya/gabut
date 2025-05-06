import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    ).format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  // Palet warna premium hitam-emas
  static Color getCategoryColor(String category) {
    const colorMap = {
      'OVO': Color(0xFF4A90E2),         // Biru premium
      'Shopee': Color(0xFFEF8354),      // Oranye elegan
      'Gopay': Color(0xFF4CAF50),       // Hijau premium
      'UKT': Color(0xFFE53935),         // Merah premium
      'Kursus': Color(0xFF9C27B0),      // Ungu premium
      'Lainnya': Color(0xFF757575),     // Abu-abu premium
    };
    return colorMap[category] ?? const Color(0xFFD4AF37); // Default emas
  }
  
  static IconData getCategoryIcon(String category) {
    const iconMap = {
      'OVO': Icons.account_balance_wallet,
      'Shopee': Icons.shopping_bag,
      'Gopay': Icons.payments,
      'UKT': Icons.school,
      'Kursus': Icons.menu_book,
      'Lainnya': Icons.category,
    };
    return iconMap[category] ?? Icons.attach_money;
  }
  
  static String getCategoryDisplayName(String category) {
    const nameMap = {
      'OVO': 'OVO Payment',
      'Shopee': 'Shopee Payment',
      'Gopay': 'Gopay Payment',
      'UKT': 'Biaya Pendidikan',
      'Kursus': 'Biaya Kursus',
      'Lainnya': 'Pengeluaran Lain',
    };
    return nameMap[category] ?? category;
  }
}