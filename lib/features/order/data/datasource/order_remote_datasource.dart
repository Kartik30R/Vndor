import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../core/error/exception.dart';
import '../model/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders(String vendorId);
  Future<void> createOrder(OrderModel order);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore firestore;

  OrderRemoteDataSourceImpl(this.firestore);

@override
Future<List<OrderModel>> getOrders(String vendorId) async {
  try {
    final snapshot = await firestore
        .collection('orders')
        .where('vendorId', isEqualTo: vendorId)
        .get();

    return snapshot.docs
        .map((doc) => OrderModel.fromJson(doc.id, doc.data()))
        .toList();
  } catch (e) {
    throw ServerException('Failed to load orders');
  }
}


 @override
Future<void> createOrder(OrderModel order) async {
  try {
    await firestore.runTransaction((transaction) async {
       final productSnapshots = <String, DocumentSnapshot>{};

      for (final item in order.items) {
        final ref =
            firestore.collection('products').doc(item.productId);
        productSnapshots[item.productId] =
            await transaction.get(ref);
      }

      for (final item in order.items) {
        final snapshot = productSnapshots[item.productId]!;

        final currentStock =
            (snapshot['stock'] as num).toInt();

        if (currentStock < item.quantity) {
          throw ServerException(
            'Insufficient stock for ${item.name}',
          );
        }
      }

       for (final item in order.items) {
        final ref =
            firestore.collection('products').doc(item.productId);

        final snapshot = productSnapshots[item.productId]!;
        final currentStock =
            (snapshot['stock'] as num).toInt();

        transaction.update(ref, {
          'stock': currentStock - item.quantity,
        });
      }

       final orderRef = firestore.collection('orders').doc();
      transaction.set(orderRef, order.toJson());
    });
  } catch (e) {
    throw ServerException(
      e is ServerException ? e.message : e.toString(),
    );
  }
}
}
