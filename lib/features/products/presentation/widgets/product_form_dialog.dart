// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:sweetella_admin/core/design/app_tokens.dart';
// import 'package:sweetella_admin/core/extension/localization_extension.dart';
// import 'package:sweetella_admin/core/layout/breakpoints.dart';
// import 'package:sweetella_admin/features/products/domain/entities/product.dart';
// import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';
// import 'package:sweetella_admin/l10n/generated/app_localizations.dart';

// class ProductFormDialog extends StatefulWidget {
//   const ProductFormDialog({
//     required this.categories,
//     required this.onSave,
//     this.product,
//     super.key,
//   });

//   final List<ProductCategory> categories;
//   final Product? product;
//   final Future<bool> Function(Product product) onSave;

//   @override
//   State<ProductFormDialog> createState() => _ProductFormDialogState();
// }

// class _ProductFormDialogState extends State<ProductFormDialog> {
//   final _formKey = GlobalKey<FormState>();
//   late final TextEditingController _nameController;
//   late final TextEditingController _descriptionController;
//   late final TextEditingController _priceController;
//   late final TextEditingController _salePriceController;
//   late final TextEditingController _imageUrlController;
//   late final List<_AttributeFields> _attributes;
//   String? _categoryId;
//   String? _attributesError;
//   bool _isSaving = false;

//   @override
//   void initState() {
//     super.initState();
//     final product = widget.product;
//     _nameController = TextEditingController(text: product?.name ?? '');
//     _descriptionController = TextEditingController(
//       text: product?.description ?? '',
//     );
//     _priceController = TextEditingController(
//       text: product == null ? '' : product.price.toString(),
//     );
//     _salePriceController = TextEditingController(
//       text: product == null || product.salePrice == 0
//           ? ''
//           : product.salePrice.toString(),
//     );
//     _imageUrlController = TextEditingController(text: product?.imageUrl ?? '');
//     _categoryId = product?.categoryId;
//     _attributes =
//         product?.attributes.map(_AttributeFields.fromEntity).toList() ?? [];
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descriptionController.dispose();
//     _priceController.dispose();
//     _salePriceController.dispose();
//     _imageUrlController.dispose();
//     for (final attribute in _attributes) {
//       attribute.dispose();
//     }
//     super.dispose();
//   }

//   Future<void> _save() async {
//     final l10n = context.l10n;
//     if (!_formKey.currentState!.validate()) return;
//     final hasEmptyAttribute = _attributes.any(
//       (attribute) => attribute.options.isEmpty,
//     );
//     if (hasEmptyAttribute) {
//       setState(() => _attributesError = l10n.requiredField(l10n.addOption));
//       return;
//     }

//     setState(() {
//       _attributesError = null;
//       _isSaving = true;
//     });
//     final product = Product(
//       id: widget.product?.id ?? '',
//       name: _nameController.text.trim(),
//       categoryId: _categoryId!,
//       description: _descriptionController.text.trim(),
//       price: int.parse(_priceController.text),
//       salePrice: int.tryParse(_salePriceController.text) ?? 0,
//       imageUrl: _imageUrlController.text.trim(),
//       attributes: _attributes.map((attribute) => attribute.toEntity()).toList(),
//     );
//     final saved = await widget.onSave(product);
//     if (!mounted) return;
//     if (saved) {
//       Navigator.of(context).pop(true);
//     } else {
//       setState(() => _isSaving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tokens = context.tokens;
//     final l10n = context.l10n;
//     final isEditing = widget.product != null;
//     final categories = [...widget.categories];
//     if (_categoryId != null &&
//         !categories.any((category) => category.id == _categoryId)) {
//       categories.add(
//         ProductCategory(id: _categoryId!, name: _categoryId!, imageUrl: ''),
//       );
//     }

