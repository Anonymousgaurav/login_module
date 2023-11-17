import 'package:flutter/material.dart';
import 'package:login_module/presentation/widgets/convenient/ModLoadingWidget.dart';

///
/// Custom base class for stateless widgets
///
abstract class ModBaseStatelessWidget extends StatelessWidget {

  const ModBaseStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context);

  Widget empty(BuildContext cntxt, String msg) => Center(child: Text(msg));

  Widget loading({required BuildContext cntxt, String msg = "...", bool visible = true}) =>
      Visibility(
        visible: visible,
        child: ModLoadingWidget(),
      );
}
