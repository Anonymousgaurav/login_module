
import 'package:login_module/business/dto/core/BaseDTO.dart';

/**
 * DTO for checking available sign in methods
 */
class CheckSignersDTO extends BaseDTO {
  final List<String> targets;

  const CheckSignersDTO(this.targets) : super();
}