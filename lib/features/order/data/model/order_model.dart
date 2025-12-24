import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/order_entity.dart';
import 'order_item_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.vendorId,
    required super.items,
    required super.totalAmount,
    required super.status,
    required super.createdAt,
  });

 Map<String, dynamic> toJson() {
  return {
    'vendorId': vendorId,
    'items': items.map((e) => (e as OrderItemModel).toJson()).toList(),
    'totalAmount': totalAmount,
    'status': status,
    'createdAt': FieldValue.serverTimestamp(),
    'createdAtMillis': DateTime.now().millisecondsSinceEpoch,
  };
}


  factory OrderModel.fromJson(String id, Map<String, dynamic> json) {
    return OrderModel(
      id: id,
      vendorId: json['vendorId'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'],
createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      items: (json['items'] as List)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
    );
  }
}
