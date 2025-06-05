import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  int _currentThemeIndex = 0;
  static const String _themeKey = 'theme_index';

  final List<ThemeData> _themes = [
    // Theme 1: Dark Gold Theme (tetap sama)
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

    // Theme 2: Midnight Blue & Coral (diperbaiki)
    ThemeData(
      useMaterial3: true,
      primaryColor: Color(0xFF1A237E), // Deep indigo blue
      scaffoldBackgroundColor: Color(0xFF0D1421), // Very dark blue-grey
      cardColor: Color(0xFF1E2A3A), // Dark blue-grey
      dialogBackgroundColor: Color(0xFF263548), // Medium blue-grey
      dividerColor: Color(0xFF37474F),
      colorScheme: ColorScheme.dark(
        primary: Color(0xFF1A237E),
        secondary: Color(0xFFFF6B6B), // Warm coral
        tertiary: Color(0xFF3949AB),
        surface: Color(0xFF1E2A3A),
        background: Color(0xFF0D1421),
        error: Color(0xFFFF5252),
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF1E2A3A),
        foregroundColor: Color(0xFFFF6B6B),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFFF6B6B),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E2A3A),
        selectedItemColor: Color(0xFFFF6B6B),
        unselectedItemColor: Colors.white70,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF263548),
        actionTextColor: Color(0xFFFF6B6B),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF263548),
        labelStyle: TextStyle(color: Color(0xFFB0BEC5)),
        prefixIconColor: Color(0xFFFF6B6B),
        suffixIconColor: Color(0xFFFF6B6B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF37474F)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF37474F)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFFF6B6B), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFFF5252)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFF6B6B),
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
          foregroundColor: Color(0xFFFF6B6B),
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xFFFF6B6B),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Color(0xFFFF6B6B), fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Color(0xFFFF6B6B), fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Color(0xFFB0BEC5)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFFF6B6B);
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFFF6B6B).withOpacity(0.5);
          return Colors.grey.withOpacity(0.5);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFFF6B6B);
          return Colors.grey;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),
      cardTheme: CardTheme(
        color: Color(0xFF263548),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),

    // Theme 3: Deep Purple & Electric Blue (modern purple theme)
    ThemeData(
      useMaterial3: true,
      primaryColor: Color(0xFF2D1B69), // Deep purple
      scaffoldBackgroundColor: Color(0xFF1A0E4E), // Very dark purple
      cardColor: Color(0xFF2A1B5E), // Dark purple
      dialogBackgroundColor: Color(0xFF3C2B7A), // Medium purple
      dividerColor: Color(0xFF4A3A8A),
      colorScheme: ColorScheme.dark(
        primary: Color(0xFF2D1B69),
        secondary: Color(0xFF00D4FF), // Electric blue
        tertiary: Color(0xFF7C4DFF),
        surface: Color(0xFF2A1B5E),
        background: Color(0xFF1A0E4E),
        error: Color(0xFFFF4081),
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF2A1B5E),
        foregroundColor: Color(0xFF00D4FF),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF00D4FF),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF2A1B5E),
        selectedItemColor: Color(0xFF00D4FF),
        unselectedItemColor: Colors.white70,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF3C2B7A),
        actionTextColor: Color(0xFF00D4FF),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF3C2B7A),
        labelStyle: TextStyle(color: Color(0xFFB19CD9)),
        prefixIconColor: Color(0xFF00D4FF),
        suffixIconColor: Color(0xFF00D4FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF4A3A8A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF4A3A8A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF00D4FF), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFFF4081)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF00D4FF),
          foregroundColor: Color(0xFF1A0E4E),
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
          foregroundColor: Color(0xFF00D4FF),
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xFF00D4FF),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Color(0xFF00D4FF), fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Color(0xFF00D4FF), fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Color(0xFFB19CD9)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFF00D4FF);
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFF00D4FF).withOpacity(0.5);
          return Colors.grey.withOpacity(0.5);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFF00D4FF);
          return Colors.grey;
        }),
        checkColor: MaterialStateProperty.all(Color(0xFF1A0E4E)),
      ),
      cardTheme: CardTheme(
        color: Color(0xFF3C2B7A),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),

    // Theme 4: Forest Green & Amber (earthy nature theme)
    ThemeData(
      useMaterial3: true,
      primaryColor: Color(0xFF1B5E20), // Forest green
      scaffoldBackgroundColor: Color(0xFF0D2818), // Very dark green
      cardColor: Color(0xFF1C3A2E), // Dark green-grey
      dialogBackgroundColor: Color(0xFF2E5D3E), // Medium green
      dividerColor: Color(0xFF4CAF50),
      colorScheme: ColorScheme.dark(
        primary: Color(0xFF1B5E20),
        secondary: Color(0xFFFFC107), // Warm amber
        tertiary: Color(0xFF388E3C),
        surface: Color(0xFF1C3A2E),
        background: Color(0xFF0D2818),
        error: Color(0xFFFF5722),
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF1C3A2E),
        foregroundColor: Color(0xFFFFC107),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFFFC107),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1C3A2E),
        selectedItemColor: Color(0xFFFFC107),
        unselectedItemColor: Colors.white70,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF2E5D3E),
        actionTextColor: Color(0xFFFFC107),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF2E5D3E),
        labelStyle: TextStyle(color: Color(0xFFA5D6A7)),
        prefixIconColor: Color(0xFFFFC107),
        suffixIconColor: Color(0xFFFFC107),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF4CAF50)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF4CAF50)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFFFC107), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFFF5722)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFFC107),
          foregroundColor: Color(0xFF0D2818),
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
          foregroundColor: Color(0xFFFFC107),
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xFFFFC107),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Color(0xFFFFC107), fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Color(0xFFFFC107), fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Color(0xFFA5D6A7)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFFFC107);
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFFFC107).withOpacity(0.5);
          return Colors.grey.withOpacity(0.5);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFFFC107);
          return Colors.grey;
        }),
        checkColor: MaterialStateProperty.all(Color(0xFF0D2818)),
      ),
      cardTheme: CardTheme(
        color: Color(0xFF2E5D3E),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),

    // Theme 5: Rose Gold & Slate (elegant modern theme)
    ThemeData(
      useMaterial3: true,
      primaryColor: Color(0xFF37474F), // Blue grey
      scaffoldBackgroundColor: Color(0xFF1C2025), // Very dark grey
      cardColor: Color(0xFF2D3135), // Dark grey
      dialogBackgroundColor: Color(0xFF3C4145), // Medium grey
      dividerColor: Color(0xFF4A5055),
      colorScheme: ColorScheme.dark(
        primary: Color(0xFF37474F),
        secondary: Color(0xFFE91E63), // Rose pink
        tertiary: Color(0xFF546E7A),
        surface: Color(0xFF2D3135),
        background: Color(0xFF1C2025),
        error: Color(0xFFFF6B6B),
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF2D3135),
        foregroundColor: Color(0xFFE91E63),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFE91E63),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF2D3135),
        selectedItemColor: Color(0xFFE91E63),
        unselectedItemColor: Colors.white70,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF3C4145),
        actionTextColor: Color(0xFFE91E63),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF3C4145),
        labelStyle: TextStyle(color: Color(0xFFB0BEC5)),
        prefixIconColor: Color(0xFFE91E63),
        suffixIconColor: Color(0xFFE91E63),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF4A5055)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF4A5055)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE91E63), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFFF6B6B)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE91E63),
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
          foregroundColor: Color(0xFFE91E63),
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xFFE91E63),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Color(0xFFB0BEC5)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFE91E63);
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFE91E63).withOpacity(0.5);
          return Colors.grey.withOpacity(0.5);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFE91E63);
          return Colors.grey;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),
      cardTheme: CardTheme(
        color: Color(0xFF3C4145),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  ];

  // Theme icons and colors for the theme switcher (updated)
  final List<IconData> _themeIcons = [
    Icons.nights_stay, // Dark Gold
    Icons.water, // Midnight Blue
    Icons.auto_awesome, // Deep Purple
    Icons.eco, // Forest Green
    Icons.favorite, // Rose Gold
  ];

  final List<Color> _themeIconColors = [
    Color(0xFFD4AF37), // Gold
    Color(0xFF1A237E), // Deep indigo
    Color(0xFF2D1B69), // Deep purple
    Color(0xFF1B5E20), // Forest green
    Color(0xFF37474F), // Blue grey
  ];

  final List<Color> _themeAccentColors = [
    Color(0xFFD4AF37), // Gold accent
    Color(0xFFFF6B6B), // Coral accent
    Color(0xFF00D4FF), // Electric blue accent
    Color(0xFFFFC107), // Amber accent
    Color(0xFFE91E63), // Rose pink accent
  ];

  ThemeProvider() {
    _loadThemePreference();
  }
  ThemeData get theme => _themes[_currentThemeIndex];
  int get currentThemeIndex => _currentThemeIndex;
  IconData get themeIcon => _themeIcons[_currentThemeIndex];
  Color get themeIconColor => _themeIconColors[_currentThemeIndex];
  Color get themeAccentColor => _themeAccentColors[_currentThemeIndex];
  bool get isDarkTheme => _currentThemeIndex == 0;
  void nextTheme() {
    _currentThemeIndex = (_currentThemeIndex + 1) % _themes.length;
    _saveThemePreference();
    notifyListeners();
  }

  void setTheme(int index) {
    if (index >= 0 && index < _themes.length) {
      _currentThemeIndex = index;
      _saveThemePreference();
      notifyListeners();
    }
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