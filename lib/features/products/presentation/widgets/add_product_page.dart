import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweetella_admin/core/cubits/upload_image_cubit.dart';
import 'package:sweetella_admin/core/cubits/upload_image_usecase.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/error/app_failuer)localization.dart';
import 'package:sweetella_admin/core/layout/breakpoints.dart';
import 'package:sweetella_admin/core/widgets/custom_shadow_container.dart';
import 'package:sweetella_admin/core/widgets/snack_bar.dart';
import 'package:sweetella_admin/features/categories/presentation/widgets/custom_text_field.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_cubit.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_state.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/add_product/product_identity_section.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/add_product/product_option_row.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/add_product/product_price_stock_fields.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/add_product/product_section_switch.dart';
import 'package:sweetella_admin/features/products/presentation/widgets/add_product/product_submit_button.dart';

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
  late TextEditingController _descController;
  late TextEditingController _singlePriceController;
  late TextEditingController _singleStockController;

  String? _selectedCategoryId;
  String? _selectedCategoryName;

  bool _hasVariants = false;
  bool _hasAddons = false;
  bool _isSaving = false;

  final List<ProductOptionControllers> _variantRows = [];
  final List<ProductOptionControllers> _addonsRows = [];

  XFile? _selectedImage;
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();

    final product = widget.productToEdit;

    _nameController = TextEditingController(text: product?.name ?? '');
    _descController = TextEditingController(text: product?.description ?? '');

    _selectedCategoryId = product?.categoryId;
    _selectedCategoryName = product?.categoryName;
    _selectedImagePath = product?.imageUrl;

    _hasVariants = product?.hasVariants ?? false;
    _hasAddons = product?.hasAddons ?? false;

    if (product != null && product.variants.isNotEmpty) {
      for (final variant in product.variants) {
        _variantRows.add(
          ProductOptionControllers(
            id: variant.id,
            nameController: TextEditingController(text: variant.sizeName),
            priceController: TextEditingController(
              text: variant.price.toString(),
            ),
            stockController: TextEditingController(
              text: variant.stock.toString(),
            ),
          ),
        );
      }
    } else {
      _addVariantRow(name: 'Small', price: '100', stock: '10', rebuild: false);
    }

    if (product != null && product.addons.isNotEmpty) {
      for (final addon in product.addons) {
        _addonsRows.add(
          ProductOptionControllers(
            id: addon.id,
            nameController: TextEditingController(text: addon.name),
            priceController: TextEditingController(
              text: addon.price.toString(),
            ),
            stockController: TextEditingController(
              text: addon.stock.toString(),
            ),
          ),
        );
      }
    } else {
      _addAddonRow(
        name: 'Chocolate Sauce ',
        price: '100',
        stock: '10',
        rebuild: false,
      );
    }

    _singlePriceController = TextEditingController(
      text: product?.price?.toString() ?? '0',
    );

    _singleStockController = TextEditingController(
      text: product?.stock?.toString() ?? '0',
    );
  }

  void _addVariantRow({
    String name = '',
    String price = '',
    String stock = '',
    bool rebuild = true,
  }) {
    final row = ProductOptionControllers(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      nameController: TextEditingController(text: name),
      priceController: TextEditingController(text: price),
      stockController: TextEditingController(text: stock),
    );

    if (rebuild) {
      setState(() => _variantRows.add(row));
    } else {
      _variantRows.add(row);
    }
  }

  void _addAddonRow({
    String name = '',
    String price = '',
    String stock = '',
    bool rebuild = true,
  }) {
    final row = ProductOptionControllers(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      nameController: TextEditingController(text: name),
      priceController: TextEditingController(text: price),
      stockController: TextEditingController(text: stock),
    );

    if (rebuild) {
      setState(() => _addonsRows.add(row));
    } else {
      _addonsRows.add(row);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _singlePriceController.dispose();
    _singleStockController.dispose();

    for (final row in _variantRows) {
      row.dispose();
    }

    for (final row in _addonsRows) {
      row.dispose();
    }

    super.dispose();
  }

  void _removeVariantRow(ProductOptionControllers row, int index) {
    if (_variantRows.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The product must have at least one size'),
        ),
      );
      return;
    }

    setState(() => _variantRows.removeAt(index));
    row.dispose();
  }

  void _removeAddonRow(ProductOptionControllers row, int index) {
    if (_addonsRows.length <= 1) return;

    setState(() => _addonsRows.removeAt(index));
    row.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (!mounted || pickedFile == null) return;

    setState(() {
      _selectedImage = pickedFile;
      _selectedImagePath = pickedFile.path;
    });
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      String imageUrl = widget.productToEdit?.imageUrl ?? '';

      if (_selectedImage != null) {
        final uploadedImage = await context.read<UploadImageCubit>().upload(
          _selectedImage!,
        );

        if (!mounted) return;

        if (uploadedImage == null) {
          showsnakbar(context, 'Image upload failed', SnachBarState.error);
          return;
        }

        imageUrl = uploadedImage.url;
      }

      final finalVariants = _hasVariants
          ? _variantRows.map((row) {
              return ProductVariantEntity(
                id: row.id,
                sizeName: row.nameController.text.trim(),
                price: double.tryParse(row.priceController.text) ?? 0,
                stock: int.tryParse(row.stockController.text) ?? 10,
              );
            }).toList()
          : <ProductVariantEntity>[];

      final finalAddons = _hasAddons
          ? _addonsRows.map((row) {
              return ProductAddonEntity(
                id: row.id,
                name: row.nameController.text.trim(),
                price: double.tryParse(row.priceController.text) ?? 0,
                stock: int.tryParse(row.stockController.text) ?? 10,
              );
            }).toList()
          : <ProductAddonEntity>[];

      final product = ProductEntity(
        id:
            widget.productToEdit?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        categoryName: _selectedCategoryName ?? '',
        categoryId: _selectedCategoryId ?? '',
        description: _descController.text.trim(),
        imageUrl: imageUrl,
        isAvailable: true,
        hasVariants: _hasVariants,
        hasAddons: _hasAddons,
        variants: finalVariants,
        addons: finalAddons,
        price: _hasVariants
            ? null
            : double.tryParse(_singlePriceController.text) ?? 0,
        stock: _hasVariants
            ? null
            : int.tryParse(_singleStockController.text) ?? 10,
      );

      final cubit = context.read<ProductCubit>();

      if (widget.productToEdit == null) {
        await cubit.addProduct(product);
      } else {
        await cubit.updateProduct(product);
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final breakpoint = AppBreakpoints.fromWidth(constraints.maxWidth);
            final isCompact = breakpoint == AppBreakpoint.compact;
            final tokens = context.tokens;
            final pagePadding = isCompact ? tokens.space.sm : tokens.space.md;

            return SingleChildScrollView(
              padding: EdgeInsetsDirectional.only(
                start: pagePadding,
                end: pagePadding,
                top: pagePadding,
                bottom: MediaQuery.viewInsetsOf(context).bottom + pagePadding,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.productToEdit == null
                              ? 'Add Product  '
                              : 'Edit Product',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: tokens.space.xl),
                        ProductIdentitySection(
                          breakpoint: breakpoint,
                          nameController: _nameController,
                          selectedCategoryId: _selectedCategoryId,
                          imagePath: _selectedImagePath,
                          onImageTap: _pickImage,
                          selectedCategoryName: _selectedCategoryName,
                          onCategorySelected: (id, name) {
                            setState(() {
                              _selectedCategoryId = id;
                              _selectedCategoryName = name;
                            });
                          },
                        ),
                        SizedBox(height: tokens.space.md),

                        CustomShadowContanier(
                          child: Column(
                            children: [
                              ProductSectionSwitch(
                                title:
                                    'Is there a size or weight for this product?',
                                subtitle:
                                    'Size (small / medium / large) or (half a kilo / a kilo)',
                                value: _hasVariants,
                                onChanged: (value) {
                                  setState(() => _hasVariants = value);
                                },
                              ),
                              if (!_hasVariants) ...[
                                ProductPriceStockFields(
                                  priceController: _singlePriceController,
                                  stockController: _singleStockController,
                                  compact: isCompact,
                                ),
                              ] else ...[
                                SizedBox(height: tokens.space.sm),
                                ..._variantRows.asMap().entries.map(
                                  (entry) => ProductOptionRow(
                                    controllers: entry.value,
                                    compact: isCompact,
                                    nameLabel: 'Size Name',
                                    nameHint: 'e.g., Large',

                                    deleteTooltip: 'Delete size',
                                    onDelete: () => _removeVariantRow(
                                      entry.value,
                                      entry.key,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          context.tokens.color.brand,
                                    ),
                                    onPressed: () => _addVariantRow(),
                                    icon: const Icon(Icons.add),
                                    label: const Text(
                                      'Adding a new size or weight',
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(height: tokens.space.md),
                        CustomShadowContanier(
                          child: Column(
                            children: [
                              ProductSectionSwitch(
                                title: 'Is there an add-on for this product?',
                                subtitle:
                                    'Example: birthday candle, extra sauce, card',
                                value: _hasAddons,
                                onChanged: (value) {
                                  setState(() => _hasAddons = value);
                                },
                              ),

                              if (_hasAddons) ...[
                                SizedBox(height: tokens.space.sm),
                                ..._addonsRows.asMap().entries.map(
                                  (entry) => ProductOptionRow(
                                    controllers: entry.value,
                                    compact: isCompact,
                                    nameLabel: 'Option Name',
                                    nameHint: 'e.g., Chocolate Sauce Box',
                                    deleteTooltip: 'Delete add-on',
                                    onDelete: _addonsRows.length > 1
                                        ? () => _removeAddonRow(
                                            entry.value,
                                            entry.key,
                                          )
                                        : null,
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          context.tokens.color.brand,
                                    ),
                                    onPressed: () => _addAddonRow(),
                                    icon: const Icon(Icons.add),
                                    label: const Text('إضافة إضافة جديدة'),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(height: tokens.space.md),
                        CustomShadowContanier(
                          child: CustomTextField(
                            label: 'Description',
                            hintText: 'Description',
                            isRequired: true,
                            controller: _descController,
                            minLines: 4,
                            maxLines: 6,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Description is required';
                              }
                              return null;
                            },
                          ),
                        ),

                        SizedBox(height: tokens.space.xl),
                        ProductSubmitButton(
                          isEditing: widget.productToEdit != null,
                          isSaving: _isSaving,
                          onPressed: _saveProduct,
                        ),
                        SizedBox(height: tokens.space.xl),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
