import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_data_source.dart';
import '../datasources/network_info.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Product>> getProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getProducts();
        await localDataSource.cacheProducts(remoteProducts);
        return remoteProducts;
      } catch (_) {
        // Fallback to local cache on remote error
        final localProducts = await localDataSource.getLastCachedProducts();
        return localProducts;
      }
    } else {
      final localProducts = await localDataSource.getLastCachedProducts();
      return localProducts;
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        return await remoteDataSource.getProductById(id);
      } catch (_) {
        final localProducts = await localDataSource.getLastCachedProducts();
        return localProducts.firstWhere((p) => p.id == id, orElse: () => localProducts.first);
      }
    } else {
      final localProducts = await localDataSource.getLastCachedProducts();
      return localProducts.firstWhere((p) => p.id == id, orElse: () => localProducts.first);
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    final productModel = ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );
    final createdModel = await remoteDataSource.createProduct(productModel);
    
    // Update local cache as well
    final currentCached = await localDataSource.getLastCachedProducts();
    final updatedList = List<ProductModel>.from(currentCached)..add(createdModel);
    await localDataSource.cacheProducts(updatedList);

    return createdModel;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final productModel = ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );
    final updatedModel = await remoteDataSource.updateProduct(productModel);

    // Update local cache
    final currentCached = await localDataSource.getLastCachedProducts();
    final updatedList = currentCached.map((p) => p.id == updatedModel.id ? updatedModel : p).toList();
    await localDataSource.cacheProducts(updatedList);

    return updatedModel;
  }

  @override
  Future<void> deleteProduct(String id) async {
    await remoteDataSource.deleteProduct(id);

    // Update local cache
    final currentCached = await localDataSource.getLastCachedProducts();
    final updatedList = currentCached.where((p) => p.id != id).toList();
    await localDataSource.cacheProducts(updatedList);
  }
}
