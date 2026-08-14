import 'package:ecommerce_app/features/product/data/models/product_model.dart';

abstract class ProductRemoteDataSource {

  Future<List<ProductModel>> getProduct();
  
  Future<ProductModel> getProductById(String id);
}
