import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
