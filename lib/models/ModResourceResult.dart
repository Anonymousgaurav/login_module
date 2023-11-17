

import 'package:login_module/models/ThirdPartyErrorModel.dart';

///
/// Model used to wrap operation result
/// <T>: type for data field
///
class ModResourceResult<T> {
  ResourceState state;
  T? data;
  ThirdPartyErrorModel? error;

  ModResourceResult({this.state = ResourceState.LOADING, this.data, this.error}) : super();

  bool _validData() => this.data != null;

  bool _validError() => this.error != null;

  bool _isIterable() => this._validData() && (this.data is Iterable);

  bool hasDataButEmpty() => (this._isIterable()) && ((this.data as Iterable).isEmpty);

  bool hasData() => this._validData();

  bool hasError() => !this._validData() && this._validError();

  bool isSuccess() => this.state == ResourceState.SUCCESS;

  bool isError() => this.state == ResourceState.ERROR;
}

enum ResourceState {
  INITIAL, LOADING, SUCCESS, ERROR
}