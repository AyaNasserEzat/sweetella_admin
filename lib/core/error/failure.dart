class Failure {
  const Failure(this.kind);

  final FailureKind kind;
}

enum FailureKind {
  network,
  unauthorized,
  forbidden,
  notFound,
  invalidData,
  server,
  firebase,
  platform,
  unknown,
}
