import 'dart:async';

import 'package:login_module/business/dto/core/BaseDTO.dart';
import 'package:login_module/models/ModResourceResult.dart';
import 'package:login_module/models/ThirdPartyErrorModel.dart';


/**
 * Base class for business logic components (BLoC's).
 * Opens data channel with binded widget.
 *
 * Uses parametric types for both input and output types:
 * - In: data type used for bloc data input
 * - Out: data type returned by operation. Will be wrapped inside an ResourceResult when sent to UI
 *
 * Child classes must override abstract methods.
 */
abstract class ModBloc<In extends BaseDTO, Out> {

  /**
   * Stream controller
   */
  final StreamController<ModResourceResult<Out>?> controller = StreamController<ModResourceResult<Out>?>();

  /**
   * Data stream (pipe) with binded widget
   */
  Stream<ModResourceResult<Out>?> get dataStream => this.controller.stream;

  /**
   * Abstraction to perform some operation using params received.
   * Must be overriden by children.
   */
  void performOperation(In dto);

  /**
   * Send data to binded widget automatically triggering a rebuild
   */
  void processData(ModResourceResult<Out>? data) {
    //XXX: send data down the pipe...
    if (!this.controller.isClosed) {
      this.controller.sink.add(data);
    }
  }

  /**
   * Free resources
   */
  void dispose() {
    this.controller.close();
  }

  /**
   * Encapsulate build result objects creation to avoid inconsistencies
   */
  ModResourceResult<Out> buildResult({Out? data = null, int code = -1}) {
    ModResourceResult<Out> res = ModResourceResult();

    res.data = data;
    res.state = res.hasData()? ResourceState.SUCCESS : ResourceState.ERROR;
    res.error = res.isError()? ThirdPartyErrorModel(code: code) : null;

    return res;
  }
}