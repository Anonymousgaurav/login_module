import 'package:flutter/material.dart';

import '../business/bloc/core/ModBloc.dart';

///
/// Bloc dependency injector
/// <T>: bloc type we want to inject in the tree
///
class LoginBlocProvider<T extends ModBloc?> extends StatefulWidget {
  final Widget child;
  final T bloc;

  const LoginBlocProvider({Key? key, required this.child, required this.bloc}) : assert(bloc != null), super(key: key);

  static T ofType<T extends ModBloc>(BuildContext cntxt) {
    //final type = _providerType<LoginBlocProvider<T>>();
    final LoginBlocProvider<T> provider = cntxt.findAncestorWidgetOfExactType() as LoginBlocProvider<T>;
    return provider.bloc;
  }

  //static Type _providerType<T>() => T;

  @override
  State<StatefulWidget> createState() => _LoginBlocProviderState();
}

///
/// Companion state class
///
class _LoginBlocProviderState extends State<LoginBlocProvider> {

  _LoginBlocProviderState() : super();

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    this.widget.bloc?.dispose();
    super.dispose();
  }
}