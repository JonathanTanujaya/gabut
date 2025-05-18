import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  int _currentThemeIndex = 0;
  static const String _themeKey = 'theme_index';

  final List<ThemeData> _themes = [
    // Theme 1: Dark Gold Theme
    ThemeData(
      useMaterial3: true,
      primaryColor: Color(0xFFD4AF37),
      scaffoldBackgroundColor: Color(0xFF121212),
      cardColor: Color(0xFF1A1A1A),
      dialogBackgroundColor: Color(0xFF2A2A2A),
      dividerColor: Color(0xFF3A3A3A),
      colorScheme: ColorScheme.dark(
        primary: Color(0xFFD4AF37),
        secondary: Color(0xFFD4AF37),
        tertiary: Color(0xFFC9A032),
        surface: Color(0xFF1A1A1A),
        background: Color(0xFF121212),
        error: Colors.red,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF1A1A1A),
        foregroundColor: Color(0xFFD4AF37),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFD4AF37),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1A1A1A),
        selectedItemColor: Color(0xFFD4AF37),
        unselectedItemColor: Colors.white70,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF2A2A2A),
        actionTextColor: Color(0xFFD4AF37),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF2A2A2A),
        labelStyle: TextStyle(color: Color(0xFFD4AF37)),
        prefixIconColor: Color(0xFFD4AF37),
        suffixIconColor: Color(0xFFD4AF37),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF3A3A3A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF3A3A3A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFD4AF37), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFD4AF37),
          foregroundColor: Colors.black,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Color(0xFFD4AF37),
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xFFD4AF37),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
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
      cardTheme: CardTheme(
        color: Color(0xFF2A2A2A),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),

    // Theme 2: Navy Blue Theme
    ThemeData(
      useMaterial3: true,
      primaryColor: Color(0xFF0A386B),
      scaffoldBackgroundColor: Color(0xFF0A386B),
      cardColor: Color(0xFF072B52),
      dialogBackgroundColor: Color(0xFF154B88),
      dividerColor: Color(0xFF1E5EA6),
      colorScheme: ColorScheme.dark(
        primary: Color(0xFF0A386B),
        secondary: Color(0xFFB22234),
        tertiary: Color(0xFF3B5998),
        surface: Color(0xFF072B52),
        background: Color(0xFF0A386B),
        error: Colors.red[700]!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF0A386B),
        foregroundColor: Color(0xFFB22234),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFB22234),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0A386B),
        selectedItemColor: Color(0xFFB22234),
        unselectedItemColor: Colors.white70,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF154B88),
        actionTextColor: Color(0xFFB22234),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF154B88),
        labelStyle: TextStyle(color: Colors.white),
        prefixIconColor: Colors.white,
        suffixIconColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF1E5EA6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF1E5EA6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFB22234), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red[700]!),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFB22234),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Color(0xFFB22234),
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xFFB22234),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Color(0xFFB22234), fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Color(0xFFB22234), fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFB22234);
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFB22234).withOpacity(0.5);
          return Colors.grey.withOpacity(0.5);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFB22234);
          return Colors.grey;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),
      cardTheme: CardTheme(
        color: Color(0xFF154B88),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),

    // Theme 3: Purple Theme
    ThemeData(
      useMaterial3: true,
      primaryColor: Color(0xFF6A1B9A),
      scaffoldBackgroundColor: Color(0xFF6A1B9A),
      cardColor: Color(0xFF4A148C),
      dialogBackgroundColor: Color(0xFF8E24AA),
      dividerColor: Color(0xFFAB47BC),
      colorScheme: ColorScheme.dark(
        primary: Color(0xFF6A1B9A),
        secondary: Color(0xFF00B8D4),
        tertiary: Color(0xFF9C27B0),
        surface: Color(0xFF4A148C),
        background: Color(0xFF6A1B9A),
        error: Colors.red,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF6A1B9A),
        foregroundColor: Color(0xFF00B8D4),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF00B8D4),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF6A1B9A),
        selectedItemColor: Color(0xFF00B8D4),
        unselectedItemColor: Colors.white70,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF8E24AA),
        actionTextColor: Color(0xFF00B8D4),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF8E24AA),
        labelStyle: TextStyle(color: Colors.white),
        prefixIconColor: Colors.white,
        suffixIconColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFAB47BC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFAB47BC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF00B8D4), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF00B8D4),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Color(0xFF00B8D4),
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xFF00B8D4),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Color(0xFF00B8D4), fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Color(0xFF00B8D4), fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFF00B8D4);
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFF00B8D4).withOpacity(0.5);
          return Colors.grey.withOpacity(0.5);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFF00B8D4);
          return Colors.grey;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),
      cardTheme: CardTheme(
        color: Color(0xFF8E24AA),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),

    // Theme 4: Teal Theme
    ThemeData(
      useMaterial3: true,
      primaryColor: Color(0xFF009688),
      scaffoldBackgroundColor: Color(0xFF009688),
      cardColor: Color(0xFF00695C),
      dialogBackgroundColor: Color(0xFF00897B),
      dividerColor: Color(0xFF26A69A),
      colorScheme: ColorScheme.dark(
        primary: Color(0xFF009688),
        secondary: Color(0xFFFF6D00),
        tertiary: Color(0xFF26A69A),
        surface: Color(0xFF00695C),
        background: Color(0xFF009688),
        error: Colors.red,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF009688),
        foregroundColor: Color(0xFFFF6D00),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFFF6D00),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF009688),
        selectedItemColor: Color(0xFFFF6D00),
        unselectedItemColor: Colors.white70,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF00897B),
        actionTextColor: Color(0xFFFF6D00),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF00897B),
        labelStyle: TextStyle(color: Colors.white),
        prefixIconColor: Colors.white,
        suffixIconColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF26A69A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF26A69A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFFF6D00), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFF6D00),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Color(0xFFFF6D00),
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xFFFF6D00),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Color(0xFFFF6D00), fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Color(0xFFFF6D00), fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFFF6D00);
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFFF6D00).withOpacity(0.5);
          return Colors.grey.withOpacity(0.5);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFFF6D00);
          return Colors.grey;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),
      cardTheme: CardTheme(
        color: Color(0xFF00897B),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),

    // Theme 5: Dark Emerald Theme
    ThemeData(
      useMaterial3: true,
      primaryColor: Color(0xFF006D5B),
      scaffoldBackgroundColor: Color(0xFF006D5B),
      cardColor: Color(0xFF004D40),
      dialogBackgroundColor: Color(0xFF00806A),
      dividerColor: Color(0xFF009688),
      colorScheme: ColorScheme.dark(
        primary: Color(0xFF006D5B),
        secondary: Color(0xFFC0C0C0),
        tertiary: Color(0xFF00846C),
        surface: Color(0xFF004D40),
        background: Color(0xFF006D5B),
        error: Colors.red,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF006D5B),
        foregroundColor: Color(0xFFC0C0C0),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFC0C0C0),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF006D5B),
        selectedItemColor: Color(0xFFC0C0C0),
        unselectedItemColor: Colors.white70,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF00806A),
        actionTextColor: Color(0xFFC0C0C0),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF00806A),
        labelStyle: TextStyle(color: Colors.white),
        prefixIconColor: Colors.white,
        suffixIconColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF009688)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF009688)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFC0C0C0), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFC0C0C0),
          foregroundColor: Color(0xFF006D5B),
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Color(0xFFC0C0C0),
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xFFC0C0C0),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Color(0xFFC0C0C0), fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Color(0xFFC0C0C0), fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFC0C0C0);
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFC0C0C0).withOpacity(0.5);
          return Colors.grey.withOpacity(0.5);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFC0C0C0);
          return Colors.grey;
        }),
        checkColor: MaterialStateProperty.all(Color(0xFF006D5B)),
      ),
      cardTheme: CardTheme(
        color: Color(0xFF00806A),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  ];

  // Theme icons and colors for the theme switcher
  final List<IconData> _themeIcons = [
    Icons.nights_stay,
    Icons.brightness_5,
    Icons.spa,
    Icons.wb_twilight,
    Icons.forest,
  ];

  final List<Color> _themeIconColors = [
    Color(0xFFD4AF37),  // Gold
    Color(0xFF0A386B),  // Navy Blue
    Color(0xFF6A1B9A),  // Purple
    Color(0xFF009688),  // Teal
    Color(0xFF006D5B),  // Emerald
  ];

  final List<Color> _themeAccentColors = [
    Color(0xFFD4AF37),  // Gold accent
    Color(0xFFB22234),  // Red accent
    Color(0xFF00B8D4),  // Teal accent
    Color(0xFFFF6D00),  // Orange accent
    Color(0xFFC0C0C0),  // Silver accent
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