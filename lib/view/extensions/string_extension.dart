extension CustomExtensions on String {
  String shortened({int? limit}) {
    if (length < (limit ?? 50)) {
      return this;
    }
    return '${substring(0, limit ?? 50)}...';
  }
}