//     return AlertDialog(
//       title: Text(isEditing ? l10n.editProduct : l10n.addProduct),
//       content: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   final breakpoint = AppBreakpoints.fromWidth(
//                     constraints.maxWidth,
//                   );
//                   final compact = breakpoint == AppBreakpoint.compact;
//                   final fieldWidth = compact
//                       ? constraints.maxWidth
//                       : (constraints.maxWidth - tokens.space.md) / 2;
//                   return Wrap(
//                     spacing: tokens.space.md,
//                     runSpacing: tokens.space.md,
//                     children: [
//                       SizedBox(
//                         width: fieldWidth,
//                         child: _textField(
//                           controller: _nameController,
//                           label: l10n.productName,
//                           required: true,
//                         ),
//                       ),
//                       SizedBox(
//                         width: fieldWidth,
//                         child: DropdownButtonFormField<String>(
//                           initialValue: _categoryId,
//                           decoration: InputDecoration(labelText: l10n.category),
//                           items: categories
//                               .map(
//                                 (category) => DropdownMenuItem(
//                                   value: category.id,
//                                   child: Text(category.name),
//                                 ),
//                               )
//                               .toList(growable: false),
//                           onChanged: _isSaving
//                               ? null
//                               : (value) => setState(() => _categoryId = value),
//                           validator: (value) => value == null
//                               ? l10n.requiredField(l10n.category)
//                               : null,
//                         ),
//                       ),
//                       SizedBox(
//                         width: fieldWidth,
//                         child: _textField(
//                           controller: _priceController,
//                           label: l10n.price,
//                           required: true,
//                           inputFormatters: [
//                             FilteringTextInputFormatter.digitsOnly,
//                           ],
//                           keyboardType: TextInputType.number,
//                           validator: (value) =>
//                               _validatePrice(value, l10n, required: true),
//                         ),
//                       ),
//                       SizedBox(
//                         width: fieldWidth,
//                         child: _textField(
//                           controller: _salePriceController,
//                           label: l10n.salePrice,
//                           inputFormatters: [
//                             FilteringTextInputFormatter.digitsOnly,
//                           ],
//                           keyboardType: TextInputType.number,
//                           validator: (value) =>
//                               _validatePrice(value, l10n, required: false),
//                         ),
//                       ),
//                       SizedBox(
//                         width: fieldWidth,
//                         child: _textField(
//                           controller: _imageUrlController,
//                           label: l10n.imageUrl,
//                           required: true,
//                           keyboardType: TextInputType.url,
//                           validator: (value) {
//                             final requiredError = _requiredError(
//                               value,
//                               l10n.imageUrl,
//                               l10n,
//                             );
//                             if (requiredError != null) return requiredError;
//                             final uri = Uri.tryParse(value!.trim());
//                             if (uri == null ||
//                                 !{'http', 'https'}.contains(uri.scheme) ||
//                                 uri.host.isEmpty) {
//                               return l10n.invalidImageUrl;
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                         width: fieldWidth,
//                         child: _textField(
//                           controller: _descriptionController,
//                           label: l10n.productDescription,
//                           required: true,
//                           minLines: 2,
//                           maxLines: 4,
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//               if (widget.categories.isEmpty && widget.product == null) ...[
//                 SizedBox(height: tokens.space.sm),
//                 Text(
//                   l10n.noCategories,
//                   style: tokens.text.bodySmall.copyWith(
//                     color: tokens.color.warning,
//                   ),
//                 ),
//               ],
//               SizedBox(height: tokens.space.xl),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(l10n.attributes, style: tokens.text.titleSmall),
//                   ),
//                   TextButton.icon(
//                     onPressed: _isSaving ? null : _addAttribute,
//                     icon: const Icon(Icons.add),
//                     label: Text(l10n.addAttribute),
//                   ),
//                 ],
//               ),
//               if (_attributesError != null) ...[
//                 SizedBox(height: tokens.space.xs),
//                 Text(
//                   _attributesError!,
//                   style: tokens.text.bodySmall.copyWith(
//                     color: tokens.color.danger,
//                   ),
//                 ),
//               ],
//               SizedBox(height: tokens.space.sm),
//               for (var index = 0; index < _attributes.length; index++)
//                 _buildAttribute(index, tokens, l10n),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
//           child: Text(l10n.cancel),
//         ),
//         FilledButton(
//           onPressed: _isSaving ? null : _save,
//           child: _isSaving
//               ? SizedBox.square(
//                   dimension: tokens.size.icon,
//                   child: const CircularProgressIndicator(strokeWidth: 2),
//                 )
//               : Text(isEditing ? l10n.update : l10n.save),
//         ),
//       ],
//     );
//   }

