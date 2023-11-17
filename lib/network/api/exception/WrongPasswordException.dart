
import 'package:login_module/network/api/exception/INetworkException.dart';

class WrongPasswordException extends INetworkException {
  const WrongPasswordException([String? message]) : super(message);
}
