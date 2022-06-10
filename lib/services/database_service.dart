import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_panel_admin/models/product_model.dart';

class DatabaseService {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _colection = 'products';

  Stream<List<Product>> getProducts() {
    return _firebaseFirestore.collection(_colection).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList());
  }

  Future<void> addProduct(Product product) {
    return _firebaseFirestore.collection(_colection).add(product.toMap());
  }

  Future<void> updateField(
    Product product,
    String field,
    dynamic newValue,
  ) {
    return _firebaseFirestore
        .collection(_colection)
        .where('id', isEqualTo: product.id)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.first.reference.update({field: newValue})
            });
  }
}