//   Widget _buildAttribute(
//     int attributeIndex,
//     AppTokens tokens,
//     AppLocalizations l10n,
//   ) {
//     final attribute = _attributes[attributeIndex];
//     return Container(
//       key: ValueKey('product-attribute-$attributeIndex'),
//       margin: EdgeInsets.only(bottom: tokens.space.md),
//       padding: EdgeInsets.all(tokens.space.md),
//       decoration: BoxDecoration(
//         color: tokens.color.surfaceAlt,
//         borderRadius: BorderRadius.circular(tokens.radius.md),
//         border: Border.all(color: tokens.color.border),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: _textField(
//                   controller: attribute.titleController,
//                   label: l10n.attributeTitle,
//                   required: true,
//                 ),
//               ),
//               IconButton(
//                 tooltip: l10n.removeAttribute,
//                 onPressed: _isSaving
//                     ? null
//                     : () => _removeAttribute(attributeIndex),
//                 icon: const Icon(Icons.delete_outline),
//               ),
//             ],
//           ),
//           for (
//             var optionIndex = 0;
//             optionIndex < attribute.options.length;
//             optionIndex++
//           )
//             _buildOption(attributeIndex, optionIndex, tokens, l10n),
//           Align(
//             alignment: AlignmentDirectional.centerStart,
//             child: TextButton.icon(
//               onPressed: _isSaving ? null : () => _addOption(attributeIndex),
//               icon: const Icon(Icons.add),
//               label: Text(l10n.addOption),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOption(
//     int attributeIndex,
//     int optionIndex,
//     AppTokens tokens,
//     AppLocalizations l10n,
//   ) {
//     final option = _attributes[attributeIndex].options[optionIndex];
//     return Padding(
//       key: ValueKey('product-option-$attributeIndex-$optionIndex'),
//       padding: EdgeInsets.only(top: tokens.space.sm),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final compact =
//               AppBreakpoints.fromWidth(constraints.maxWidth) ==
//               AppBreakpoint.compact;
//           final fieldWidth = compact
//               ? constraints.maxWidth
//               : (constraints.maxWidth - tokens.space.md * 2) / 3;
//           return Wrap(
//             spacing: tokens.space.sm,
//             runSpacing: tokens.space.sm,
//             crossAxisAlignment: WrapCrossAlignment.center,
//             children: [
//               SizedBox(
//                 width: fieldWidth,
//                 child: _textField(
//                   controller: option.valueController,
//                   label: l10n.optionValue,
//                   required: true,
//                 ),
//               ),
//               SizedBox(
//                 width: fieldWidth,
//                 child: _textField(
//                   controller: option.priceModifierController,
//                   label: l10n.priceModifier,
//                   required: true,
//                   keyboardType: const TextInputType.numberWithOptions(
//                     decimal: true,
//                     signed: true,
//                   ),
//                   validator: (value) => double.tryParse(value ?? '') == null
//                       ? l10n.invalidPrice
//                       : null,
//                 ),
//               ),
//               SizedBox(
//                 width: fieldWidth,
//                 child: _textField(
//                   controller: option.stockController,
//                   label: l10n.stock,
//                   required: true,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   validator: (value) {
//                     final stock = int.tryParse(value ?? '');
//                     return stock == null || stock < 0
//                         ? l10n.invalidStock
//                         : null;
//                   },
//                 ),
//               ),
//               IconButton(
//                 tooltip: l10n.removeOption,
//                 onPressed: _isSaving
//                     ? null
//                     : () => _removeOption(attributeIndex, optionIndex),
//                 icon: const Icon(Icons.remove_circle_outline),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _textField({
//     required TextEditingController controller,
//     required String label,
//     bool required = false,
//     TextInputType? keyboardType,
//     List<TextInputFormatter>? inputFormatters,
//     int? minLines,
//     int? maxLines = 1,
//     String? Function(String?)? validator,
//   }) {
//     final l10n = context.l10n;
//     return TextFormField(
//       controller: controller,
//       enabled: !_isSaving,
//       keyboardType: keyboardType,
//       inputFormatters: inputFormatters,
//       minLines: minLines,
//       maxLines: maxLines,
//       decoration: InputDecoration(labelText: label),
//       validator:
//           validator ??
//           (required ? (value) => _requiredError(value, label, l10n) : null),
//     );
//   }

