import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vndor/di/storage_service.dart';

import '../../domain/entity/product_entity.dart';
import '../viewmodel/product_viewmodel.dart';
import '../../../../di/service_locator.dart';

class AddProductScreen extends StatefulWidget {
  final String vendorId;
  final ProductEntity? product;

  const AddProductScreen({super.key, required this.vendorId, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  static const Color meeshoPink = Color(0xFFF43397);

  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  File? image;

  late TextEditingController nameCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController stockCtrl;
  String? category;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.product?.name ?? '');
    priceCtrl = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    stockCtrl = TextEditingController(
      text: widget.product?.stock.toString() ?? '',
    );
    category = widget.product?.category;
  }

  Future<void> pickImage() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => image = File(img.path));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductViewModel>();
    final storage = sl<StorageService>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: meeshoPink,
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// IMAGE PICKER
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                  ),
                  child: image != null
                      ? Image.file(image!, fit: BoxFit.cover)
                      : widget.product?.imageUrl.isNotEmpty == true
                      ? Image.network(
                          widget.product!.imageUrl,
                          fit: BoxFit.cover,
                        )
                      : const Center(child: Icon(Icons.camera_alt, size: 40)),
                ),
              ),

              const SizedBox(height: 16),

              _field(nameCtrl, 'Product Name'),
              _field(priceCtrl, 'Price', isNumber: true),
              _field(stockCtrl, 'Stock', isNumber: true),

              DropdownButtonFormField<String>(
                value: category,
                items:
                    [
                          'Fashion',
                          'Electronics',
                          'Home & Kitchen',
                          'Beauty',
                          'Grocery',
                          'Accessories',
                        ]
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                onChanged: (v) => setState(() => category = v),
                decoration: _decoration('Category'),
                validator: (v) => v == null ? 'Select category' : null,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: meeshoPink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: vm.state == ProductState.submitting
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus(); 
                         
                          if (!_formKey.currentState!.validate()) return;
                          
                          String imageUrl = widget.product?.imageUrl ?? '';

                          if (image != null) {
                            try {
                              imageUrl = await storage.uploadProductImage(
                                file: image!,
                                vendorId: widget.vendorId,
                              );
                            } catch (_) {
                              imageUrl = 'https://via.placeholder.com/300';
                            }
                          }

                          final product = ProductEntity(
                            id: widget.product?.id ?? '',
                            name: nameCtrl.text.trim(),
                            price: double.parse(priceCtrl.text),
                            stock: int.parse(stockCtrl.text),
                            category: category!,
                            imageUrl: imageUrl,
                            vendorId: widget.vendorId,
                          );

                          final ok = widget.product == null
                              ? await vm.add(product)
                              : await vm.update(product);

                          if (ok && mounted) Navigator.pop(context);
                        },
                  child: vm.state == ProductState.submitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save Product',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (v) => v!.isEmpty ? 'Required' : null,
        decoration: _decoration(label),
      ),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
