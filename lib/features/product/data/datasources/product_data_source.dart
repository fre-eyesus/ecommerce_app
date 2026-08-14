import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
  Future<ProductModel> createProduct(ProductModel productModel);
  Future<ProductModel> updateProduct(ProductModel productModel);
  Future<void> deleteProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://fakestoreapi.com'; // or mock API

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts() async {
    // For robust demo, we can either call real API or return mock list converted to models
    // Let's implement real API call with fallback/mock if needed
    try {
      final response = await client.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        final List decoded = json.decode(response.body);
        return decoded.map((jsonItem) => ProductModel.fromJson({
          'id': jsonItem['id'].toString(),
          'name': jsonItem['title'],
          'description': jsonItem['description'],
          'price': (jsonItem['price'] as num).toDouble(),
          'imageUrl': jsonItem['image'],
        })).toList();
      } else {
        throw Exception('Failed to load products from server');
      }
    } catch (_) {
      // Fallback mock remote data if network fails or API is unreachable
      return const [
        ProductModel(
          id: '1',
          name: 'Wireless Ergonomic Mouse',
          description: 'Precision optical mouse with custom DPI switches.',
          price: 29.99,
          imageUrl: 'https://example.com/images/mouse.jpg',
        ),
        ProductModel(
          id: '2',
          name: 'Mechanical Keyboard',
          description: 'Tactile switches with customizable RGB backlighting.',
          price: 89.99,
          imageUrl: 'https://example.com/images/keyboard.jpg',
        ),
      ];
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final products = await getProducts();
    return products.firstWhere((p) => p.id == id, orElse: () => products.first);
  }

  @override
  Future<ProductModel> createProduct(ProductModel productModel) async {
    return productModel;
  }

  @override
  Future<ProductModel> updateProduct(ProductModel productModel) async {
    return productModel;
  }

  @override
  Future<void> deleteProduct(String id) async {
    // no-op for remote mock
  }
}

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getLastCachedProducts();
  Future<void> cacheProducts(List<ProductModel> productModels);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const cachedProductsKey = 'CACHED_PRODUCTS';

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ProductModel>> getLastCachedProducts() async {
    final jsonString = sharedPreferences.getString(cachedProductsKey);
    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      return decoded.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      // Default local cache if empty
      return const [
        ProductModel(
          id: '1',
          name: 'Wireless Ergonomic Mouse',
          description: 'Precision optical mouse with custom DPI switches.',
          price: 29.99,
          imageUrl: 'https://example.com/images/mouse.jpg',
        ),
        ProductModel(
          id: '2',
          name: 'Mechanical Keyboard',
          description: 'Tactile switches with customizable RGB backlighting.',
          price: 89.99,
          imageUrl: 'https://example.com/images/keyboard.jpg',
        ),
      ];
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> productModels) async {
    final jsonList = productModels.map((p) => p.toJson()).toList();
    await sharedPreferences.setString(cachedProductsKey, json.encode(jsonList));
  }
}
