import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweetella_admin/core/extension/localization_extension.dart';
import 'package:sweetella_admin/features/products/domain/errors/product_failure.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_cubit.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_state.dart';

class ProductOperationListener extends StatelessWidget {
  const ProductOperationListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductCubit, ProductState>(
      listener: (context, state) {
        final message = _messageFor(context, state);
        if (message != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
        }
      },
      child: child,
    );
  }

  String? _messageFor(BuildContext context, ProductState state) {
    final l10n = context.l10n;
    return switch (state) {
      ProductAddSuccess() => l10n.productAdded,
      ProductUpdateSuccess() => l10n.productUpdated,
      ProductDeleteSuccess() => l10n.productDeleted,
      ProductAddError(:final failure) => _failureMessage(
        context,
        failure,
        l10n.productAddError,
      ),
      ProductUpdateError(:final failure) => _failureMessage(
        context,
        failure,
        l10n.productUpdateError,
      ),
      ProductDeleteError(:final failure) => _failureMessage(
        context,
        failure,
        l10n.productDeleteError,
      ),
      _ => null,
    };
  }

  String _failureMessage(
    BuildContext context,
    ProductFailureKind failure,
    String fallback,
  ) {
    return switch (failure) {
      ProductFailureKind.permissionDenied => context.l10n.permissionDenied,
      ProductFailureKind.unavailable => context.l10n.networkError,
      ProductFailureKind.invalidData || ProductFailureKind.unknown => fallback,
    };
  }
}
