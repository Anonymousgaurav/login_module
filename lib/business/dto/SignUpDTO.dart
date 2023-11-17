
import 'package:login_module/business/dto/core/BaseDTO.dart';

class SignUpDTO extends BaseDTO {
  final String mail;
  final String pass;
  final String name;

  const SignUpDTO({
    required this.mail,
    required this.pass,
    this.name = "",
  }) : super();
}
