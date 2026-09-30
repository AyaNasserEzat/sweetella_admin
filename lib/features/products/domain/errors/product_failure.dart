enum ProductFailureKind { permissionDenied, unavailable, invalidData, unknown }

class ProductFailure implements Exception {
  const ProductFailure(this.kind);

  final ProductFailureKind kind;
}
