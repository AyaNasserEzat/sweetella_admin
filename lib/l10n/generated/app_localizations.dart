import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get addProduct;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get editProduct;

  /// No description provided for @deleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Delete product'**
  String get deleteProduct;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get productName;

  /// No description provided for @productDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get productDescription;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @salePrice.
  ///
  /// In en, this message translates to:
  /// **'Sale price'**
  String get salePrice;

  /// No description provided for @imageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get imageUrl;

  /// No description provided for @attributes.
  ///
  /// In en, this message translates to:
  /// **'Options and stock'**
  String get attributes;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @attributeTitle.
  ///
  /// In en, this message translates to:
  /// **'Option group (for example, Size)'**
  String get attributeTitle;

  /// No description provided for @addAttribute.
  ///
  /// In en, this message translates to:
  /// **'Add option group'**
  String get addAttribute;

  /// No description provided for @removeAttribute.
  ///
  /// In en, this message translates to:
  /// **'Remove option group'**
  String get removeAttribute;

  /// No description provided for @addOption.
  ///
  /// In en, this message translates to:
  /// **'Add option'**
  String get addOption;

  /// No description provided for @removeOption.
  ///
  /// In en, this message translates to:
  /// **'Remove option'**
  String get removeOption;

  /// No description provided for @optionValue.
  ///
  /// In en, this message translates to:
  /// **'Option value'**
  String get optionValue;

  /// No description provided for @priceModifier.
  ///
  /// In en, this message translates to:
  /// **'Price modifier'**
  String get priceModifier;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get outOfStock;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save product'**
  String get save;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update product'**
  String get update;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @productsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get productsEmpty;

  /// No description provided for @productsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Products could not be loaded.'**
  String get productsLoadError;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to manage products.'**
  String get permissionDenied;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get networkError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get unknownError;

  /// No description provided for @productAdded.
  ///
  /// In en, this message translates to:
  /// **'Product added.'**
  String get productAdded;

  /// No description provided for @productUpdated.
  ///
  /// In en, this message translates to:
  /// **'Product updated.'**
  String get productUpdated;

  /// No description provided for @productDeleted.
  ///
  /// In en, this message translates to:
  /// **'Product deleted.'**
  String get productDeleted;

  /// No description provided for @productAddError.
  ///
  /// In en, this message translates to:
  /// **'Product could not be added.'**
  String get productAddError;

  /// No description provided for @productUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Product could not be updated.'**
  String get productUpdateError;

  /// No description provided for @productDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Product could not be deleted.'**
  String get productDeleteError;

  /// No description provided for @deleteProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete product?'**
  String get deleteProductTitle;

  /// No description provided for @deleteProductMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}? This cannot be undone.'**
  String deleteProductMessage(Object name);

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'{field} is required.'**
  String requiredField(Object field);

  /// No description provided for @invalidPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid non-negative amount.'**
  String get invalidPrice;

  /// No description provided for @invalidStock.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number of zero or more.'**
  String get invalidStock;

  /// No description provided for @invalidImageUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid HTTP or HTTPS image URL.'**
  String get invalidImageUrl;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get selectCategory;

  /// No description provided for @noCategories.
  ///
  /// In en, this message translates to:
  /// **'Add a category before creating a product.'**
  String get noCategories;

  /// No description provided for @unknownCategory.
  ///
  /// In en, this message translates to:
  /// **'Unknown category'**
  String get unknownCategory;

  /// No description provided for @productImage.
  ///
  /// In en, this message translates to:
  /// **'Image of {name}'**
  String productImage(Object name);

  /// No description provided for @currencyCode.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get currencyCode;

  /// No description provided for @unauthorizedError.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized. Please sign in again.'**
  String get unauthorizedError;

  /// No description provided for @forbiddenError.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to perform this action.'**
  String get forbiddenError;

  /// No description provided for @notFoundError.
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found.'**
  String get notFoundError;

  /// No description provided for @invalidDataError.
  ///
  /// In en, this message translates to:
  /// **'The provided data is invalid.'**
  String get invalidDataError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on the server. Please try again later.'**
  String get serverError;

  /// No description provided for @generalError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get generalError;

  /// No description provided for @platformError.
  ///
  /// In en, this message translates to:
  /// **'A platform error occurred. Please try again.'**
  String get platformError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
