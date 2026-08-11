import 'package:flutter/material.dart';
import '../models/product.dart';
import '../routes/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Initial state / mock product list
  final List<Product> _products = [
    Product(
      id: '1',
      title: 'Wireless Ergonomic Mouse',
      description: 'Precision optical mouse with custom DPI switches.',
      price: 29.99,
      imageUrl: 'https://example.com/images/mouse.jpg',
    ),
    Product(
      id: '2',
      title: 'Mechanical Keyboard',
      description: 'Tactile switches with customizable RGB backlighting.',
      price: 89.99,
      imageUrl: 'https://example.com/images/keyboard.jpg',
    ),
  ];

  // Requirement 3: Handle state when adding a new product
  Future<void> _navigateAndAddProduct() async {
    final newProduct = await Navigator.pushNamed(
      context,
      AppRouter.productForm,
    ) as Product?;

    if (newProduct != null) {
      setState(() {
        _products.add(newProduct);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${newProduct.title} created!')),
        );
      }
    }
  }

  // Requirement 3: Handle state when viewing/editing an existing product
  Future<void> _navigateToDetail(Product product) async {
    final updatedProduct = await Navigator.pushNamed(
      context,
      AppRouter.productDetail,
      arguments: product,
    ) as Product?;

    if (updatedProduct != null) {
      setState(() {
        final index = _products.indexWhere((p) => p.id == updatedProduct.id);
        if (index != -1) {
          _products[index] = updatedProduct;
        }
      });
    }
  }

  void _deleteProduct(String id) {
    setState(() {
      _products.removeWhere((p) => p.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product deleted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Inventory'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateAndAddProduct,
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
      body: _products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  const Text('No products available. Add one!'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    title: Text(
                      product.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () => _confirmDelete(product),
                        ),
                      ],
                    ),
                    onTap: () => _navigateToDetail(product),
                  ),
                );
              },
            ),
    );
  }

  void _confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              _deleteProduct(product.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}