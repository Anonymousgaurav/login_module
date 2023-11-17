import 'package:flutter/material.dart';
import 'package:login_module/business/bloc/core/ModBloc.dart';
import 'package:login_module/models/ModResourceResult.dart';
import 'package:login_module/models/ThirdPartyErrorModel.dart';
import 'package:login_module/presentation/LoginBlocProvider.dart';
import 'package:login_module/presentation/widgets/base/ModBaseState.dart';

///
/// Base state class for stateful widgets that use BLoC using generics:
/// <S>: stateful widget class binded to this state object
/// <T>: bloc type used by the state object
/// <R>: result data type wrapped inside a ResourceResult
///
abstract class ModBaseStateWithBloc<S extends StatefulWidget, T extends ModBloc, R>  extends ModBaseState<S> {
  T? bloc;

  ModBaseStateWithBloc() : super();

  @override
  void initState() {
    this.initBloc(this.context);

    super.initState();
  }

  void initBloc(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return LoginBlocProvider<T?>(
      bloc: this.bloc,
      child: this._buildStreamForWidget(this.bloc),
    );
  }

  Widget _buildStreamForWidget(T? bloc) => StreamBuilder<ModResourceResult<R>?>(
      initialData: ModResourceResult(data: null, error: null),
      stream: this.bloc!.dataStream as Stream<ModResourceResult<R>?>?,
      builder: (context, snapshot) =>
          this.displayResult(context, snapshot.data));

  T retrieveBloc(BuildContext context) => LoginBlocProvider.ofType<T>(context);

  Widget displayResult(BuildContext context, ModResourceResult<R>? result) {
    switch (result?.state) {
      case ResourceState.LOADING:
        return this.buildLoadingState(context);
      case ResourceState.SUCCESS:
        return this.buildSuccessState(context, result!.data);
      case ResourceState.ERROR:
        return this.buildErrorState(context, result!.error);
      default:
        return this.buildInitialState(context);
    }
  }

  Widget buildInitialState(BuildContext context);
  Widget buildSuccessState(BuildContext context, R? data);
  Widget buildLoadingState(BuildContext context);
  Widget buildErrorState(BuildContext context, ThirdPartyErrorModel? error);
}
