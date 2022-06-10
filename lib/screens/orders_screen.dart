import 'package:ecommerce_panel_admin/controllers/controllers.dart';
import 'package:ecommerce_panel_admin/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({Key? key}) : super(key: key);

  final orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Orders'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: orderController.pendingOrders.length,
                itemBuilder: (_, index) => OrderCard(
                  order: orderController.pendingOrders[index],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard({Key? key, required this.order}) : super(key: key);

  final OrderController orderController = Get.find();

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

    var products = Product.products
        .where((product) => order.productIds.contains(product.id))
        .toList();

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order ${order.id}', style: titleStyle),
                  Text(
                    DateFormat('dd-MM-yy').format(order.createdAt),
                    style: titleStyle,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.network(
                          products[index].imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            products[index].name,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: 285,
                            child: Text(
                              products[index].description,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.clip,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Delivery Fee',
                          style: titleStyle.copyWith(fontSize: 12)),
                      const SizedBox(height: 10),
                      Text('${order.deliveryFee}', style: titleStyle),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Total', style: titleStyle.copyWith(fontSize: 12)),
                      const SizedBox(height: 10),
                      Text('${order.total}', style: titleStyle),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  order.isAccepted
                      ? _CustomButton(
                          text: 'Deliver',
                          onPressed: () => orderController.updateOrder(
                            order,
                            'isDelivered',
                            !order.isDelivered,
                          ),
                        )
                      : _CustomButton(
                          text: 'Accept',
                          onPressed: () => orderController.updateOrder(
                            order,
                            'isAccepted',
                            !order.isAccepted,
                          ),
                        ),
                  _CustomButton(
                    text: 'Cancel',
                    onPressed: () => orderController.updateOrder(
                      order,
                      'isCancelled',
                      !order.isCancelled,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _CustomButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.black, minimumSize: const Size(150, 40)),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}
