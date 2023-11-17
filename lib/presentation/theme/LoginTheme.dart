import 'package:flutter/cupertino.dart';
import 'package:login_module/presentation/theme/data/LoginThemeData.dart';

class LoginTheme extends InheritedWidget {
  final LoginThemeData loginThemeData;

  static LoginThemeData? of(BuildContext context) {
    LoginTheme? loginTheme =
        context.dependOnInheritedWidgetOfExactType<LoginTheme>();
    if (loginTheme != null) {
      return loginTheme.loginThemeData;
    }
    return null;
  }

  LoginTheme({
    required this.loginThemeData,
    required Widget child,
    Key? key,
  })  : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
