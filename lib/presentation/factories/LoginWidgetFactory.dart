import 'package:flutter/material.dart';
import 'package:login_module/presentation/resources/LoginColors.dart';
import 'package:login_module/presentation/resources/LoginStyles.dart';
import 'package:login_module/presentation/theme/LoginTheme.dart';
import 'package:login_module/presentation/theme/data/LoginButtonThemeData.dart';
import 'package:login_module/presentation/theme/data/LoginThemeData.dart';



abstract class LoginWidgetFactory {
  
  static Widget buildEmptyVerticalSeparator({required double height}) {
    return SizedBox(height: height);
  }

  static Widget buildEmptyHorizontalSeparator({required double width}) {
    return SizedBox(width: width,);
  }

  static Widget buildSigninBtn({
    required BuildContext context,
    required Widget icon,
    required String text,
    required Function() onClick,
    required Color containerColor,
    required Color textColor,
    Color borderColor = LoginColors.lightGreyColor,
    }) {

    LoginThemeData? loginThemeData = LoginTheme.of(context);
    LoginButtonThemeData loginButtonThemeData =
        loginThemeData?.loginButtonThemeData ??
            LoginButtonThemeData.roundedRectangle(borderColor: borderColor);

    return RaisedButton(
      onPressed: () {
        onClick.call();
      },
      elevation: loginButtonThemeData.elevation,
      color: containerColor,
      shape: loginButtonThemeData.borderShape,
      child: _buildButtonContent(icon, text, textColor),
    );
  }

  static _buildButtonContent(Widget icon, String text, Color textColor) => Padding(
    padding: EdgeInsets.all(12.0),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        icon,
        Expanded(
            child: Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(text, style: SessionStyles.buttonStyle.copyWith(color: textColor))
                )
            )
        ),
      ],
    ),
  );
}