import 'package:flutter/material.dart';
import 'package:login_module/business/bloc/core/ModBloc.dart';
import 'package:login_module/models/ModResourceResult.dart';
import 'package:login_module/models/ThirdPartyErrorModel.dart';
import 'package:login_module/presentation/LoginBlocProvider.dart';
import 'package:login_module/presentation/widgets/base/ModBaseStatelessWidget.dart';


///
/// Custom base class for stateless widgets that use BLoC
/// <T>: bloc type used by the state object
/// <R>: result data type wrapped inside a ResourceResult
///
abstract class ModBaseStatelessWidgetWithBloc<T extends ModBloc, R> extends ModBaseStatelessWidget {
  T? bloc;

  ModBaseStatelessWidgetWithBloc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.initBloc(context);

    return LoginBlocProvider<T?>(
      bloc: this.bloc,
      child: this._buildStreamForWidget(bloc),
    );
  }

  void initBloc(BuildContext context);

  Widget _buildStreamForWidget(T? bloc) => StreamBuilder<ModResourceResult<R>?>(
      stream: this.bloc!.dataStream as Stream<ModResourceResult<R>?>?,
      builder: (context, snapshot) =>
          this.displayResult(context, snapshot.data));

  T retrieveBloc(BuildContext context) => LoginBlocProvider.ofType<T>(context);

  Widget displayResult(BuildContext context, ModResourceResult<R>? result) {
    if (result != null) {
      switch (result.state) {
        case ResourceState.LOADING:
          return this.buildLoadingState(context);
        case ResourceState.SUCCESS:
          return this.buildSuccessState(context, result.data);
        case ResourceState.ERROR:
          return this.buildErrorState(context, result.error);
        default:
      }
    }
    return this.buildInitialState(context);
  }

  Widget buildInitialState(BuildContext context);
  Widget buildSuccessState(BuildContext context, R? data);
  Widget buildLoadingState(BuildContext context);
  Widget buildErrorState(BuildContext context, ThirdPartyErrorModel? error);
}
