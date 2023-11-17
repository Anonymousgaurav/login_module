import 'package:flutter/material.dart';
import 'package:login_module/presentation/resources/LoginColors.dart';
import 'package:login_module/presentation/resources/LoginTexts.dart';


import 'core/ModBaseModel.dart';

/**
 * Model used to store configuration supplied by external client
 */
class ThirdPartyConfigModel extends ModBaseModel {
  final String fbId;
  final String googleText;
  final String appleText;
  final String fbText;
  final Color loadingColor;

  const ThirdPartyConfigModel({
    this.fbId = "",
    this.googleText = LoginTexts.GOOGLE,
    this.appleText = LoginTexts.APPLE,
    this.fbText = LoginTexts.FACEBOOK,
    this.loadingColor = LoginColors.darkGreyColor
  }) : super();

  factory ThirdPartyConfigModel.empty() => const ThirdPartyConfigModel();

  bool validate() => this.fbId.isNotEmpty && this.googleText.isNotEmpty && this.appleText.isNotEmpty && this.fbText.isNotEmpty;
}