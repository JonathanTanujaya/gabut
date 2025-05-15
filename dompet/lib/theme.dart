import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  int _currentThemeIndex = 0;
  static const String _themeKey = 'theme_index';

  final List<ThemeData> _themes = [
    // Theme 1: Dark with Gold Accent (unchanged)
    ThemeData(
      primaryColor: Color(0xFFD4AF37),      // Gold primary
      scaffoldBackgroundColor: Color(0xFF121212),
      cardColor: Color(0xFF1A1A1A),
      dialogBackgroundColor: Color(0xFF1E1E1E),
      dividerColor: Color(0xFF333333),
      colorScheme: ColorScheme.dark(
        primary: Color(0xFFD4AF37),         // Gold primary
        secondary: Color(0xFFD4AF37),       // Gold accent (secondary)
        tertiary: Color(0xFFC9A032),        // Slightly darker gold for tertiary actions
        surface: Color(0xFF1A1A1A),
        background: Color(0xFF121212),
        error: Colors.red,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF121212),
        foregroundColor: Colors.white,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF1A1A1A),
        actionTextColor: Color(0xFFD4AF37),  // Gold for actions
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white70),
        prefixIconColor: Colors.white70,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF333333)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF333333)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD4AF37)),  // Gold border when focused
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFD4AF37),  // Gold background
          foregroundColor: Colors.black,       // Black text
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Color(0xFFD4AF37),  // Gold text
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFD4AF37);
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFD4AF37).withOpacity(0.5);
          return Colors.grey.withOpacity(0.5);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFD4AF37);
          return Colors.grey;
        }),
        checkColor: MaterialStateProperty.all(Colors.black),
      ),
    ),
    
    // Theme 2: Light with Navy Blue and Red Accent
    ThemeData(
      primaryColor: Color(0xFF0A386B),       // Red accent
      scaffoldBackgroundColor: Color(0xFFF9F9F9),
      cardColor: Color(0xFFF0F0F0),
      dialogBackgroundColor: Color(0xFFE5E5E5),
      dividerColor: Color(0xFFDDDDDD),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF0A386B),
        foregroundColor: Colors.white,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF0A386B),
        actionTextColor: Color(0xFFB22234),  // Red for actions
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Color(0xFF0A386B)),
        prefixIconColor: Color(0xFF0A386B),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFDDDDDD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFDDDDDD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0A386B)),  // Navy blue border when focused
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0A386B),  // Navy blue background
          foregroundColor: Colors.white,       // White text
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Color(0xFFB22234),  // Red text
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFF0A386B);
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFF0A386B).withOpacity(0.5);
          return Colors.grey.withOpacity(0.5);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFF0A386B);
          return Colors.grey;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF212121)),
        bodyMedium: TextStyle(color: Color(0xFF212121)),
      ), colorScheme: ColorScheme.light(
        primary: Color(0xFF0A386B),         // Navy blue primary
        secondary: Color(0xFFB22234),       // Red accent (secondary)
        tertiary: Color(0xFF3B5998),        // Lighter blue for tertiary actions
        surface: Color(0xFFF0F0F0),
        background: Color(0xFFF9F9F9),
        error: Colors.red[700]!,
      ).copyWith(secondary: Color(0xFFB22234)),
    ),
    
    // Theme 3: Light with Purple and Teal Accent
    ThemeData(
      primaryColor: Color(0xFF6A1B9A),       // Teal accent
      scaffoldBackgroundColor: Color(0xFFEEEEEE),
      cardColor: Color(0xFFFAFAFA),
      dialogBackgroundColor: Color(0xFFF3E5F5),
      dividerColor: Color(0xFFE0E0E0),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF6A1B9A),
        actionTextColor: Color(0xFF00B8D4),  // Teal for actions
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Color(0xFF6A1B9A)),
        prefixIconColor: Color(0xFF6A1B9A),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6A1B9A)),  // Purple border when focused
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF6A1B9A),  // Purple background
          foregroundColor: Colors.white,       // White text
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Color(0xFF00B8D4),  // Teal text
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFF6A1B9A);
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFF6A1B9A).withOpacity(0.5);
          return Colors.grey.withOpacity(0.5);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFF6A1B9A);
          return Colors.grey;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF4A148C)),
        bodyMedium: TextStyle(color: Color(0xFF4A148C)),
      ), colorScheme: ColorScheme.light(
        primary: Color(0xFF6A1B9A),         // Purple primary
        secondary: Color(0xFF00B8D4),       // Teal accent (secondary)
        tertiary: Color(0xFF9C27B0),        // Lighter purple for tertiary actions
        surface: Color(0xFFFAFAFA),
        background: Color(0xFFEEEEEE),
        error: Colors.red,
      ).copyWith(secondary: Color(0xFF00B8D4)),
    ),
    
    // Theme 4: Light with Teal and Orange Accent
    ThemeData(
      primaryColor: Color(0xFF009688),       // Orange accent
      scaffoldBackgroundColor: Color(0xFFFFFFFF),
      cardColor: Color(0xFFF5F5F5),
      dialogBackgroundColor: Color(0xFFE0F2F1),
      dividerColor: Color(0xFFEEEEEE),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF009688),
        foregroundColor: Colors.white,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF009688),
        actionTextColor: Color(0xFFFF6D00),  // Orange for actions
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Color(0xFF009688)),
        prefixIconColor: Color(0xFF009688),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFEEEEEE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFEEEEEE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF009688)),  // Teal border when focused
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF009688),  // Teal background
          foregroundColor: Colors.white,       // White text
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Color(0xFFFF6D00),  // Orange text
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFF009688);
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFF009688).withOpacity(0.5);
          return Colors.grey.withOpacity(0.5);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFF009688);
          return Colors.grey;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF212121)),
        bodyMedium: TextStyle(color: Color(0xFF212121)),
      ), colorScheme: ColorScheme.light(
        primary: Color(0xFF009688),         // Teal primary
        secondary: Color(0xFFFF6D00),       // Orange accent (secondary)
        tertiary: Color(0xFF26A69A),        // Lighter teal for tertiary actions
        surface: Color(0xFFF5F5F5),
        background: Color(0xFFFFFFFF),
        error: Colors.red,
      ).copyWith(secondary: Color(0xFFFF6D00)),
    ),
  ];

  // Theme icons and colors remain unchanged
  final List<IconData> _themeIcons = [
    Icons.nights_stay,
    Icons.brightness_5,
    Icons.spa,
    Icons.wb_twilight,
  ];

  final List<Color> _themeIconColors = [
    Color(0xFFD4AF37),  // Gold (Theme 1)
    Color(0xFF0A386B),  // Navy Blue (Theme 2)
    Color(0xFF6A1B9A),  // Purple (Theme 3)
    Color(0xFF009688),  // Teal (Theme 4)
  ];

  // Accent colors for each theme
  final List<Color> _themeAccentColors = [
    Color(0xFFD4AF37),  // Gold accent (Theme 1)
    Color(0xFFB22234),  // Red accent (Theme 2)
    Color(0xFF00B8D4),  // Teal accent (Theme 3)
    Color(0xFFFF6D00),  // Orange accent (Theme 4)
  ];

  ThemeProvider() {
    _loadThemePreference();
  }

  ThemeData get theme => _themes[_currentThemeIndex];
  IconData get themeIcon => _themeIcons[_currentThemeIndex];
  Color get themeIconColor => _themeIconColors[_currentThemeIndex];
  Color get themeAccentColor => _themeAccentColors[_currentThemeIndex];
  bool get isDarkTheme => _currentThemeIndex == 0;

  void nextTheme() {
    _currentThemeIndex = (_currentThemeIndex + 1) % _themes.length;
    _saveThemePreference();
    notifyListeners();
  }

  Future<void> _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, _currentThemeIndex);
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _currentThemeIndex = prefs.getInt(_themeKey) ?? 0;
    notifyListeners();
  }
}