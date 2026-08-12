import 'dart:convert';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';

// Adjust these imports to match your project path
import '../../../../fixtures/fixture_reader.dart';

void main() {
  // Define test fixture instance
  const tProductModel = ProductModel(
    id: '1',
    name: 'Nike Air Max',
    description: 'High-performance running shoes',
    price: 120.0,
    imageUrl: 'https://example.com/image.png',
  );

  test('should be a subclass of Product entity', () async {
    // Assert
    expect(tProductModel, isA<Product>());
  });

  group('fromJson', () {
    test(
      'should return a valid model when the JSON price is a double/number',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('product.json'));

        // Act
        final result = ProductModel.fromJson(jsonMap);

        // Assert
        expect(result, tProductModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // Act
        final result = tProductModel.toJson();

        // Assert
        final expectedMap = {
          'id': '1',
          'name': 'Nike Air Max',
          'description': 'High-performance running shoes',
          'price': 120.0,
          'imageUrl': 'https://example.com/image.png',
        };
        expect(result, expectedMap);
      },
    );
  });
}