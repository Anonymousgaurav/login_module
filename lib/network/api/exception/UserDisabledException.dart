
import 'package:login_module/network/api/exception/INetworkException.dart';

class UserDisabledException extends INetworkException {
  const UserDisabledException([String? message]) : super(message);
}
