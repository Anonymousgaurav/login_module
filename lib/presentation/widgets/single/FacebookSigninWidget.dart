import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:login_module/common/ErrorCodes.dart';
import 'package:login_module/common/ModLogger.dart';
import 'package:login_module/models/ThirdPartySessionModel.dart';
import 'package:login_module/presentation/factories/LoginIconButtonFactory.dart';
import 'package:login_module/presentation/factories/LoginWidgetFactory.dart';
import 'package:login_module/presentation/resources/LoginColors.dart';


const TAG = "FacebookSigninWidget";

/**
 * Widget that performs Facebook sign-in
 */
class FacebookSigninWidget extends StatefulWidget {
  final Function(ThirdPartySessionModel) onSessionSuccess;
  final Function(int) onSessionError;
  final Function() onReset;
  final Function(String)? onDisplay;
  final bool available;
  final String btnText;
  final String fbId;

  const FacebookSigninWidget({
    required this.onSessionSuccess,
    required this.onSessionError,
    required this.onReset,
    required this.btnText,
    required this.fbId,
    this.onDisplay,
    this.available = true,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FacebookSigninWidgetState();
}

class _FacebookSigninWidgetState extends State<FacebookSigninWidget> {
  void _login() async {
    try {
      LoginResult loginResult = await FacebookAuth.instance.login();
      AccessToken? accessToken = loginResult.accessToken;
      // RES
      if (accessToken != null) {
        final fbCred = FacebookAuthProvider.credential(accessToken.token);
        final user = await FirebaseAuth.instance.signInWithCredential(fbCred);
        if (user.user != null) {
          final token = await user.user!.getIdToken();

          this.widget.onSessionSuccess.call(ThirdPartySessionModel(
                mail: user.user!.email,
                token: token,
                display: user.user!.displayName,
                pic: user.user!.photoURL,
                mailValidationDone: true,
              ));
          return;
        }
      }

      // NO RES
      this
          .widget
          .onSessionSuccess
          .call(ThirdPartySessionModel.requiresMailValidation());
    } on Exception catch (e) {
      ModLogger.e(tag: TAG, msg: "_processResult() ${e.toString()}", error: e);

      this.widget.onSessionError.call(ErrorCodes.FACEBOOK_SIGNIN);
    }

    this.setState(() {}); //XXX: launches rebuild and postFrame on External
  }

  @override
  Widget build(BuildContext context) {
    return this._wrap(this._buildButton(context));
  }

  Widget _wrap(Widget child) => Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.all(4.0),
      child: Center(child: child));

  Widget _buildButton(BuildContext context) =>
      LoginWidgetFactory.buildSigninBtn(
          context: context,
          containerColor: LoginColors.blueColor,
          borderColor: LoginColors.blueColor,
          icon:
              LoginIconButtonFactory.getFacebookIcon(height: 25.0, width: 25.0),
          text: this.widget.btnText,
          textColor: LoginColors.whiteColor,
          onClick: this.widget.available
              ?

              // AVAIL
              () {
                  this.widget.onReset.call();
                  this._login();
                }
              :
              // NOT AVAIL
              () {
                  this
                      .widget
                      .onSessionError
                      .call(ErrorCodes.SIGNIN_NOT_AVAILABLE);
                });
}
