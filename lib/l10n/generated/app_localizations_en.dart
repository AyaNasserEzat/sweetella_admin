// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get darkMode => 'Dark mode';

  @override
  String get products => 'Products';

  @override
  String get addProduct => 'Add product';

  @override
  String get editProduct => 'Edit product';

  @override
  String get deleteProduct => 'Delete product';

  @override
  String get productName => 'Product name';

  @override
  String get productDescription => 'Description';

  @override
  String get category => 'Category';

  @override
  String get price => 'Price';

  @override
  String get salePrice => 'Sale price';

  @override
  String get imageUrl => 'Image URL';

  @override
  String get attributes => 'Options and stock';

  @override
  String get actions => 'Actions';

  @override
  String get attributeTitle => 'Option group (for example, Size)';

  @override
  String get addAttribute => 'Add option group';

  @override
  String get removeAttribute => 'Remove option group';

  @override
  String get addOption => 'Add option';

  @override
  String get removeOption => 'Remove option';

  @override
  String get optionValue => 'Option value';

  @override
  String get priceModifier => 'Price modifier';

  @override
  String get stock => 'Stock';

  @override
  String get available => 'Available';

  @override
  String get outOfStock => 'Out of stock';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save product';

  @override
  String get update => 'Update product';

  @override
  String get retry => 'Retry';

  @override
  String get productsEmpty => 'No products yet';

  @override
  String get productsLoadError => 'Products could not be loaded.';

  @override
  String get permissionDenied =>
      'You do not have permission to manage products.';

  @override
  String get networkError =>
      'Please check your internet connection and try again.';

  @override
  String get unknownError => 'Something went wrong. Please try again.';

  @override
  String get productAdded => 'Product added.';

  @override
  String get productUpdated => 'Product updated.';

  @override
  String get productDeleted => 'Product deleted.';

  @override
  String get productAddError => 'Product could not be added.';

  @override
  String get productUpdateError => 'Product could not be updated.';

  @override
  String get productDeleteError => 'Product could not be deleted.';

  @override
  String get deleteProductTitle => 'Delete product?';

  @override
  String deleteProductMessage(Object name) {
    return 'Delete $name? This cannot be undone.';
  }

  @override
  String requiredField(Object field) {
    return '$field is required.';
  }

  @override
  String get invalidPrice => 'Enter a valid non-negative amount.';

  @override
  String get invalidStock => 'Enter a whole number of zero or more.';

  @override
  String get invalidImageUrl => 'Enter a valid HTTP or HTTPS image URL.';

  @override
  String get selectCategory => 'Select a category';

  @override
  String get noCategories => 'Add a category before creating a product.';

  @override
  String get unknownCategory => 'Unknown category';

  @override
  String productImage(Object name) {
    return 'Image of $name';
  }

  @override
  String get currencyCode => 'EGP';

  @override
  String get unauthorizedError =>
      'You are not authorized. Please sign in again.';

  @override
  String get forbiddenError =>
      'You don\'t have permission to perform this action.';

  @override
  String get notFoundError => 'The requested resource was not found.';

  @override
  String get invalidDataError => 'The provided data is invalid.';

  @override
  String get serverError =>
      'Something went wrong on the server. Please try again later.';

  @override
  String get generalError => 'Something went wrong. Please try again.';

  @override
  String get platformError => 'A platform error occurred. Please try again.';
}
