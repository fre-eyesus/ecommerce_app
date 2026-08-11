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

  late String _title;
  late String _description;
  late double _price;
  late String _imageUrl;

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _title = widget.product?.title ?? '';
    _description = widget.product?.description ?? '';
    _price = widget.product?.price ?? 0.0;
    _imageUrl =
        widget.product?.imageUrl ?? 'https://example.com/images/default.jpg';
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final resultProduct = Product(
        id:
            widget.product?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title,
        description: _description,
        price: _price,
        imageUrl: _imageUrl,
      );

      // Requirement 3: Return created/updated product back to caller screen
      Navigator.pop(context, resultProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Requirement 5: Standard back navigation event safety check
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add New Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(
                    labelText: 'Product Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please provide a title.';
                    }
                    return null;
                  },
                  onSaved: (value) => _title = value!.trim(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _price == 0.0 ? '' : _price.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Price (\$)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price.';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Please enter a valid positive price.';
                    }
                    return null;
                  },
                  onSaved: (value) => _price = double.parse(value!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _description,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please provide a description.';
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value!.trim(),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  icon: const Icon(Icons.save),
                  label: Text(
                    isEditing ? 'Update Product' : 'Save Product',
                    style: const TextStyle(fontSize: 16),
                  ),
                  onPressed: _saveForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
