import 'package:ecommerce_panel_admin/controllers/controllers.dart';
import 'package:ecommerce_panel_admin/models/models.dart';
import 'package:ecommerce_panel_admin/services/services.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class NewProductScreen extends StatelessWidget {
  NewProductScreen({Key? key}) : super(key: key);

  final ProductController productController = Get.find();
  final StorageService storageService = StorageService();
  final DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add a Product'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  child: Card(
                    margin: EdgeInsets.zero,
                    color: Colors.black,
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.add_circle, color: Colors.white),
                          onPressed: () async {
                            final picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);

                            if (image == null) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('No image was selected')),
                              );
                            } else {
                              await storageService.uploadImage(image);
                              var imageUrl = await storageService
                                  .getDownloadURL(image.name);
                              productController.newProduct.update(
                                'imageUrl',
                                (_) => imageUrl,
                                ifAbsent: () => imageUrl,
                              );
                              // ignore: avoid_print
                              print(productController.newProduct['imageUrl']);
                            }
                          },
                        ),
                        const Text(
                          'Add a Image',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Product Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                _buildTextFormField('Product ID', 'id', productController),
                _buildTextFormField('Product Name', 'name', productController),
                _buildTextFormField(
                  'Product Description',
                  'description',
                  productController,
                ),
                _buildTextFormField(
                  'Product Category',
                  'category',
                  productController,
                ),
                const SizedBox(height: 10),
                _buildSlider('Price', 'price', productController,
                    productController.price, 25.0),
                _buildSlider('Quantity', 'quantity', productController,
                    productController.quantity, 100.0),
                const SizedBox(height: 10),
                _buildCheckbox(
                  'Recommended',
                  'isRecommended',
                  productController,
                  productController.isRecommended,
                ),
                _buildCheckbox(
                  'Popular',
                  'isPopular',
                  productController,
                  productController.isPopular,
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    child: const Text(
                      'Save',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      final productMap = productController.newProduct;
                      databaseService.addProduct(
                        Product(
                          id: int.parse(productMap['id']),
                          name: productMap['name'],
                          category: productMap['category'],
                          description: productMap['description'],
                          imageUrl: productMap['imageUrl'],
                          isRecommended: productMap['isRecommended'] ?? false,
                          isPopular: productMap['isPopular'] ?? false,
                          price: productMap['price'],
                          quantity: productMap['quantity'].toInt(),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildCheckbox(
    String title,
    String name,
    ProductController productController,
    bool? controllerValue,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 125,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Checkbox(
          value: (controllerValue == null) ? false : controllerValue,
          checkColor: Colors.black,
          activeColor: Colors.black12,
          onChanged: (value) {
            productController.newProduct.update(
              name,
              (_) => value,
              ifAbsent: () => value,
            );
          },
        ),
      ],
    );
  }

  Row _buildSlider(
    String title,
    String name,
    ProductController productController,
    double? controllerValue,
    double max,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 75,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Slider(
            value: controllerValue ?? 0,
            min: 0,
            max: max,
            divisions: 10,
            activeColor: Colors.black,
            inactiveColor: Colors.black12,
            onChanged: (value) {
              productController.newProduct.update(
                name,
                (_) => value,
                ifAbsent: () => value,
              );
            },
          ),
        ),
      ],
    );
  }

  TextFormField _buildTextFormField(
    String hintText,
    String name,
    ProductController productController,
  ) {
    return TextFormField(
      decoration: InputDecoration(hintText: hintText),
      onChanged: (value) {
        productController.newProduct.update(
          name,
          (_) => value,
          ifAbsent: () => value,
        );
      },
    );
  }
}
