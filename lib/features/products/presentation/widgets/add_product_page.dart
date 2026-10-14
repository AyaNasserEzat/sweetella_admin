import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sweetella_admin/core/cubits/upload_image_cubit.dart';
import 'package:sweetella_admin/core/cubits/upload_image_usecase.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/error/app_failuer)localization.dart';
import 'package:sweetella_admin/core/storage/domain/entities/uploaded_image.dart';
import 'package:sweetella_admin/core/widgets/custom_shadow_container.dart';
import 'package:sweetella_admin/features/categories/presentation/widgets/custom_text_field.dart';
import 'package:sweetella_admin/features/categories/presentation/widgets/image_upload_box.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_cubit.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_state.dart';

class AddProductPage extends StatefulWidget {
  final ProductEntity? productToEdit;

  const AddProductPage({super.key, this.productToEdit});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;

  XFile? _selectedImage;
  String? _selectedImagePath;

  bool _isAvailable = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final product = widget.productToEdit;

    _nameController = TextEditingController(text: product?.name ?? '');
    _categoryController = TextEditingController(
      text: product?.categoryName ?? '',
    );
    _descController = TextEditingController(text: product?.description ?? '');
    _priceController = TextEditingController(
      text: product?.price.toString() ?? '100',
    );
    _stockController = TextEditingController(text: '10');

    _isAvailable = product?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
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

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final uploadCubit = context.read<UploadImageCubit>();

    try {
      String imageUrl = widget.productToEdit?.imageUrl ?? '';

      if (_selectedImage != null) {
        final uploadedImage = await uploadCubit.upload(_selectedImage!);

        if (!mounted) return;

        if (uploadedImage == null) {
          _showSnackBar('Image upload failed', isError: true);
          return;
        }

        imageUrl = uploadedImage.url;
      }

      final product = ProductEntity(
        id: widget.productToEdit?.id ?? '',
        name: _nameController.text.trim(),
        categoryName: _categoryController.text.trim(),
        description: _descController.text.trim(),
        imageUrl: imageUrl,
        categoryId: widget.productToEdit?.categoryId ?? '',
        price: int.tryParse(_priceController.text.trim()) ?? 0,
        salePrice: widget.productToEdit?.salePrice ?? 30,
        attributes: widget.productToEdit?.attributes ?? [],
      );

      final productCubit = context.read<ProductCubit>();

      if (widget.productToEdit == null) {
        await productCubit.addProduct(product);
      } else {
        await productCubit.updateProduct(product);
      }
    } catch (e, stackTrace) {
      debugPrint('SAVE PRODUCT ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (mounted) {
        _showSnackBar('Save failed: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProductCubit, ProductState>(
          listener: (context, state) {
            if (state is ProductOperationSuccess) {
              _showSnackBar(state.message, isError: false);
            } else if (state is ProductError) {
              _showSnackBar(state.failure.message(context), isError: true);
            }
          },
        ),
        BlocListener<UploadImageCubit, ImageUploadState>(
          listener: (context, state) {
            if (state is ImageUploadSuccess) {
              _showSnackBar('Image uploaded successfully', isError: false);
            }
            if (state is ImageUploadFailure) {
              _showSnackBar(state.message.message(context), isError: true);
            }
          },
        ),
      ],
      child: Padding(
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

                  ImageUploadBox(
                    label: 'Upload image',
                    imagePath: _selectedImagePath,
                    onTap: _pickImage,
                  ),

                  const SizedBox(height: 10),

                  CustomTextField(
                    label: 'Product name',
                    hintText: 'Product name',
                    isRequired: true,
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Product name is required';
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
                        return 'Category name is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  CustomTextField(
                    label: 'Description',
                    hintText: 'Description',
                    isRequired: true,
                    controller: _descController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Description is required';
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
                            final price = double.tryParse(value?.trim() ?? '');

                            if (price == null || price < 0) {
                              return 'Enter a valid price';
                            }

                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          label: 'Stock',
                          hintText: 'Stock',
                          isRequired: true,
                          controller: _stockController,
                          validator: (value) {
                            final stock = int.tryParse(value?.trim() ?? '');

                            if (stock == null || stock < 0) {
                              return 'Enter valid stock';
                            }

                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  BlocBuilder<ProductCubit, ProductState>(
                    buildWhen: (previous, current) =>
                        current is ProductLoading ||
                        current is ProductError ||
                        current is ProductOperationSuccess,
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.tokens.color.brand,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _isSaving ? () {} : _saveProduct,
                        child: state is ProductLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                widget.productToEdit == null
                                    ? 'حفظ وإضافة'
                                    : 'تعديل المنتج',
                              ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
