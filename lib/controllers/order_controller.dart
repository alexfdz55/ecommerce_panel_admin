import 'package:ecommerce_panel_admin/models/models.dart';
import 'package:ecommerce_panel_admin/services/services.dart';
import 'package:get/state_manager.dart';

class OrderController extends GetxController {
  final databaseService = DatabaseService();

  var orders = <Order>[].obs;
  var pendingOrders = <Order>[].obs;

  @override
  void onInit() {
    orders.bindStream(databaseService.getOrders());
    pendingOrders.bindStream(databaseService.getPendingOrders());
    super.onInit();
  }

  void updateOrder(Order order, String field, bool value) {
    databaseService.updateOrder(order, field, value);
  }
}
