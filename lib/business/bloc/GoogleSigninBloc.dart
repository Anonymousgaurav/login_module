import 'package:login_module/business/bloc/core/BaseSigninBloc.dart';
import 'package:login_module/business/dto/SessionDTO.dart';
import 'package:login_module/common/ErrorCodes.dart';
import 'package:login_module/data/api/ISessionApi.dart';
import 'package:login_module/models/ThirdPartySessionModel.dart';

const String TAG = "GoogleSigninBloc";

class GoogleSigninBloc extends BaseSigninBloc {

  GoogleSigninBloc() : super();

  @override
  Future<ThirdPartySessionModel?> callAuthentication(SessionDTO dto) async {
    return await this.repo.signIn(
        dto.mail,
        dto.pass,
        SessionTypes.GOOGLE);
  }

  @override
  int getErrorCode({Exception? e}) => ErrorCodes.GOOGLE_SIGNIN;
}