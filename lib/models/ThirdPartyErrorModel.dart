

import 'package:login_module/models/core/ModBaseModel.dart';

/**
 * Model used to encapsulate errors
 */
class ThirdPartyErrorModel implements ModBaseModel {
  final int code;
  final String trace;

  const ThirdPartyErrorModel({this.code = 0, this.trace = ""}) : super();
}