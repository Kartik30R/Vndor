 
import 'package:vndor/features/product/domain/entity/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts(String vendorId);
  Future<void> addProduct(ProductEntity product);
  Future<void> updateProduct(ProductEntity product);
  Future<void> deleteProduct(String productId);
}
