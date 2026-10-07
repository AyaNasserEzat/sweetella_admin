import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/error/failure.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';

extension FailureLocalization on Failure {
  String message(BuildContext context) {
    final l10n = context.l10n;

    return switch (kind) {
      FailureKind.network => l10n.networkError,
      FailureKind.unauthorized => l10n.unauthorizedError,
      FailureKind.forbidden => l10n.forbiddenError,
      FailureKind.notFound => l10n.notFoundError,
      FailureKind.invalidData => l10n.invalidDataError,
      FailureKind.server => l10n.serverError,
      FailureKind.firebase => l10n.generalError,
      FailureKind.platform => l10n.platformError,
      FailureKind.unknown => l10n.unknownError,
    };
  }
}
