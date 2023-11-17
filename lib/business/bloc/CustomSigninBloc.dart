import 'package:login_module/business/dto/SessionDTO.dart';
import 'package:login_module/models/ThirdPartySessionModel.dart';
import '../../data/api/ISessionApi.dart';
import '../../common/ErrorCodes.dart';
import 'core/BaseSigninBloc.dart';


const String TAG = "CustomSigninBloc";

class CustomSigninBloc extends BaseSigninBloc {

  CustomSigninBloc() : super();

  @override
  Future<ThirdPartySessionModel?> callAuthentication(SessionDTO dto) async {
    return await this.repo.signIn(
        dto.mail,
        dto.pass,
        SessionTypes.CUSTOM);
  }

  @override
  int getErrorCode({Exception? e}) => ErrorCodes.CUSTOM_SIGNIN;
}