// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get products => 'المنتجات';

  @override
  String get addProduct => 'إضافة منتج';

  @override
  String get editProduct => 'تعديل المنتج';

  @override
  String get deleteProduct => 'حذف المنتج';

  @override
  String get productName => 'اسم المنتج';

  @override
  String get productDescription => 'الوصف';

  @override
  String get category => 'الفئة';

  @override
  String get price => 'السعر';

  @override
  String get salePrice => 'سعر التخفيض';

  @override
  String get imageUrl => 'رابط الصورة';

  @override
  String get attributes => 'الخيارات والمخزون';

  @override
  String get actions => 'الإجراءات';

  @override
  String get attributeTitle => 'مجموعة الخيارات (مثال: الحجم)';

  @override
  String get addAttribute => 'إضافة مجموعة خيارات';

  @override
  String get removeAttribute => 'إزالة مجموعة الخيارات';

  @override
  String get addOption => 'إضافة خيار';

  @override
  String get removeOption => 'إزالة الخيار';

  @override
  String get optionValue => 'قيمة الخيار';

  @override
  String get priceModifier => 'تعديل السعر';

  @override
  String get stock => 'المخزون';

  @override
  String get available => 'متوفر';

  @override
  String get outOfStock => 'نفد المخزون';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ المنتج';

  @override
  String get update => 'تحديث المنتج';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get productsEmpty => 'لا توجد منتجات بعد';

  @override
  String get productsLoadError => 'تعذر تحميل المنتجات.';

  @override
  String get permissionDenied => 'ليس لديك صلاحية لإدارة المنتجات.';

  @override
  String get networkError =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';

  @override
  String get unknownError => 'حدث خطأ. يرجى المحاولة مرة أخرى.';

  @override
  String get productAdded => 'تمت إضافة المنتج.';

  @override
  String get productUpdated => 'تم تحديث المنتج.';

  @override
  String get productDeleted => 'تم حذف المنتج.';

  @override
  String get productAddError => 'تعذرت إضافة المنتج.';

  @override
  String get productUpdateError => 'تعذر تحديث المنتج.';

  @override
  String get productDeleteError => 'تعذر حذف المنتج.';

  @override
  String get deleteProductTitle => 'حذف المنتج؟';

  @override
  String deleteProductMessage(Object name) {
    return 'هل تريد حذف $name؟ لا يمكن التراجع عن ذلك.';
  }

  @override
  String requiredField(Object field) {
    return 'حقل $field مطلوب.';
  }

  @override
  String get invalidPrice => 'أدخل مبلغاً صالحاً أكبر من أو يساوي صفراً.';

  @override
  String get invalidStock => 'أدخل عدداً صحيحاً أكبر من أو يساوي صفراً.';

  @override
  String get invalidImageUrl => 'أدخل رابط صورة صالحاً يبدأ بـ HTTP أو HTTPS.';

  @override
  String get selectCategory => 'اختر فئة';

  @override
  String get noCategories => 'أضف فئة قبل إنشاء منتج.';

  @override
  String get unknownCategory => 'فئة غير معروفة';

  @override
  String productImage(Object name) {
    return 'صورة $name';
  }

  @override
  String get currencyCode => 'EGP';

  @override
  String get unauthorizedError => 'غير مصرح لك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get forbiddenError => 'ليس لديك صلاحية لتنفيذ هذا الإجراء.';

  @override
  String get notFoundError => 'لم يتم العثور على البيانات المطلوبة.';

  @override
  String get invalidDataError => 'البيانات المدخلة غير صالحة.';

  @override
  String get serverError => 'حدث خطأ في الخادم. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get generalError => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get platformError => 'حدث خطأ في النظام. يرجى المحاولة مرة أخرى.';
}
