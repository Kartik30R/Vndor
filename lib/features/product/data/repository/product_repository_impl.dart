import 'package:vndor/features/product/data/datasource/product_remote_datasource.dart';
import 'package:vndor/features/product/data/model/product_model.dart';
import 'package:vndor/features/product/domain/entity/product_entity.dart';
import 'package:vndor/features/product/domain/repository/product_repository.dart';


class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProductEntity>> getProducts(String vendorId) async {
    return await remoteDataSource.getProducts(vendorId);
  }

 @override
Future<void> addProduct(ProductEntity product) async {
  final model = ProductModel(
    id: '',
    name: product.name,
    price: product.price,
    stock: product.stock,
    category: product.category,
    imageUrl: product.imageUrl,
    vendorId: product.vendorId,
  );

  await remoteDataSource.addProduct(model);
}


  @override
  Future<void> updateProduct(ProductEntity product) async {
    final model = ProductModel(
      id: product.id,
      name: product.name,
      price: product.price,
      stock: product.stock,
      category: product.category,
      imageUrl: product.imageUrl,
      vendorId: product.vendorId,
    );

    await remoteDataSource.updateProduct(model);
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await remoteDataSource.deleteProduct(productId);
  }
}
