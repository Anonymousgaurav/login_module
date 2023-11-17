import 'package:login_module/business/bloc/core/ModBloc.dart';
import 'package:login_module/business/dto/CheckSignersDTO.dart';
import 'package:login_module/business/repo/ISessionRepo.dart';
import 'package:login_module/common/ErrorCodes.dart';
import 'package:login_module/data/exception/DataException.dart';
import 'package:login_module/data/repos/SessionRepoImpl.dart';
import 'package:login_module/models/ThirdPartyCheckModel.dart';

const String TAG = "CheckSigninMethodsBloc";


class CheckSigninMethodsBloc extends ModBloc<CheckSignersDTO, ThirdPartyCheckModel> {
  final ISessionRepo repo = SessionRepoImpl();

  CheckSigninMethodsBloc() : super();

  @override
  void performOperation(CheckSignersDTO dto) async {

    var res;
    try {
      var data = await this.repo.checkSignersAvailable(dto.targets);

      res = this.buildResult(data: data);

    } on DataException catch (lde) {
      res = this.buildResult(data: null, code: ErrorCodes.CHECK_METHODS);

    } on Exception catch (e) {
      res = this.buildResult(data: null, code: ErrorCodes.CHECK_METHODS);

    } finally {
      this.processData(res);
    }
  }
}