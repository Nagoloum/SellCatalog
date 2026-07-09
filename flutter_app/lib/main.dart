import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/products_screen.dart';

const Color _brandRed = Color(0xFFC62828);
const Color _brandRedDark = Color(0xFF8E1B1B);
const Color _appTextColor = Color(0xFF222222);

void main() {
  runApp(const SellCatalogApp());
}

class SellCatalogApp extends StatelessWidget {
  const SellCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SellCatalog',
      theme: _buildTheme(),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        ProductsScreen.routeName: (_) => const ProductsScreen(),
        ProductDetailScreen.routeName: (_) => const ProductDetailScreen(),
      },
    );
  }
}

ThemeData _buildTheme() {
  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: _brandRed,
        brightness: Brightness.light,
      ).copyWith(
        primary: _brandRed,
        onPrimary: Colors.white,
        secondary: _brandRedDark,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: _appTextColor,
      );

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: colorScheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: _brandRed,
      centerTitle: true,
      elevation: 0,
      surfaceTintColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _brandRed, width: 2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _brandRed,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
