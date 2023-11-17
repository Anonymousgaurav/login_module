import 'package:flutter/material.dart';

/**
 * Base state class for stateful widgets
 */
abstract class ModBaseState<T extends StatefulWidget> extends State<T> {

  ModBaseState() : super();

  /**
   * Must be overriden by children
   */
  @override
  Widget build(BuildContext context) {
    return Container(width: 0.0, height: 0.0);
  }
}
