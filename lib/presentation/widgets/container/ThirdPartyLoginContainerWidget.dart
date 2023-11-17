import 'dart:io';

import 'package:flutter/material.dart';
import 'package:login_module/business/bloc/CheckSigninMethodsBloc.dart';
import 'package:login_module/business/dto/CheckSignersDTO.dart';
import 'package:login_module/common/ErrorCodes.dart';
import 'package:login_module/common/ModLogger.dart';
import 'package:login_module/models/ModResourceResult.dart';
import 'package:login_module/models/ThirdPartyCheckModel.dart';
import 'package:login_module/models/ThirdPartyConfigModel.dart';
import 'package:login_module/models/ThirdPartyErrorModel.dart';
import 'package:login_module/models/ThirdPartySessionModel.dart';
import 'package:login_module/presentation/factories/LoginWidgetFactory.dart';
import 'package:login_module/presentation/resources/LoginTexts.dart';
import 'package:login_module/presentation/widgets/base/ModBaseStateWithBloc.dart';
import 'package:login_module/presentation/widgets/convenient/ModLoadingWidget.dart';
import 'package:login_module/presentation/widgets/single/AppleSigninWidget.dart';
import 'package:login_module/presentation/widgets/single/FacebookSigninWidget.dart';
import 'package:login_module/presentation/widgets/single/GoogleSigninWidget.dart';



const String TAG = "ExternalLoginWidget";


///
/// Container with 3rd party login libs:
/// - Google
/// - Apple
/// - Facebook
///
class ThirdPartyLoginContainerWidget extends StatefulWidget {
  final Function(ThirdPartySessionModel) onLoginSuccess;
  final Function(int) onLoginError;
  final Function(String) onDisplay;
  final ThirdPartyConfigModel config;

  ThirdPartyLoginContainerWidget({
    required this.onLoginSuccess, 
    required this.onLoginError, 
    required this.onDisplay,
    required this.config,
    Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ThirdPartyLoginContainerWidgetState();
}

///
/// Companion state class
///
class _ThirdPartyLoginContainerWidgetState
    extends ModBaseStateWithBloc<ThirdPartyLoginContainerWidget, CheckSigninMethodsBloc, ThirdPartyCheckModel>  {
  bool forwardDone = false;//XXX: flag for redirection

  _ThirdPartyLoginContainerWidgetState() : super();
  
  @override
  void initBloc(BuildContext context) {
    this.bloc = CheckSigninMethodsBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    this._call();
  }

  void _call() {
    this.bloc!.processData(
        ModResourceResult(state: ResourceState.LOADING, data: null, error: null));
    this.bloc!.performOperation(
        CheckSignersDTO([
          LoginTexts.APPLE,
          LoginTexts.GOOGLE,
          LoginTexts.FACEBOOK]
        ));
  }

  @override
  Widget buildErrorState(BuildContext context, ThirdPartyErrorModel? error) {
    this.forwardDone = false;
    return this._buildButtonContainer(ThirdPartyCheckModel(Map<String, bool>()));
  }

  @override
  Widget buildInitialState(BuildContext context) {
    this.forwardDone = false;
    return this._buildButtonContainer(ThirdPartyCheckModel(Map<String, bool>()));
  }

  @override
  Widget buildLoadingState(BuildContext context) {
    this.forwardDone = false;
    return ModLoadingWidget(color: this.widget.config.loadingColor,);
  }

  @override
  Widget buildSuccessState(BuildContext context, ThirdPartyCheckModel? session) {
    return this._buildButtonContainer(session!);
  }

  Widget _buildButtonContainer(ThirdPartyCheckModel model) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: _Dimens.MID_SPACING),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            this._buildLoginGoogle(model.getValueForKeyOrDefault(key: LoginTexts.GOOGLE, defValue: Platform.isIOS)),
            LoginWidgetFactory.buildEmptyVerticalSeparator(height: _Dimens.SMALL_SPACING),

            this._buildLoginFacebook(model.getValueForKeyOrDefault(key: LoginTexts.FACEBOOK, defValue: true),),
            LoginWidgetFactory.buildEmptyVerticalSeparator(height: _Dimens.SMALL_SPACING),

            this._buildLoginApple(model.getValueForKeyOrDefault(key: LoginTexts.APPLE, defValue: true)),
          ],
        )
      );
  }

  Widget _buildLoginGoogle(bool available) {
    return GoogleSigninWidget(
      onSessionSuccess: this._onSessionSuccess,
      onSessionError: this._onSessionError,
      onDisplay: this.widget.onDisplay,
      onReset: this._onReset,
      available: available,
      btnText: this.widget.config.googleText,
      loadingColor: this.widget.config.loadingColor,
    );
  }

  Widget _buildLoginApple(bool available) {
    return AppleSigninWidget(
      onSessionSuccess: this._onSessionSuccess,
      onSessionError: this._onSessionError,
      onDisplay: this.widget.onDisplay,
      onReset: this._onReset,
      available: available,
      btnText: this.widget.config.appleText,
      loadingColor: this.widget.config.loadingColor,
    );
  }

  Widget _buildLoginFacebook(bool available) {
    return FacebookSigninWidget(
      onSessionSuccess: this._onSessionSuccess,
      onSessionError: this._onSessionError,
      onDisplay: this.widget.onDisplay,
      onReset: this._onReset,
      available: available,
      btnText: this.widget.config.fbText,
      fbId: this.widget.config.fbId,
    );
  }
  
  void _onSessionSuccess(ThirdPartySessionModel? session) {
    ModLogger.log("$TAG, session created: ${session?.toString()}");

    if (session != null && session.mailValidationDone && !this.forwardDone) {
      this.forwardDone = true;
      
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        this.widget.onLoginSuccess(session);
      });

    } else {
      ModLogger.e(tag: TAG, msg: "Invalid session, already forwarded or not validated ${session?.mail}", error: null);

      this.widget.onLoginError(ErrorCodes.SIGNIN);
    }
  }

  void _onSessionError(int error) {
    ModLogger.e(tag: TAG, msg: "session error", error: null);

    this.widget.onLoginError(error);
  }

  void _onReset() {
    this.forwardDone = false;
  }
}

abstract class _Dimens {
  static const double SMALL_SPACING = 4.0;
  static const double MID_SPACING = 16.0;
}
