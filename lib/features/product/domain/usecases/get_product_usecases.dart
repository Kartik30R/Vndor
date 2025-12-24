

import 'package:vndor/features/product/domain/entity/product_entity.dart';
import 'package:vndor/features/product/domain/repository/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<ProductEntity>> call(String vendorId) {
    return repository.getProducts(vendorId);
  }
}
