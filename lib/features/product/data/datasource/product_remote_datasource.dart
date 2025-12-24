import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vndor/features/product/data/model/product_model.dart';
import '../../../../core/error/exception.dart';
 
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts(String vendorId);
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String productId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<ProductModel>> getProducts(String vendorId) async {
    final snapshot = await firestore
        .collection('products')
        .where('vendorId', isEqualTo: vendorId)
        .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromJson(doc.id, doc.data()))
        .toList();
  }

 @override
Future<void> addProduct(ProductModel product) async {
  debugPrint('🟢 FIRESTORE ADD CALLED');

  try {

    final docRef = firestore.collection('products').doc();

    await docRef.set({
      'name': product.name,
      'price': product.price,
      'stock': product.stock,
      'category': product.category,
      'imageUrl': product.imageUrl,
      'vendorId': product.vendorId, 
      'createdAt': FieldValue.serverTimestamp(),
    });

    debugPrint('✅ PRODUCT ADDED: ${docRef.id}');
  } catch (e) {
    debugPrint('❌ FIRESTORE ADD FAILED: $e');
    throw ServerException(e.toString());
  }
}


  @override
  Future<void> updateProduct(ProductModel product) async {
    await firestore
        .collection('products')
        .doc(product.id)
        .update(product.toJson());
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await firestore.collection('products').doc(productId).delete();
  }
}
