class ServerException implements Exception {
  final String message;

  const ServerException({
    required this.message,
  });

  @override
  String toString() {
    return message;
  }
}


class CacheException implements Exception {
  final String message;

  const CacheException(this.message);

  @override
  String toString() => message;
}