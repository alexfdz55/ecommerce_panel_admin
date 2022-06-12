import 'package:ecommerce_panel_admin/controllers/controllers.dart';
import 'package:ecommerce_panel_admin/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens.dart';
import 'package:charts_flutter/flutter.dart' as charts;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final orderStatsController = Get.put(OrderStatsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My eCommerce'),
        backgroundColor: Colors.black,
      ),
      body: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder(
                future: orderStatsController.stats.value,
                builder: (_, AsyncSnapshot<List<OrderStats>> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 250,
                      padding: const EdgeInsets.all(10),
                      child: _CustomBarChart(orderStat: snapshot.data!),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }),
            _CustomButton(text: 'Go To Products', page: ProductsScreen()),
            _CustomButton(text: 'Go To Orders', page: OrdersScreen())
          ],
        ),
      ),
    );
  }
}

class _CustomButton extends StatelessWidget {
  final String text;
  final Widget page;
  const _CustomButton({Key? key, required this.text, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        child: Card(
          child: Center(
            child: Text(text),
          ),
        ),
        onTap: () => Get.to(() => page),
      ),
    );
  }
}

class _CustomBarChart extends StatelessWidget {
  final List<OrderStats> orderStat;
  const _CustomBarChart({Key? key, required this.orderStat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<OrderStats, String>> series = [
      charts.Series(
        id: 'orders',
        data: orderStat,
        domainFn: (series, _) =>
            DateFormat.d().format(series.dateTime).toString(),
        measureFn: (series, _) => series.orders,
        colorFn: (series, _) => series.barColor!,
      )
    ];

    return charts.BarChart(series, animate: true);
  }
}
