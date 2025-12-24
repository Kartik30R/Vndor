import 'package:vndor/features/product/domain/entity/product_entity.dart';
import 'package:vndor/features/product/domain/repository/product_repository.dart';



class AddProductUseCase {
  final ProductRepository repository;

  AddProductUseCase(this.repository);

  Future<void> call(ProductEntity product) {
    return repository.addProduct(product);
  }
}
