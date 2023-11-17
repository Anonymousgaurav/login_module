import 'package:flutter/services.dart';
import 'package:login_module/business/bloc/core/ModBloc.dart';
import 'package:login_module/business/dto/SessionDTO.dart';
import 'package:login_module/business/repo/ISessionRepo.dart';
import 'package:login_module/common/ModLogger.dart';
import 'package:login_module/data/exception/DataException.dart';
import 'package:login_module/data/repos/SessionRepoImpl.dart';
import 'package:login_module/models/ThirdPartySessionModel.dart';



const String TAG = "BaseSigninBloc";

abstract class BaseSigninBloc extends ModBloc<SessionDTO, ThirdPartySessionModel> {
  ISessionRepo repo = SessionRepoImpl();

  BaseSigninBloc() : super();

  @override
  void performOperation(SessionDTO dto) async {

    var res;
    try {
      var data = await this.callAuthentication(dto);
      if (data != null) {
        res = this.buildResult(data: data);
      } else {
        throw Exception();
      }

    } on DataException catch (lde) {
      ModLogger.e(tag: TAG, msg: "${lde.toString()}");

      res = this.buildResult(data: null, code:lde.code ?? this.getErrorCode());

    } on PlatformException catch (pe) {
      ModLogger.e(tag: TAG, msg: "${pe.toString()}");

      res = this.buildResult(data: null, code: this.getErrorCode(e: pe));

    } on Exception catch (e) {
      ModLogger.e(tag: TAG, msg: "${e.toString()}");

      res = this.buildResult(data: null, code: this.getErrorCode());

    } finally {
      this.processData(res);
    }
  }
  int getErrorCode({Exception? e});
  Future<ThirdPartySessionModel?> callAuthentication(SessionDTO dto);
}