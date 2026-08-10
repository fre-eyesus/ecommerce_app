import 'package:flutter/material.dart';
import '../models/product.dart';
import '../routes/app_router.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Product',
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRouter.productForm,
                arguments: product,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.green,
                  ),
            ),
            const SizedBox(height: 16),
            Text(product.description),
          ],
        ),
      ),
    );
  }
}