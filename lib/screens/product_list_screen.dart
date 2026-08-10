import 'package:flutter/material.dart';
import '../models/product.dart';
import '../routes/app_router.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample static data for testing UI and navigation
    final List<Product> sampleProducts = [
      Product(
        id: '1',
        title: 'Wireless Headphones',
        description: 'Noise-canceling over-ear headphones.',
        price: 199.99,
        imageUrl: 'https://via.placeholder.com/150',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Product',
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.productForm);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sampleProducts.length,
        itemBuilder: (context, index) {
          final product = sampleProducts[index];
          return ListTile(
            title: Text(product.title),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // TODO: Implement Delete logic
              },
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRouter.productDetail,
                arguments: product,
              );
            },
          );
        },
      ),
    );
  }
}