import 'package:flutter/widgets.dart';
import 'package:login_module/presentation/resources/LoginColors.dart';

class LoginButtonThemeData {
  final double? elevation;
  final ShapeBorder? borderShape;

  LoginButtonThemeData({
    this.elevation,
    this.borderShape,
  });

  factory LoginButtonThemeData.roundedRectangle({
    double elevation = 0,
    Color borderColor = LoginColors.lightGreyColor,
  }) {
    return LoginButtonThemeData(
      elevation: elevation,
      borderShape: RoundedRectangleBorder(
        side: BorderSide(
          color: borderColor,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(50.0),
      ),
    );
  }

  LoginButtonThemeData copyWith({
    double? elevation,
    ShapeBorder? shapeBorder,
  }) {
    return LoginButtonThemeData(
      elevation: elevation ?? this.elevation,
      borderShape: shapeBorder ?? this.borderShape,
    );
  }
}
