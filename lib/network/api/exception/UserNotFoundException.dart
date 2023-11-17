
import 'package:login_module/network/api/exception/INetworkException.dart';

class UserNotFoundException extends INetworkException {
  const UserNotFoundException([String? message]) : super(message);
}
