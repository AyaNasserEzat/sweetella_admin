import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/features/categories/presentation/cubit/category_cubit.dart';
import 'package:sweetella_admin/features/categories/presentation/cubit/category_state.dart';

class ProductCategoryField extends StatelessWidget {
  const ProductCategoryField({
    required this.selectedCategoryId,
    required this.onSelected,
    super.key,
  });

  final String? selectedCategoryId;
  final void Function(String id, String name) onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          text: TextSpan(
            text: "Category",
            style: context.tokens.text.titleSmall,
            children: [
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ),
        ),
        SizedBox(height: tokens.space.sm),
        BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const LinearProgressIndicator();
            }

            if (state is CategoryLoadError) {
              return const Text('Failed to load categories');
            }

            if (state is! CategoryDataState || state.categories.isEmpty) {
              return const Text('No categories available');
            }

            final categories = state.categories;
            final selectedId =
                categories.any((category) => category.id == selectedCategoryId)
                ? selectedCategoryId
                : null;

            return DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                valueListenable: ValueNotifier<String?>(selectedId),
                isExpanded: true,
                hint: const Text('Select a category'),
                items: categories.map((category) {
                  return DropdownItem<String>(
                    value: category.id,
                    child: Text(
                      category.categoryName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (categoryId) {
                  if (categoryId == null) return;

                  final selected = categories.firstWhere(
                    (category) => category.id == categoryId,
                  );
                  onSelected(selected.id, selected.categoryName);
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: tokens.space.md),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(tokens.radius.md),
                    border: Border.all(color: tokens.color.brand),
                    color: tokens.color.background,
                  ),
                ),
                iconStyleData: IconStyleData(
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: tokens.size.icon,
                  iconEnabledColor: tokens.color.brand,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(tokens.radius.md),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