//   String? _validatePrice(
//     String? value,
//     AppLocalizations l10n, {
//     required bool required,
//   }) {
//     final text = value?.trim() ?? '';
//     if (text.isEmpty) {
//       return required ? l10n.requiredField(l10n.price) : null;
//     }
//     final amount = int.tryParse(text);
//     return amount == null || amount < 0 ? l10n.invalidPrice : null;
//   }

//   String? _requiredError(String? value, String label, AppLocalizations l10n) {
//     return value == null || value.trim().isEmpty
//         ? l10n.requiredField(label)
//         : null;
//   }

//   void _addAttribute() {
//     setState(() {
//       _attributesError = null;
//       _attributes.add(_AttributeFields());
//     });
//   }

//   void _removeAttribute(int index) {
//     setState(() {
//       _attributes.removeAt(index).dispose();
//       _attributesError = null;
//     });
//   }

//   void _addOption(int attributeIndex) {
//     setState(() {
//       _attributesError = null;
//       _attributes[attributeIndex].options.add(_OptionFields());
//     });
//   }

//   void _removeOption(int attributeIndex, int optionIndex) {
//     setState(() {
//       _attributes[attributeIndex].options.removeAt(optionIndex).dispose();
//       _attributesError = null;
//     });
//   }
// }

// class _AttributeFields {
//   _AttributeFields({this.title = ''})
//     : titleController = TextEditingController(text: title);

//   factory _AttributeFields.fromEntity(ProductAttribute attribute) {
//     return _AttributeFields(title: attribute.title)
//       ..options.addAll(attribute.options.map(_OptionFields.fromEntity));
//   }

//   final String title;
//   final TextEditingController titleController;
//   final List<_OptionFields> options = [];

//   ProductAttribute toEntity() {
//     return ProductAttribute(
//       title: titleController.text.trim(),
//       options: options.map((option) => option.toEntity()).toList(),
//     );
//   }

//   void dispose() {
//     titleController.dispose();
//     for (final option in options) {
//       option.dispose();
//     }
//   }
// }

// class _OptionFields {
//   _OptionFields({
//     String value = '',
//     String priceModifier = '0',
//     String stock = '0',
//   }) : valueController = TextEditingController(text: value),
//        priceModifierController = TextEditingController(text: priceModifier),
//        stockController = TextEditingController(text: stock);

//   factory _OptionFields.fromEntity(ProductOption option) {
//     return _OptionFields(
//       value: option.value,
//       priceModifier: option.priceModifier.toString(),
//       stock: option.stock.toString(),
//     );
//   }

//   final TextEditingController valueController;
//   final TextEditingController priceModifierController;
//   final TextEditingController stockController;

//   ProductOption toEntity() {
//     return ProductOption(
//       value: valueController.text.trim(),
//       priceModifier: double.parse(priceModifierController.text),
//       stock: int.parse(stockController.text),
//     );
//   }

//   void dispose() {
//     valueController.dispose();
//     priceModifierController.dispose();
//     stockController.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/core/layout/breakpoints.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';
import 'package:sweetella_admin/l10n/generated/app_localizations.dart';

class ProductFormDialog extends StatefulWidget {
  const ProductFormDialog({
    required this.categories,
    required this.onSave,
    this.product,
    super.key,
  });

  final List<ProductCategory> categories;
  final Product? product;
  final Future<bool> Function(Product product) onSave;

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _salePriceController;
  late final TextEditingController _imageUrlController;

  late final List<_AttributeFields> _attributes;

  String? _categoryId;
  String? _attributesError;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    _nameController = TextEditingController(text: product?.name ?? '');

