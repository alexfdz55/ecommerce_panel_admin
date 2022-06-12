import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_panel_admin/models/models.dart';

class DatabaseService {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _productsColection = 'products';
  final _ordersColection = 'orders';
  final _orderStatsColection = 'order_stats';

  Stream<List<Product>> getProducts() {
    return _firebaseFirestore.collection(_productsColection).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList());
  }

  Stream<List<Order>> getOrders() {
    return _firebaseFirestore.collection(_ordersColection).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Order.fromSnapshot(doc)).toList());
  }

  Stream<List<Order>> getPendingOrders() {
    return _firebaseFirestore
        .collection(_ordersColection)
        .where('isDelivered', isEqualTo: false)
        .where('isCancelled', isEqualTo: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Order.fromSnapshot(doc)).toList());
  }

  Future<List<OrderStats>> getOrderStats() {
    return _firebaseFirestore
        .collection(_orderStatsColection)
        .orderBy('dateTime')
        .get()
        .then(
          (querySnapshot) => querySnapshot.docs
              .asMap()
              .entries
              .map((entry) => OrderStats.fromSnapshot(entry.value, entry.key))
              .toList(),
        );
  }

  Future<void> addProduct(Product product) {
    return _firebaseFirestore
        .collection(_productsColection)
        .add(product.toMap());
  }

  Future<void> updateField(Product product, String field, dynamic newValue) {
    return _firebaseFirestore
        .collection(_productsColection)
        .where('id', isEqualTo: product.id)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.first.reference.update({field: newValue})
            });
  }

  Future<void> updateOrder(Order order, String field, dynamic newValue) {
    return _firebaseFirestore
        .collection(_ordersColection)
        .where('id', isEqualTo: order.id)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.first.reference.update({field: newValue})
            });
  }
}
