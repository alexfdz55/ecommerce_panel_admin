import 'package:ecommerce_panel_admin/models/models.dart';
import 'package:ecommerce_panel_admin/services/services.dart';
import 'package:get/state_manager.dart';

class OrderStatsController extends GetxController {
  final databaseService = DatabaseService();

  var stats = Future.value(<OrderStats>[]).obs;

  @override
  void onInit() {
    stats.value = databaseService.getOrderStats();
    super.onInit();
  }
}
