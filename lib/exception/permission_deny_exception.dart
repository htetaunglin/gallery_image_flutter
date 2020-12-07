class PermissionDenyException implements Exception {
  final String message;
  const PermissionDenyException(this.message);

  @override
  String toString() => message;
}
