import 'package:login_module/business/bloc/core/BaseSigninBloc.dart';
import 'package:login_module/business/dto/SessionDTO.dart';
import 'package:login_module/common/ErrorCodes.dart';
import 'package:login_module/data/api/ISessionApi.dart';
import 'package:login_module/models/ThirdPartySessionModel.dart';

const String TAG = "AppleSigninBloc";

class AppleSigninBloc extends BaseSigninBloc {

  AppleSigninBloc() : super();

  @override
  Future<ThirdPartySessionModel?> callAuthentication(SessionDTO dto) async {
    return await this.repo.signIn(
        dto.mail,
        dto.pass,
        SessionTypes.APPLE);
  }

  @override
  int getErrorCode({Exception? e}) => ErrorCodes.APPLE_SIGNIN;
}