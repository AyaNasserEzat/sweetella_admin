import 'package:sweetella_admin/l10n/generated/app_localizations.dart';

abstract final class ProductFormValidators {
  static String? required(String? value, String label, AppLocalizations l10n) {
    return value == null || value.trim().isEmpty
        ? l10n.requiredField(label)
        : null;
  }

  static String? price(
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

  static String? imageUrl(String? value, AppLocalizations l10n) {
    final requiredError = required(value, l10n.imageUrl, l10n);
    if (requiredError != null) return requiredError;

    final uri = Uri.tryParse(value!.trim());
    if (uri == null ||
        !{'http', 'https'}.contains(uri.scheme) ||
        uri.host.isEmpty) {
      return l10n.invalidImageUrl;
    }
    return null;
  }
}
