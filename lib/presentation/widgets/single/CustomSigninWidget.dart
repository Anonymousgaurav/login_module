import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:login_module/business/bloc/CustomSigninBloc.dart';
import 'package:login_module/business/dto/SessionDTO.dart';
import 'package:login_module/common/ModLogger.dart';
import 'package:login_module/models/ModResourceResult.dart';
import 'package:login_module/models/ThirdPartyErrorModel.dart';
import 'package:login_module/models/ThirdPartySessionModel.dart';
import 'package:login_module/presentation/widgets/IForm.dart';
import 'package:login_module/presentation/widgets/base/ModBaseStatelessWidgetWithBloc.dart';
import 'package:login_module/presentation/widgets/convenient/ModLoadingWidget.dart';



const String TAG = "CustomSigninWidget";


class CustomSigninWidget extends ModBaseStatelessWidgetWithBloc<CustomSigninBloc, ThirdPartySessionModel> {
  final Widget child;
  final Function(ThirdPartySessionModel?) onSessionSuccess;
  final Function(int) onSessionError;
  final Function() onReset;


  CustomSigninWidget({
    required this.child,
    required this.onSessionSuccess,
    required this.onSessionError,
    required this.onReset,
    Key? key}) :
        assert(child != null),
        assert(onSessionSuccess != null),
        assert(onSessionError != null),
        assert(onReset != null),
        super(key: key) {

    if (this.child is IForm) {
      (this.child as IForm).setListener(onChildValidated);
    } else {
      ModLogger.e(tag: TAG, msg: "Unable to set custom signin");
    }
  }

  @override
  Widget buildErrorState(BuildContext context, ThirdPartyErrorModel? error) {
    this.onSessionError(error!.code);

    return this.child;
  }

  @override
  Widget buildInitialState(BuildContext context) {
    return this.child;
  }

  @override
  Widget buildLoadingState(BuildContext context) {
    return Stack(
      children: [
        this.child,
        ModLoadingWidget()
      ],
    );
  }

  @override
  Widget buildSuccessState(BuildContext context, ThirdPartySessionModel? data) {
    if (data!.validate()) {
      this.onSessionSuccess(data);
    }

    return this.child;
  }

  @override
  void initBloc(BuildContext context) {
    this.bloc = CustomSigninBloc();
  }

  void onChildValidated(String mail, String pass) {
    this._call(mail, pass);
  }

  void _call(String mail, String pass) {
    this.bloc!.processData(ModResourceResult(state: ResourceState.LOADING, data: null, error: null));
    this.bloc!.performOperation(SessionDTO(mail: mail, pass: pass));
  }
}