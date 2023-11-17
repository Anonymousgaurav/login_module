
import 'package:login_module/network/api/exception/INetworkException.dart';

class InvalidEmailException extends INetworkException {
  const InvalidEmailException([String? message]) : super(message);
}
