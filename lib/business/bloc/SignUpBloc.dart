import 'package:login_module/business/bloc/core/ModBloc.dart';
import 'package:login_module/business/dto/SignUpDTO.dart';
import 'package:login_module/business/repo/ISessionRepo.dart';
import 'package:login_module/common/ErrorCodes.dart';
import 'package:login_module/data/exception/DataException.dart';
import 'package:login_module/data/repos/SessionRepoImpl.dart';
import 'package:login_module/models/ThirdPartySessionModel.dart';

const String TAG = "SignUpBloc";


class SignUpBloc extends ModBloc<SignUpDTO, ThirdPartySessionModel> {
  final ISessionRepo repo = SessionRepoImpl();

  SignUpBloc() : super();

  @override
  void performOperation(SignUpDTO dto) async {

    var res;
    try {
      var data = await this.repo.signUp(dto.mail, dto.pass, dto.name);

      res = this.buildResult(data: data);

    } on DataException catch (lde) {
      res = this.buildResult(data: null, code: ErrorCodes.SIGNUP);

    } on Exception catch (e) {
      res = this.buildResult(data: null, code: ErrorCodes.SIGNUP);

    } finally {
      this.processData(res);
    }
  }
}