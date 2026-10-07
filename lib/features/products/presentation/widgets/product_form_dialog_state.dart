part of 'product_form_dialog.dart';

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final ProductFormData _data = ProductFormData(widget.product);
  String? _attributesError;
  bool _isSaving = false;

  @override
  void dispose() {
    _data.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compact =
        AppBreakpoints.fromWidth(screenWidth) == AppBreakpoint.compact;
    final categories = [...widget.categories];
    final categoryId = _data.categoryId;
    if (categoryId != null &&
        !categories.any((category) => category.id == categoryId)) {
      categories.add(
        ProductCategory(id: categoryId, name: categoryId, imageUrl: ''),
      );
    }

    return ProductFormDialogContent(
      formKey: _formKey,
      data: _data,
      categories: categories,
      isEditing: widget.product != null,
      isSaving: _isSaving,
      compact: compact,
      dialogWidth: compact ? screenWidth * 0.9 : screenWidth * 0.75,
      attributesError: _attributesError,
      onCategoryChanged: (value) => setState(() {
        _data.categoryId = value;
        _data.categoryName = value == null
            ? ''
            : categories
                  .firstWhere(
                    (category) => category.id == value,
                    orElse: () =>
                        ProductCategory(id: value, name: value, imageUrl: ''),
                  )
                  .name;
      }),
      onAddAttribute: _addAttribute,
      onRemoveAttribute: _removeAttribute,
      onAddOption: _addOption,
      onRemoveOption: _removeOption,
      onSave: _save,
    );
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    if (!_formKey.currentState!.validate()) return;
    if (_data.attributes.any((attribute) => attribute.options.isEmpty)) {
      setState(() => _attributesError = l10n.requiredField(l10n.addOption));
      return;
    }

    setState(() {
      _attributesError = null;
      _isSaving = true;
    });
    final saved = await widget.onSave(
      _data.toProduct(widget.product?.id ?? ''),
    );
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _isSaving = false);
    }
  }

  void _addAttribute() {
    setState(() {
      _attributesError = null;
      _data.attributes.add(ProductAttributeFormData());
    });
  }

  void _removeAttribute(int index) {
    setState(() {
      _data.attributes.removeAt(index).dispose();
      _attributesError = null;
    });
  }

  void _addOption(int attributeIndex) {
    setState(() {
      _attributesError = null;
      _data.attributes[attributeIndex].options.add(ProductOptionFormData());
    });
  }

  void _removeOption(int attributeIndex, int optionIndex) {
    setState(() {
      _data.attributes[attributeIndex].options.removeAt(optionIndex).dispose();
      _attributesError = null;
    });
  }
}
