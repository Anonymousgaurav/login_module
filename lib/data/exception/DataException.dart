class DataException implements Exception {
  static const String TAG = "DataException";

  final int? code;
  final String? message;

  const DataException([this.code, this.message]) : super();
}
