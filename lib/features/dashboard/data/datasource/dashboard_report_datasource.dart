import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vndor/features/dashboard/data/model/dashboard_stats_model.dart';
import '../../../../core/error/exception.dart';
 
abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getStats(String vendorId);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final FirebaseFirestore firestore;

  DashboardRemoteDataSourceImpl(this.firestore);
@override
Future<DashboardStatsModel> getStats(String vendorId) async {
  try {
    final productsSnapshot = await firestore
        .collection('products')
        .where('vendorId', isEqualTo: vendorId)
        .get();

    final ordersSnapshot = await firestore
        .collection('orders')
        .where('vendorId', isEqualTo: vendorId)
        .get();

    double revenue = 0;
    final Map<String, double> categorySales = {};
    int lowStockCount = 0;
    int todayOrders = 0;

    final today = DateTime.now();

     for (var p in productsSnapshot.docs) {
      final stock = (p['stock'] as num).toInt();
      if (stock < 10) lowStockCount++;
    }

     for (var o in ordersSnapshot.docs) {
      final total = (o['totalAmount'] as num).toDouble();
      revenue += total;

      final createdAt = (o['createdAt'] as Timestamp).toDate();
      if (createdAt.day == today.day &&
          createdAt.month == today.month &&
          createdAt.year == today.year) {
        todayOrders++;
      }

      final items = List<Map<String, dynamic>>.from(o['items']);
      for (var item in items) {
        final category = item['category'] ?? 'Other';
        final amount =
            (item['price'] as num).toDouble() * item['quantity'];

        categorySales[category] =
            (categorySales[category] ?? 0) + amount;
      }
    }

    return DashboardStatsModel(
      totalProducts: productsSnapshot.docs.length,
      totalOrders: ordersSnapshot.docs.length,
      totalRevenue: revenue,
      categorySales: categorySales,
      lowStockCount: lowStockCount,
      todayOrders: todayOrders,
    );
  } catch (e) {
    throw ServerException(e.toString());
  }
}

}
