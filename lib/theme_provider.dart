import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  static final Color _seedColor = const Color.fromARGB(255, 69, 70, 62);

  static final TextTheme _textTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 57),
    displayMedium: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 45),
    displaySmall: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 36),
    headlineLarge: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 32),
    headlineMedium: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 28),
    headlineSmall: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 24),
    titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 22),
    titleMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
    titleSmall: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
    bodyLarge: GoogleFonts.poppins(fontSize: 16),
    bodyMedium: GoogleFonts.poppins(fontSize: 14),
    bodySmall: GoogleFonts.poppins(fontSize: 12),
    labelLarge: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
    labelMedium: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 12),
    labelSmall: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 11),
  );

  ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.light,
          surface: Colors.white,
          onSurface: const Color(0xFF1E1E1E),
          secondary: const Color(0xFFF5F5F5),
          onSecondary: const Color(0xFF1E1E1E),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6F7),
        textTheme: _textTheme.apply(
          bodyColor: const Color(0xFF1E1E1E),
          displayColor: const Color(0xFF1E1E1E),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: const Color(0xFF1E1E1E),
          titleTextStyle: _textTheme.titleLarge?.copyWith(color: const Color(0xFF1E1E1E)),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: _textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _seedColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: _textTheme.labelLarge,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: _seedColor,
          unselectedItemColor: Colors.grey[400],
        ),
      );

  ThemeData get darkTheme {
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
      surface: const Color(0xFF121212),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme.copyWith(
        surface: const Color(0xFF1E1E1E),
        onSurface: Colors.white,
        secondary: const Color(0xFF2C2C2C),
        onSecondary: Colors.white.withAlpha(222),
      ),
      scaffoldBackgroundColor: darkColorScheme.surface,
      textTheme: _textTheme.apply(
        bodyColor: Colors.white.withAlpha(222),
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        titleTextStyle: _textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: _textTheme.bodyMedium?.copyWith(color: Colors.white.withAlpha(222)),
        hintStyle: _textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: _textTheme.labelLarge,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: Colors.white, // Changed from primary to white
        unselectedItemColor: Colors.grey[600],
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return darkColorScheme.primary;
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return darkColorScheme.primary.withAlpha(128);
          return Colors.grey.withAlpha(128);
        }),
      ),
      listTileTheme: ListTileThemeData(
        textColor: Colors.white.withAlpha(222),
        iconColor: Colors.white.withAlpha(222),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: darkColorScheme.primary),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        titleTextStyle: _textTheme.titleLarge?.copyWith(color: Colors.white),
        contentTextStyle: _textTheme.bodyMedium?.copyWith(color: Colors.white.withAlpha(222)),
      ),
    );
  }
}
