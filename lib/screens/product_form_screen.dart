import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  bool get isEditing => widget.product != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.product?.title ?? '',
                decoration: const InputDecoration(labelText: 'Product Title'),
                // TODO: Add form fields for price, description, image URL
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // TODO: Save logic (Create vs Update)
                  Navigator.pop(context);
                },
                child: Text(isEditing ? 'Update Product' : 'Create Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}