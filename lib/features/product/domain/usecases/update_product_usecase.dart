import 'package:vndor/features/product/domain/entity/product_entity.dart';
import 'package:vndor/features/product/domain/repository/product_repository.dart';



class UpdateProductUseCase {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  Future<void> call(ProductEntity product) {
    return repository.updateProduct(product);
  }
}
