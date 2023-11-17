import 'package:flutter/material.dart';
import 'package:login_module/business/bloc/GoogleSigninBloc.dart';
import 'package:login_module/business/dto/SessionDTO.dart';
import 'package:login_module/common/ErrorCodes.dart';
import 'package:login_module/models/ModResourceResult.dart';
import 'package:login_module/models/ThirdPartyErrorModel.dart';
import 'package:login_module/models/ThirdPartySessionModel.dart';
import 'package:login_module/presentation/factories/LoginIconButtonFactory.dart';
import 'package:login_module/presentation/factories/LoginWidgetFactory.dart';
import 'package:login_module/presentation/resources/LoginColors.dart';
import 'package:login_module/presentation/widgets/convenient/ModLoadingWidget.dart';


import '../base/ModBaseStatelessWidgetWithBloc.dart';


const String TAG = "GoogleSigninWidget";


/**
 * Widget that performs Google sign-in
 */
class GoogleSigninWidget extends ModBaseStatelessWidgetWithBloc<GoogleSigninBloc, ThirdPartySessionModel> {
  final Function(ThirdPartySessionModel?) onSessionSuccess;
  final Function(int) onSessionError;
  final Function() onReset;
  final Function(String)? onDisplay;
  final bool available;
  final String btnText;
  final Color? loadingColor;
  
  GoogleSigninWidget({
    required this.onSessionSuccess,
    required this.onSessionError,
    required this.onReset,
    this.onDisplay,
    this.available = true,
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
    this.bloc = GoogleSigninBloc();
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

  Widget _buildButton(BuildContext context) => LoginWidgetFactory.buildSigninBtn(
      context: context,
      containerColor: LoginColors.whiteColor,
      borderColor: LoginColors.blackColor,
      icon: LoginIconButtonFactory.getGoogleIcon(height: 25.0, width: 25.0),
      text: this.btnText,
      textColor: LoginColors.blackColor,
      onClick: this.available?
          // AVAIL
          () {
            this.onReset.call();

            this._call();
          }
            :
          // NOT AVAIL
          () {
            this.onSessionError(ErrorCodes.SIGNIN_NOT_AVAILABLE);
          }
  );
}
