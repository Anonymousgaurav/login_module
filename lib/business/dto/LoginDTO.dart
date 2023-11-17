
import 'package:login_module/business/dto/core/BaseDTO.dart';

///
/// DTO to perform a 3rd party login
///
class LoginDTO extends BaseDTO {
  final String token;
  final String device;
  final String refreshToken;

  const LoginDTO({
    required this.token,
    required this.device,
    this.refreshToken = "",
  }) : super();
}
