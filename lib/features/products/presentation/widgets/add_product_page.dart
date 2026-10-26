import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweetella_admin/core/cubits/upload_image_cubit.dart';
import 'package:sweetella_admin/core/cubits/upload_image_usecase.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/error/app_failuer)localization.dart';
import 'package:sweetella_admin/core/widgets/custom_shadow_container.dart';
import 'package:sweetella_admin/core/widgets/snack_bar.dart';
import 'package:sweetella_admin/features/categories/presentation/cubit/category_cubit.dart';
import 'package:sweetella_admin/features/categories/presentation/cubit/category_state.dart';
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
  String? _selectedCategoryId;
  String? _selectedCategoryName;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  // حقول للمنتج البسيط (السعر الثابت والمخزون)
  late TextEditingController _singlePriceController;
  late TextEditingController _singleStockController;

  bool _hasVariants = false;
  final List<VariantRowControllers> _variantRows = [];
  final List<AdddonRowControllers> _addonsRows = [];
  final sizeController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  bool _hasAddons = false;

  XFile? _selectedImage;
  String? _selectedImagePath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final product = widget.productToEdit;

    _nameController = TextEditingController(text: product?.name ?? '');
    _selectedCategoryId = product?.categoryId;
    _selectedCategoryName = product?.categoryName;
    _descController = TextEditingController(text: product?.description ?? '');

    _stockController = TextEditingController(text: '10');
    _selectedImagePath = widget.productToEdit?.imageUrl;

    _hasVariants = product?.hasVariants ?? false;
    _hasAddons = product?.hasAddons ?? false;
    // تعبئة الأحجام القديمة في حال التعديل أو بدء صف افتراضي
    if (product != null && product.variants.isNotEmpty) {
      for (var v in product.variants) {
        _variantRows.add(
          VariantRowControllers(
            id: v.id,
            nameController: TextEditingController(text: v.sizeName),
            priceController: TextEditingController(text: v.price.toString()),
            stockController: TextEditingController(text: v.stock.toString()),
          ),
        );
      }
    } else {
      // صف افتراضي أولي
      _addVariantRow(name: 'التحجم القياسي', price: '100', stock: '10');
    }
    if (product != null && product.addons.isNotEmpty) {
      for (var v in product.addons) {
        _addonsRows.add(
          AdddonRowControllers(
            id: v.id,
            nameController: TextEditingController(text: v.name),
            priceController: TextEditingController(text: v.price.toString()),
            stockController: TextEditingController(text: v.stock.toString()),
          ),
        );
      }
    } else {
      _addAddonRow(name: 'name ', price: '100', stock: '10');
    }

    _singlePriceController = TextEditingController(
      text: product?.price.toString() ?? '0',
    );
    _singleStockController = TextEditingController(
      text: product?.stock.toString() ?? '0',
    );
  }

  void _addVariantRow({
    String name = '',
    String price = '',
    String stock = '',
  }) {
    setState(() {
      _variantRows.add(
        VariantRowControllers(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nameController: TextEditingController(text: name),
          priceController: TextEditingController(text: price),
          stockController: TextEditingController(text: stock),
        ),
      );
    });
  }

  void _addAddonRow({String name = '', String price = '', String stock = ''}) {
    setState(() {
      _addonsRows.add(
        AdddonRowControllers(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nameController: TextEditingController(text: name),
          priceController: TextEditingController(text: price),
          stockController: TextEditingController(text: stock),
        ),
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();

    _singlePriceController.dispose();
    _singleStockController.dispose();

    sizeController.dispose();
    priceController.dispose();
    stockController.dispose();

    for (final row in _variantRows) {
      row.dispose();
    }

    for (final row in _addonsRows) {
      row.dispose();
    }

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
          showsnakbar(context, 'Image upload failed', SnachBarState.error);
          return;
        }

        imageUrl = uploadedImage.url;
      }
      List<ProductVariantEntity> finalVariants = _hasVariants
          ? _variantRows
                .map(
                  (e) => ProductVariantEntity(
                    id: e.id,
                    sizeName: e.nameController.text,
                    price: double.tryParse(e.priceController.text) ?? 0.0,
                    stock: int.tryParse(e.stockController.text) ?? 10,
                  ),
                )
                .toList()
          : [];
      List<ProductAddonEntity> finalAddons = _hasAddons
          ? _addonsRows
                .map(
                  (e) => ProductAddonEntity(
                    id: e.id,
                    name: e.nameController.text,
                    price: double.tryParse(e.priceController.text) ?? 0.0,
                    stock: int.tryParse(e.stockController.text) ?? 10,
                  ),
                )
                .toList()
          : [];
      final product = ProductEntity(
        id:
            widget.productToEdit?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        categoryName: _selectedCategoryName ?? '',
        categoryId: _selectedCategoryId ?? '',
        description: _descController.text,
        imageUrl: imageUrl,

        isAvailable: true,
        hasVariants: _hasVariants,
        hasAddons: _hasAddons,
        variants: finalVariants,
        addons: _hasAddons ? finalAddons : [],
        // لو مفيش أحجام، بنحط السعر والستوك المباشرين، ولو فيه بنخليهم null
        price: _hasVariants
            ? null
            : double.tryParse(_singlePriceController.text) ?? 0.0,
        stock: _hasVariants
            ? null
            : int.tryParse(_singleStockController.text) ?? 10,
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
        showsnakbar(context, 'Save failed: $e', SnachBarState.error);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProductCubit, ProductState>(
            listener: (context, state) {
              if (state is ProductLoaded && state.successMessage != null) {
                showsnakbar(
                  context,
                  state.successMessage!,
                  SnachBarState.success,
                );
              } else if (state is ProductError) {
                showsnakbar(
                  context,
                  state.failure.message(context),
                  SnachBarState.error,
                );
              }
            },
          ),
          BlocListener<UploadImageCubit, ImageUploadState>(
            listener: (context, state) {
              if (state is ImageUploadFailure) {
                showsnakbar(
                  context,
                  state.message.message(context),
                  SnachBarState.error,
                );
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
                    Text('Category', style: context.tokens.text.titleSmall),
                    const SizedBox(height: 10),
                    BlocBuilder<CategoryCubit, CategoryState>(
                      builder: (context, state) {
                        final categories = state is CategoryLoadSuccess
                            ? state.categories
                            : [];

                        return DropdownButtonFormField<String>(
                          initialValue:
                              categories.any(
                                (category) =>
                                    category.id == _selectedCategoryId,
                              )
                              ? _selectedCategoryId
                              : null,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: context.tokens.color.brand,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Select a category',
                            border: OutlineInputBorder(),
                          ),
                          items: categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category.id,
                              child: Text(
                                category.categoryName,
                                style: context.tokens.text.body,
                              ),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                          onChanged: categories.isEmpty
                              ? null
                              : (categoryId) {
                                  final selected = categories.firstWhere(
                                    (category) => category.id == categoryId,
                                  );

                                  setState(() {
                                    _selectedCategoryId = selected.id;
                                    _selectedCategoryName =
                                        selected.categoryName;
                                  });
                                },
                          borderRadius: BorderRadius.circular(
                            context.tokens.radius.md,
                          ),
                        );
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
                    // ==========================================
                    // قسم تففعيل الأحجام والأسعار المتعددة
                    // ==========================================
                    SwitchListTile(
                      title: const Text(
                        'Is there a size or weight for this product?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: const Text(
                        'Size (small / medium / large) or (half a kilo / a kilo)',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: _hasVariants,
                      activeColor: context.tokens.color.brand,
                      onChanged: (val) => setState(() => _hasVariants = val),
                    ),

                    if (!_hasVariants) ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _singleStockController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Stock',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _singlePriceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Price',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      const SizedBox(height: 8),
                      // توليد الصفوف الثلاثة لكل حجم مباشرة زي الصورة
                      ..._variantRows.asMap().entries.map((entry) {
                        int index = entry.key;
                        var row = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: [
                              // زر الحذف (Trash Icon)
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  if (_variantRows.length > 1) {
                                    setState(() {
                                      _variantRows.removeAt(index);
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'The product must have at least one size',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ), // حقل المخزون
                              Expanded(
                                child: TextFormField(
                                  controller: row.stockController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Stock',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // حقل السعر
                              Expanded(
                                child: TextFormField(
                                  controller: row.priceController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'السعر',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // حقل اسم الحجم
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: row.nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'اسم الحجم',
                                    hintText: 'مثلاً: كبير',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      // زرار إضافة حجم أو وزن جديد (تحت الحقول مباشرة)
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.brown,
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text('Adding a new size or weight'),
                          onPressed: () => _addVariantRow(),
                        ),
                      ),
                    ],

                    const Divider(height: 30),

                    // ==========================================
                    // 2. مفتاح الإضافات (Add-ons)
                    // ==========================================
                    SwitchListTile(
                      title: const Text(
                        'Is there an add-on for this product?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                        'example: (birthday candle, extra sauce, card)',
                      ),
                      value: _hasAddons,
                      activeColor: context.tokens.color.brand,
                      onChanged: (val) => setState(() => _hasAddons = val),
                    ),

                    if (_hasAddons) ...[
                      const SizedBox(height: 8),
                      // توليد الصفوف الثلاثة لكل حجم مباشرة زي الصورة
                      ..._addonsRows.asMap().entries.map((entry) {
                        int index = entry.key;
                        var row = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: [
                              // زر الحذف (Trash Icon)
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  if (_addonsRows.length > 1) {
                                    setState(() {
                                      _addonsRows.removeAt(index);
                                    });
                                  }
                                },
                              ), // حقل المخزون
                              Expanded(
                                child: TextFormField(
                                  controller: row.stockController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'المخزون',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // حقل السعر
                              Expanded(
                                child: TextFormField(
                                  controller: row.priceController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'السعر',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // حقل اسم الحجم
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: row.nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'اسم الحجم',
                                    hintText: 'مثلاً: كبير',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      // زرار إضافة حجم أو وزن جديد (تحت الحقول مباشرة)
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: context.tokens.color.brand,
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text('إضافة حجم أو وزن جديد'),
                          onPressed: () => _addAddonRow(),
                        ),
                      ),
                    ],

                    const Divider(height: 30),

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
                          child: _isSaving
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
      ),
    );
  }
}

class VariantRowControllers {
  final String id;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController stockController;

  VariantRowControllers({
    required this.id,
    required this.nameController,
    required this.priceController,
    required this.stockController,
  });

  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
  }
}

class AdddonRowControllers {
  final String id;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController stockController;

  AdddonRowControllers({
    required this.id,
    required this.nameController,
    required this.priceController,
    required this.stockController,
  });

  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
  }
}
