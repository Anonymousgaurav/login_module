

import 'package:login_module/models/core/ModBaseModel.dart';

///
/// Model used to check available signin methods
///
class ThirdPartyCheckModel extends ModBaseModel {
  final Map<String, bool> availableMethods;

  const ThirdPartyCheckModel(this.availableMethods) : super();

  bool getValueForKeyOrDefault({required String key, bool defValue = false}) => this.availableMethods[key] ?? defValue;
}