    _descriptionController = TextEditingController(
      text: product?.description ?? '',
    );

    _priceController = TextEditingController(
      text: product == null ? '' : product.price.toString(),
    );

    _salePriceController = TextEditingController(
      text: product == null || product.salePrice == 0
          ? ''
          : product.salePrice.toString(),
    );

    _imageUrlController = TextEditingController(text: product?.imageUrl ?? '');

    _categoryId = product?.categoryId;

    _attributes =
        product?.attributes.map(_AttributeFields.fromEntity).toList() ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _salePriceController.dispose();
    _imageUrlController.dispose();

    for (final attribute in _attributes) {
      attribute.dispose();
    }

    super.dispose();
  }

  Future<void> _save() async {
    final l10n = context.l10n;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final hasEmptyAttribute = _attributes.any(
      (attribute) => attribute.options.isEmpty,
    );

    if (hasEmptyAttribute) {
      setState(() {
        _attributesError = l10n.requiredField(l10n.addOption);
      });
      return;
    }

    setState(() {
      _attributesError = null;
      _isSaving = true;
    });

    final product = Product(
      id: widget.product?.id ?? '',
      name: _nameController.text.trim(),
      categoryId: _categoryId!,
      description: _descriptionController.text.trim(),
      price: int.parse(_priceController.text),
      salePrice: int.tryParse(_salePriceController.text) ?? 0,
      imageUrl: _imageUrlController.text.trim(),
      attributes: _attributes.map((attribute) => attribute.toEntity()).toList(),
    );

    final saved = await widget.onSave(product);

    if (!mounted) {
      return;
    }

    if (saved) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;

    final isEditing = widget.product != null;

    final screenWidth = MediaQuery.sizeOf(context).width;

    final breakpoint = AppBreakpoints.fromWidth(screenWidth);

    final compact = breakpoint == AppBreakpoint.compact;

    final dialogWidth = compact ? screenWidth * 0.9 : screenWidth * 0.75;

    final categories = [...widget.categories];

    if (_categoryId != null &&
        !categories.any((category) => category.id == _categoryId)) {
      categories.add(
        ProductCategory(id: _categoryId!, name: _categoryId!, imageUrl: ''),
      );
    }

    return AlertDialog(
      title: Text(isEditing ? l10n.editProduct : l10n.addProduct),
      content: SizedBox(
        width: dialogWidth,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBasicFields(
                  context: context,
                  tokens: tokens,
                  l10n: l10n,
                  categories: categories,
                  compact: compact,
                ),

                if (widget.categories.isEmpty && widget.product == null) ...[
                  SizedBox(height: tokens.space.sm),
                  Text(
                    l10n.noCategories,
                    style: tokens.text.bodySmall.copyWith(
                      color: tokens.color.warning,
                    ),
                  ),
                ],

                SizedBox(height: tokens.space.xl),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.attributes,
                        style: tokens.text.titleSmall,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _isSaving ? null : _addAttribute,
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addAttribute),
                    ),
                  ],
                ),

                if (_attributesError != null) ...[
                  SizedBox(height: tokens.space.xs),
                  Text(
                    _attributesError!,
                    style: tokens.text.bodySmall.copyWith(
                      color: tokens.color.danger,
                    ),
                  ),
                ],

                SizedBox(height: tokens.space.sm),

                for (var index = 0; index < _attributes.length; index++)
                  _buildAttribute(index, tokens, l10n, compact),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? SizedBox.square(
                  dimension: tokens.size.icon,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? l10n.update : l10n.save),
        ),
      ],
    );
  }

  Widget _buildBasicFields({
    required BuildContext context,
    required AppTokens tokens,
    required AppLocalizations l10n,
    required List<ProductCategory> categories,
    required bool compact,
  }) {
    final fields = [
      _buildNameField(l10n),
      _buildCategoryField(l10n, categories),
      _buildPriceField(l10n),
      _buildSalePriceField(l10n),
      _buildImageUrlField(l10n),
      _buildDescriptionField(l10n),
    ];

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < fields.length; index++) ...[
            fields[index],
            if (index != fields.length - 1) SizedBox(height: tokens.space.md),
          ],
        ],
      );
    }

    return Wrap(
      spacing: tokens.space.md,
      runSpacing: tokens.space.md,
      children: [
        for (final field in fields)
          SizedBox(
            width:
                (MediaQuery.sizeOf(context).width * 0.75 - tokens.space.md) / 2,
            child: field,
          ),
      ],
    );
  }

  Widget _buildNameField(AppLocalizations l10n) {
    return _textField(
      controller: _nameController,
      label: l10n.productName,
      required: true,
    );
  }

  Widget _buildCategoryField(
    AppLocalizations l10n,
    List<ProductCategory> categories,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: _categoryId,
      decoration: InputDecoration(labelText: l10n.category),
      items: categories
          .map(
            (category) => DropdownMenuItem(
              value: category.id,
              child: Text(category.name),
            ),
          )
          .toList(growable: false),
      onChanged: _isSaving
          ? null
          : (value) {
              setState(() {
                _categoryId = value;
              });
            },
      validator: (value) =>
          value == null ? l10n.requiredField(l10n.category) : null,
    );
  }

  Widget _buildPriceField(AppLocalizations l10n) {
    return _textField(
      controller: _priceController,
      label: l10n.price,
      required: true,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      validator: (value) => _validatePrice(value, l10n, required: true),
    );
  }

  Widget _buildSalePriceField(AppLocalizations l10n) {
    return _textField(
      controller: _salePriceController,
      label: l10n.salePrice,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      validator: (value) => _validatePrice(value, l10n, required: false),
    );
  }

  Widget _buildImageUrlField(AppLocalizations l10n) {
    return _textField(
      controller: _imageUrlController,
      label: l10n.imageUrl,
      required: true,
      keyboardType: TextInputType.url,
      validator: (value) {
        final requiredError = _requiredError(value, l10n.imageUrl, l10n);

        if (requiredError != null) {
          return requiredError;
        }

        final uri = Uri.tryParse(value!.trim());

        if (uri == null ||
            !{'http', 'https'}.contains(uri.scheme) ||
            uri.host.isEmpty) {
          return l10n.invalidImageUrl;
        }

        return null;
      },
    );
  }

  Widget _buildDescriptionField(AppLocalizations l10n) {
    return _textField(
      controller: _descriptionController,
      label: l10n.productDescription,
      required: true,
      minLines: 2,
      maxLines: 4,
    );
  }

  Widget _buildAttribute(
    int attributeIndex,
    AppTokens tokens,
    AppLocalizations l10n,
    bool compact,
  ) {
    final attribute = _attributes[attributeIndex];

    return Container(
      key: ValueKey('product-attribute-$attributeIndex'),
      margin: EdgeInsets.only(bottom: tokens.space.md),
      padding: EdgeInsets.all(tokens.space.md),
      decoration: BoxDecoration(
        color: tokens.color.surfaceAlt,
        borderRadius: BorderRadius.circular(tokens.radius.md),
        border: Border.all(color: tokens.color.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _textField(
                  controller: attribute.titleController,
                  label: l10n.attributeTitle,
                  required: true,
                ),
              ),
              IconButton(
                tooltip: l10n.removeAttribute,
                onPressed: _isSaving
                    ? null
                    : () => _removeAttribute(attributeIndex),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),

          for (
            var optionIndex = 0;
            optionIndex < attribute.options.length;
            optionIndex++
          )
            _buildOption(attributeIndex, optionIndex, tokens, l10n, compact),

          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: _isSaving ? null : () => _addOption(attributeIndex),
              icon: const Icon(Icons.add),
              label: Text(l10n.addOption),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    int attributeIndex,
    int optionIndex,
    AppTokens tokens,
    AppLocalizations l10n,
    bool compact,
  ) {
    final option = _attributes[attributeIndex].options[optionIndex];

    final fields = [
      _textField(
        controller: option.valueController,
        label: l10n.optionValue,
        required: true,
      ),
      _textField(
        controller: option.priceModifierController,
        label: l10n.priceModifier,
        required: true,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        validator: (value) =>
            double.tryParse(value ?? '') == null ? l10n.invalidPrice : null,
      ),
      _textField(
        controller: option.stockController,
        label: l10n.stock,
        required: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          final stock = int.tryParse(value ?? '');

          return stock == null || stock < 0 ? l10n.invalidStock : null;
        },
      ),
    ];

    return Padding(
      key: ValueKey('product-option-$attributeIndex-$optionIndex'),
      padding: EdgeInsets.only(top: tokens.space.sm),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                fields[0],
                SizedBox(height: tokens.space.sm),
                fields[1],
                SizedBox(height: tokens.space.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: fields[2]),
                    IconButton(
                      tooltip: l10n.removeOption,
                      onPressed: _isSaving
                          ? null
                          : () => _removeOption(attributeIndex, optionIndex),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: fields[0]),
                SizedBox(width: tokens.space.sm),
                Expanded(child: fields[1]),
                SizedBox(width: tokens.space.sm),
                Expanded(child: fields[2]),
                IconButton(
                  tooltip: l10n.removeOption,
                  onPressed: _isSaving
                      ? null
                      : () => _removeOption(attributeIndex, optionIndex),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
              ],
            ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    bool required = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? minLines,
    int? maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final l10n = context.l10n;

    return TextFormField(
      controller: controller,
      enabled: !_isSaving,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label),
      validator:
          validator ??
          (required ? (value) => _requiredError(value, label, l10n) : null),
    );
  }

  String? _validatePrice(
    String? value,
    AppLocalizations l10n, {
    required bool required,
  }) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return required ? l10n.requiredField(l10n.price) : null;
    }

    final amount = int.tryParse(text);

    return amount == null || amount < 0 ? l10n.invalidPrice : null;
  }

  String? _requiredError(String? value, String label, AppLocalizations l10n) {
    return value == null || value.trim().isEmpty
        ? l10n.requiredField(label)
        : null;
  }

  void _addAttribute() {
    setState(() {
      _attributesError = null;
      _attributes.add(_AttributeFields());
    });
  }

  void _removeAttribute(int index) {
    setState(() {
      _attributes.removeAt(index).dispose();
      _attributesError = null;
    });
  }

  void _addOption(int attributeIndex) {
    setState(() {
      _attributesError = null;
      _attributes[attributeIndex].options.add(_OptionFields());
    });
  }

  void _removeOption(int attributeIndex, int optionIndex) {
    setState(() {
      _attributes[attributeIndex].options.removeAt(optionIndex).dispose();

      _attributesError = null;
    });
  }
}

