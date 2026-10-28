import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/error/app_failuer)localization.dart';
import 'package:sweetella_admin/core/widgets/custom_overlay_message.dart';
import 'package:sweetella_admin/core/widgets/custom_shadow_container.dart';
import 'package:sweetella_admin/features/categories/domain/entities/category.dart';
import 'package:sweetella_admin/features/categories/presentation/cubit/category_cubit.dart';
import 'package:sweetella_admin/features/categories/presentation/cubit/category_state.dart';
import 'package:sweetella_admin/features/categories/presentation/widgets/custom_text_field.dart';
import 'package:sweetella_admin/features/categories/presentation/widgets/image_upload_box.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({this.category, super.key});

  final Category? category;

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _isSaving = false;
  String? _selectedImagePath;
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.category?.categoryName ?? '';
    _selectedImagePath = widget.category?.image;
  }

  @override
  void dispose() {
    _nameController.dispose();
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

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate() || _isSaving) {
      return;
    }

    setState(() => _isSaving = true);

    final cubit = context.read<CategoryCubit>();
    try {
      var imageUrl = widget.category?.image ?? '';
      final selectedImage = _selectedImage;

      if (selectedImage != null) {
        final uploadedImageUrl = await cubit.uploadCategoryImage(selectedImage);
        if (!mounted || uploadedImageUrl == null) return;
        imageUrl = uploadedImageUrl;
      }

      final category = Category(
        id: widget.category?.id ?? '',
        categoryName: _nameController.text.trim(),
        image: imageUrl,
      );

      if (widget.category == null) {
        await cubit.addCategory(category);
      } else {
        await cubit.updateCategory(category);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.category == null ? 'Add Category' : 'Edit Category';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShadowContanier(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          label: 'Category name',
                          hintText: 'Category name',
                          isRequired: true,
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Category name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ImageUploadBox(
                          imagePath: _selectedImagePath,
                          onTap: _pickImage,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    BlocListener<CategoryCubit, CategoryState>(
                      listener: (context, state) {
                        if (state is CategoryUploadError) {
                          showOverlayMessage(
                            context: context,
                            text: state.failure.message(context),
                            isError: true,
                          );
                        }
                        if (state is CategoryUpdateError) {
                          showOverlayMessage(
                            context: context,
                            text: state.failure.message(context),
                            isError: true,
                          );
                        }
                        if (state is CategoryAddError) {
                          print("errrror");
                          showOverlayMessage(
                            context: context,
                            text: state.failure.message(context),
                            isError: true,
                          );
                        }
                        if (state is CategoryUploadError) {
                          showOverlayMessage(
                            context: context,
                            text: state.failure.message(context),
                            isError: true,
                          );
                        }
                      },
                      child: Expanded(
                        child: ElevatedButton(
                          onPressed: _isSaving ? () {} : _saveCategory,
                          child: Text(_isSaving ? 'Saving...' : title),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: Theme.of(context).elevatedButtonTheme.style
                            ?.copyWith(
                              backgroundColor: WidgetStatePropertyAll(
                                context.tokens.color.surface,
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                context.tokens.color.brand,
                              ),
                              side: WidgetStatePropertyAll(
                                BorderSide(color: context.tokens.color.brand),
                              ),
                            ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("cancle"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
