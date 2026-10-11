// import 'package:flutter/material.dart';
// import 'package:sweetella_admin/core/design/app_tokens.dart';

// class AddProductPage extends StatelessWidget {
//   const AddProductPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final tokens = context.tokens;

//     return SingleChildScrollView(
//       padding: EdgeInsets.all(tokens.space.xxl),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Add Product', style: tokens.text.title),
//           SizedBox(height: tokens.space.xl),
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(tokens.space.xxl),
//             decoration: BoxDecoration(
//               color: tokens.color.surface,
//               borderRadius: BorderRadius.circular(tokens.radius.lg),
//               boxShadow: tokens.shadow.low,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Product Information', style: tokens.text.titleSmall),
//                 SizedBox(height: tokens.space.xl),
//                 const _ProductTextField(label: 'Product Name'),
//                 SizedBox(height: tokens.space.lg),
//                 const _ProductTextField(label: 'Description', maxLines: 4),
//                 SizedBox(height: tokens.space.lg),
//                 const Row(
//                   children: [
//                     Expanded(
//                       child: _ProductTextField(
//                         label: 'Price',
//                         keyboardType: TextInputType.number,
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: _ProductTextField(
//                         label: 'Sale Price',
//                         keyboardType: TextInputType.number,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: tokens.space.xxl),
//                 Align(
//                   alignment: AlignmentDirectional.centerEnd,
//                   child: FilledButton(
//                     onPressed: () {},
//                     style: FilledButton.styleFrom(
//                       backgroundColor: tokens.color.brand,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: tokens.space.xxl,
//                         vertical: tokens.space.md,
//                       ),
//                     ),
//                     child: Text('Save Product', style: tokens.text.button),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ProductTextField extends StatelessWidget {
//   const _ProductTextField({
//     required this.label,
//     this.maxLines = 1,
//     this.keyboardType,
//   });

//   final String label;
//   final int maxLines;
//   final TextInputType? keyboardType;

//   @override
//   Widget build(BuildContext context) {
//     final tokens = context.tokens;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: tokens.text.label),
//         SizedBox(height: tokens.space.sm),
//         TextFormField(
//           maxLines: maxLines,
//           keyboardType: keyboardType,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: tokens.color.surfaceAlt,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(tokens.radius.md),
//               borderSide: BorderSide(color: tokens.color.border),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(tokens.radius.md),
//               borderSide: BorderSide(color: tokens.color.border),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
// lib/features/products/presentation/widgets/product_form_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweetella_admin/core/widgets/custom_shadow_container.dart';
import 'package:sweetella_admin/features/categories/presentation/widgets/custom_text_field.dart';
import 'package:sweetella_admin/features/categories/presentation/widgets/image_upload_box.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_cubit.dart';

class AddProductPage extends StatefulWidget {
  final ProductEntity? productToEdit;
  //final Function(ProductEntity product) onSubmit;

  const AddProductPage({
    super.key,
    this.productToEdit,
    // required this.onSubmit,
  });

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _imageUrlController;
  final ImagePicker _picker = ImagePicker();
  String? _selectedImagePath;
  XFile? _selectedImage;
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    final p = widget.productToEdit;
    _nameController = TextEditingController(text: p?.name ?? '');
    _categoryController = TextEditingController();
    _descController = TextEditingController(text: p?.description ?? '');
    _priceController = TextEditingController(text: '100');
    _stockController = TextEditingController(text: '10');
    _imageUrlController = TextEditingController(text: p?.imageUrl ?? '');
    _isAvailable = p?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (!mounted || pickedFile == null) {
      return;
    }

    setState(() => _selectedImagePath = pickedFile.path);
    _selectedImage = pickedFile;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: CustomShadowContanier(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.productToEdit == null
                      ? 'إضافة منتج جديد'
                      : 'تعديل المنتج',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Product name',
                  hintText: 'Product name',
                  isRequired: true,
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'product name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: 'Category name',
                  hintText: 'Category name',
                  isRequired: true,
                  controller: _categoryController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'product name is required';
                    }
                    return null;
                  },
                ),

                // const SizedBox(height: 10),
                CustomTextField(
                  label: 'Description ',
                  hintText: 'Desciption ',
                  isRequired: true,
                  controller: _descController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'description  is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Price',
                        hintText: 'Price',
                        isRequired: true,
                        controller: _priceController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Price  is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: 'Stoke',
                        hintText: 'Stoke',
                        isRequired: true,
                        controller: _stockController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Stoke  is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ImageUploadBox(
                  label: 'Upload image',
                  imagePath: _selectedImagePath,
                  onTap: _pickImage,
                ),

                const SizedBox(height: 10),
                SwitchListTile(
                  title: const Text('متوفر حالياً للطلب؟'),
                  value: _isAvailable,
                  onChanged: (val) => setState(() => _isAvailable = val),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final product = ProductEntity(
                        id:
                            widget.productToEdit?.id ??
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _nameController.text,
                        categoryName: _categoryController.text,
                        description: _descController.text,
                        imageUrl: _imageUrlController.text,
                        categoryId: '',
                        price: 0,
                        salePrice: 30,
                        attributes: [],

                        // variants: [
                        //   ProductVariant(
                        //     id: 'v1',
                        //     sizeName: 'افتراضي / وسط',
                        //     price: double.parse(_priceController.text),
                        //     dailyStock: int.parse(_stockController.text),
                        //   ),
                        // ],
                        // addons: widget.productToEdit?.addons ?? [
                        //   ProductAddon(id: 'a1', name: 'شمعة عيد ميلاد', price: 10),
                        //   ProductAddon(id: 'a2', name: 'كارت معايدة', price: 15),
                        //],
                      );
                      //widget.onSubmit(product);
                      if (widget.productToEdit == null) {
                        context.read<ProductCubit>().addProduct(product);
                      } else {
                        context.read<ProductCubit>().updateProduct(product);
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    widget.productToEdit == null
                        ? 'حفظ وإضافة'
                        : 'تعديل المنتج',
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