class _AttributeFields {
  _AttributeFields({this.title = ''})
    : titleController = TextEditingController(text: title);

  factory _AttributeFields.fromEntity(ProductAttribute attribute) {
    return _AttributeFields(title: attribute.title)
      ..options.addAll(attribute.options.map(_OptionFields.fromEntity));
  }

  final String title;
  final TextEditingController titleController;
  final List<_OptionFields> options = [];

  ProductAttribute toEntity() {
    return ProductAttribute(
      title: titleController.text.trim(),
      options: options.map((option) => option.toEntity()).toList(),
    );
  }

  void dispose() {
    titleController.dispose();

    for (final option in options) {
      option.dispose();
    }
  }
}

class _OptionFields {
  _OptionFields({
    String value = '',
    String priceModifier = '0',
    String stock = '0',
  }) : valueController = TextEditingController(text: value),
       priceModifierController = TextEditingController(text: priceModifier),
       stockController = TextEditingController(text: stock);

  factory _OptionFields.fromEntity(ProductOption option) {
    return _OptionFields(
      value: option.value,
      priceModifier: option.priceModifier.toString(),
      stock: option.stock.toString(),
    );
  }

  final TextEditingController valueController;
  final TextEditingController priceModifierController;
  final TextEditingController stockController;

  ProductOption toEntity() {
    return ProductOption(
      value: valueController.text.trim(),
      priceModifier: double.parse(priceModifierController.text),
      stock: int.parse(stockController.text),
    );
  }

  void dispose() {
    valueController.dispose();
    priceModifierController.dispose();
    stockController.dispose();
  }
}
