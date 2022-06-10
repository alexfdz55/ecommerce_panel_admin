import 'package:ecommerce_panel_admin/models/models.dart';
import 'package:ecommerce_panel_admin/services/services.dart';

import 'package:get/state_manager.dart';

class ProductController extends GetxController {
  final databaseService = DatabaseService();

  var products = <Product>[].obs;
  var newProduct = {}.obs;

  get price => newProduct['price'];
  get quantity => newProduct['quantity'];
  get isRecommended => newProduct['isRecommended'];
  get isPopular => newProduct['isPopular'];

  @override
  void onInit() {
    products.bindStream(databaseService.getProducts());
    super.onInit();
  }

  void updateProductPrice(int index, Product product, double value) {
    product.price = value;
    products[index] = product;
  }

  void saveNewProductPrice(Product product, String field, double value) {
    databaseService.updateField(product, field, value);
  }

  void saveNewProductQuantity(Product product, String field, int value) {
    databaseService.updateField(product, field, value);
  }

  void updateProductQuantity(int index, Product product, int value) {
    product.quantity = value;
    products[index] = product;
  }
}
