import 'package:flutter/material.dart';
import '../models/product.dart';
import '../routes/app_router.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Product _currentProduct;

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.product;
  }

  // Requirement 3: Pass modified data back through route popped result
  Future<void> _navigateToEdit() async {
    final updatedProduct = await Navigator.pushNamed(
      context,
      AppRouter.productForm,
      arguments: _currentProduct,
    ) as Product?;

    if (updatedProduct != null) {
      setState(() {
        _currentProduct = updatedProduct;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Requirement 5: Ensure system back button returns the updated model instance
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _currentProduct);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentProduct.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Product',
              onPressed: _navigateToEdit,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentProduct.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                '\$${_currentProduct.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Divider(height: 32),
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                _currentProduct.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.4,
                      color: Colors.grey[800],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}