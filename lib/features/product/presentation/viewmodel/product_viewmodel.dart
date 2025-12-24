import 'package:flutter/material.dart';
import '../../../../core/error/failure.dart';

import '../../domain/entity/product_entity.dart';
import '../../domain/usecases/get_product_usecases.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';

enum ProductState {
  initial,
  loading,
  loaded,
  submitting,  
  error,
}

class ProductViewModel extends ChangeNotifier {
  final GetProductsUseCase getProducts;
  final AddProductUseCase addProduct;
  final UpdateProductUseCase updateProduct;
  final DeleteProductUseCase deleteProduct;

  ProductViewModel({
    required this.getProducts,
    required this.addProduct,
    required this.updateProduct,
    required this.deleteProduct,
  });

  ProductState _state = ProductState.initial;
  ProductState get state => _state;

  List<ProductEntity> products = [];
  String? errorMessage;

  void _setState(ProductState state) {
    _state = state;
    notifyListeners();
  }

  /// LOAD PRODUCTS
  Future<void> loadProducts(String vendorId) async {
    _setState(ProductState.loading);
    try {
      products = await getProducts(vendorId);
      _setState(ProductState.loaded);
    } catch (e) {
      errorMessage = e is Failure ? e.message : 'Failed to load products';
      _setState(ProductState.error);
    }
  }

Future<bool> add(ProductEntity product) async {
 
  _setState(ProductState.submitting);
  try {
    await addProduct(product);
    await loadProducts(product.vendorId);
    _setState(ProductState.loaded);
    return true;
  } catch (e, s) {
     debugPrintStack(stackTrace: s);
    errorMessage = 'Failed to add product';
    _setState(ProductState.error);
    return false;
  }
}



  /// UPDATE PRODUCT
  Future<bool> update(ProductEntity product) async {
    _setState(ProductState.submitting);
    try {
      await updateProduct(product);
      await loadProducts(product.vendorId);
      return true;
    } catch (e) {
      errorMessage = e is Failure ? e.message : 'Failed to update product';
      _setState(ProductState.error);
      return false;
    }
  }

  /// DELETE PRODUCT
  Future<bool> remove(String productId, String vendorId) async {
    _setState(ProductState.submitting);
    try {
      await deleteProduct(productId);
      await loadProducts(vendorId);
      return true;
    } catch (e) {
      errorMessage = e is Failure ? e.message : 'Failed to delete product';
      _setState(ProductState.error);
      return false;
    }
  }
}
