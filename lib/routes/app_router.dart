import 'package:flutter/material.dart';

import '../models/product.dart';
import '../screens/product_list_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/product_form_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String productDetail = '/product-detail';
  static const String productForm = '/product-form';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const ProductListScreen(),
        );

      case productDetail:
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        );

      case productForm:
        // Pass an existing product if editing; null if creating a new one
        final product = settings.arguments as Product?;
        return MaterialPageRoute(
          builder: (_) => ProductFormScreen(product: product),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}