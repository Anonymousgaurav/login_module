
import 'package:login_module/data/api/ISessionApi.dart';
import 'package:login_module/models/ThirdPartyCheckModel.dart';
import 'package:login_module/models/ThirdPartySessionModel.dart';

///
/// Abstraction for 3rd party session repository
///
abstract class ISessionRepo {
  Future<ThirdPartySessionModel> signUp(String mail, String pass, String name);
  Future<ThirdPartyCheckModel> checkSignersAvailable(List<String> signers);
  Future<ThirdPartySessionModel?> signIn(String mail, String pass, SessionTypes type);
  Future<bool> signOut();
}