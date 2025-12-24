import 'package:vndor/features/product/domain/repository/product_repository.dart';

 
class DeleteProductUseCase {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  Future<void> call(String productId) {
    return repository.deleteProduct(productId);
  }
}
