import 'package:flutter/material.dart';
import 'package:login_module/business/dto/SessionDTO.dart';
import 'package:login_module/common/ErrorCodes.dart';
import 'package:login_module/common/ModLogger.dart';
import 'package:login_module/models/ModResourceResult.dart';
import 'package:login_module/models/ThirdPartyErrorModel.dart';
import 'package:login_module/models/ThirdPartySessionModel.dart';
import 'package:login_module/presentation/factories/LoginIconButtonFactory.dart';
import 'package:login_module/presentation/factories/LoginWidgetFactory.dart';
import 'package:login_module/presentation/widgets/convenient/ModLoadingWidget.dart';


import '../../../business/bloc/AppleSigninBloc.dart';
import '../base/ModBaseStatelessWidgetWithBloc.dart';


const String TAG = "AppleSigninWidget";


/**
 * Widget that performs Apple sign-in
 */
class AppleSigninWidget extends ModBaseStatelessWidgetWithBloc<AppleSigninBloc, ThirdPartySessionModel> {
  final Function(ThirdPartySessionModel?) onSessionSuccess;
  final Function(int) onSessionError;
  final Function() onReset;
  final Function(String)? onDisplay;
  final bool available;
  final String btnText;
  final Color? loadingColor;

  AppleSigninWidget({
    required this.onSessionSuccess,
    required this.onSessionError,
    required this.onReset,
    this.onDisplay,
    this.available = false,
    required this.btnText,
    this.loadingColor,
    Key? key})
      : assert(onSessionSuccess != null),
        assert(onSessionError != null),
        assert(onReset != null),
        assert(btnText != null),
        super(key: key);

  @override
  void initBloc(BuildContext context) {
    this.bloc = AppleSigninBloc();
  }

  void _call() {
    this.bloc!.processData(ModResourceResult(state: ResourceState.LOADING, data: null, error: null));
    this.bloc!.performOperation(SessionDTO(mail: "", pass: ""));
  }

  @override
  Widget buildInitialState(BuildContext context) {
    return this._wrap(this._buildButton(context));
  }

  @override
  Widget buildLoadingState(BuildContext context) {
    final btn = this._buildButton(context);

    return this._wrap(Stack(children: <Widget>[
      btn,
      ModLoadingWidget(color: this.loadingColor,)
    ],));
  }

  @override
  Widget buildSuccessState(BuildContext context, ThirdPartySessionModel? data) {
    final btn = this._buildButton(context);
    if (data!.validate()) {
      this.onSessionSuccess.call(data);
    } else {
      ModLogger.i(tag: TAG, msg: "cancelled by user");

      //TODO: check if call needed
      this.onSessionError.call(ErrorCodes.INVALID_SESSION);
    }
    return this._wrap(btn);
  }

  @override
  Widget buildErrorState(BuildContext context, ThirdPartyErrorModel? error) {
    final btn = this._buildButton(context);
    this.onSessionError.call(error!.code);
    return this._wrap(btn);
  }

  Widget _wrap(Widget child) => Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.all(4.0),
      child: Center(child: child)
  );

  Widget _buildButton(BuildContext context) =>
      LangAppleSignInButton(
        btnText: this.btnText,
        style: LangButtonStyle.black,
        cornerRadius: 50.0,
        type: LangButtonType.continueButton,
        onPressed: this.available ?
          // AVAIL
          ()  {
            this.onReset.call();

            this._call();
          }
          :
          // NOT AVAIL
          () {
              this.onSessionError(ErrorCodes.SIGNIN_NOT_AVAILABLE);
          },
      );
}


/// A type for the authorization button.
enum LangButtonType { defaultButton, continueButton, signIn }


/// A style for the authorization button.
enum LangButtonStyle { black, whiteOutline, white }


/**
 * Helper class
 */
class LangAppleSignInButton extends StatefulWidget {

  final String btnText;

  /// The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback onPressed;

  /// A type for the authorization button.
  final LangButtonType type;

  /// A style for the authorization button.
  final LangButtonStyle style;

  /// A custom corner radius to be used by this button.
  final double cornerRadius;

  const LangAppleSignInButton({
    required this.btnText,
    required this.onPressed,
    this.type = LangButtonType.defaultButton,
    this.style = LangButtonStyle.black,
    this.cornerRadius = 6,
  })  : assert(type != null),
        assert(style != null),
        assert(cornerRadius != null);

  @override
  State<StatefulWidget> createState() => _LangAppleSignInButtonState();
}

/**
 * Companion state for helper class
 */
class _LangAppleSignInButtonState extends State<LangAppleSignInButton> {

  @override
  Widget build(BuildContext context) {
    final bgColor =
    widget.style == LangButtonStyle.black ? Colors.black : Colors.white;
    final textColor =
    widget.style == LangButtonStyle.black ? Colors.white : Colors.black;
    final borderColor =
    widget.style == LangButtonStyle.white ? Colors.white : Colors.black;

    return LoginWidgetFactory.buildSigninBtn(
        context: context,
        containerColor: bgColor,
        borderColor: borderColor,
        icon: LoginIconButtonFactory.getAppleIcon(height: 25.0, width: 25.0),
        text: this.widget.btnText,
        textColor: textColor,
        onClick: this.widget.onPressed
    );
  }
}