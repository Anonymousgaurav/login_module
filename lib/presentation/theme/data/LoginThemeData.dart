
import 'package:login_module/presentation/theme/data/LoginButtonThemeData.dart';

class LoginThemeData {
  final LoginButtonThemeData loginButtonThemeData;

  LoginThemeData({
    LoginButtonThemeData? loginButtonThemeData,
  }) : this.loginButtonThemeData =
            loginButtonThemeData ?? LoginButtonThemeData.roundedRectangle();

  LoginThemeData copyWith({
    LoginButtonThemeData? loginButtonThemeData,
  }) {
    return LoginThemeData(
      loginButtonThemeData: loginButtonThemeData ?? this.loginButtonThemeData,
    );
  }
}
