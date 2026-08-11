import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/home_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/product_form_screen.dart';

class AppRouter {
  // Route names
  static const String home = '/';
  static const String productForm = '/product-form';
  static const String productDetail = '/product-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case productForm:
        final product = settings.arguments as Product?;
        return MaterialPageRoute(
          builder: (_) => ProductFormScreen(product: product),
        );

      case productDetail:
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
