import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/products_screen.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        ProductsScreen.routeName: (_) => const ProductsScreen(),
        ProductDetailScreen.routeName: (_) => const ProductDetailScreen(),
      },
    );
  }
}
