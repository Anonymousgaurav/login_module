
import 'package:login_module/network/api/exception/INetworkException.dart';

class UnverifiedMailException extends INetworkException {
  const UnverifiedMailException([String? message]) : super(message);
}
