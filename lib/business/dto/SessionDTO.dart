
import 'package:login_module/business/dto/core/BaseDTO.dart';

///
/// DTO to request session creation
///
class SessionDTO extends BaseDTO {
  final String mail;
  final String pass;

  const SessionDTO({
    required this.mail,
    required this.pass,
  }) : super();
}
