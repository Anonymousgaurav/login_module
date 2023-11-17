import 'package:flutter/material.dart';
import 'package:login_module/presentation/resources/LoginColors.dart';

///
/// Custom loading widget
///
class ModLoadingWidget extends StatelessWidget {
  final Color? color;

  const ModLoadingWidget({this.color = LoginColors.darkGreyColor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(backgroundColor: this.color,));
  }
}
