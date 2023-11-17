import 'package:flutter/services.dart';
import 'package:login_module/business/repo/ISessionRepo.dart';
import 'package:login_module/common/ErrorCodes.dart';
import 'package:login_module/common/ModLogger.dart';
import 'package:login_module/data/api/ISessionApi.dart';
import 'package:login_module/data/exception/ModCancelledException.dart';
import 'package:login_module/data/exception/DataException.dart';
import 'package:login_module/models/ThirdPartyCheckModel.dart';
import 'package:login_module/network/api/exception/InvalidEmailException.dart';
import 'package:login_module/network/api/exception/UnverifiedMailException.dart';
import 'package:login_module/network/api/exception/UserDisabledException.dart';
import 'package:login_module/network/api/exception/UserNotFoundException.dart';
import 'package:login_module/network/api/exception/WrongPasswordException.dart';
import 'package:login_module/network/api/impl/session/SessionApiImpl.dart';
import '../../models/ThirdPartySessionModel.dart';

const String TAG = "SessionRepoImpl";

class SessionRepoImpl implements ISessionRepo {
  final ISessionApi api = SessionApiImpl();

  SessionRepoImpl();

  @override
  Future<ThirdPartyCheckModel> checkSignersAvailable(
      List<String> signers) async {
    var input = signers.map((e) => fromString(e)).toList();

    return ThirdPartyCheckModel(await this.api.checkAvailableMethods(input));
  }

  @override
  Future<ThirdPartySessionModel> signUp(
      String mail, String pass, String name) async {
    try {
      var data = await this.api.signUp(mail, pass);

      // DATA
      if (data != null) {
        String token = await data.getIdToken(true);

        if (!data.emailVerified) {
          await this.api.sendEmail();
        }

        return ThirdPartySessionModel(
          token: token,
          display: data.displayName,
          mail: data.email,
          pic: data.photoURL,
          mailValidationDone: data.emailVerified,
        );

        // NO DATA
      } else {
        throw Exception();
      }
    } on PlatformException catch (pe) {
      ModLogger.e(tag: TAG, msg: "${pe.toString()}", error: pe);
      throw pe;
    } on Exception catch (e) {
      ModLogger.e(tag: TAG, msg: "${e.toString()}", error: e);
      throw DataException();
    }
  }

  @override
  Future<ThirdPartySessionModel?> signIn(
      String mail, String pass, SessionTypes type) async {
    try {
      var data = await this.api.signIn(mail, pass, type);

      // DATA
      if (data != null) {
        String token = await data.getIdToken(true);

        ModLogger.d(
            "$TAG retrieved user: ${data.toString()} with token: ${token}");

        return ThirdPartySessionModel(
            token: token,
            display: data.displayName ?? "",
            mail: data.email,
            pic: data.photoURL ?? "",
            mailValidationDone: data.emailVerified);

        // NO DATA
      } else {
        return null;
      }
    } on ModCancelledException catch (lce) {
      ModLogger.e(tag: TAG, msg: "${lce.toString()}", error: lce);
      return ThirdPartySessionModel.empty();
    } on InvalidEmailException catch (lce) {
      ModLogger.e(tag: TAG, msg: "${lce.toString()}", error: lce);
      throw DataException(ErrorCodes.SIGNIN_INVALID_EMAIL, lce.message);
    } on UserDisabledException catch (lce) {
      ModLogger.e(tag: TAG, msg: "${lce.toString()}", error: lce);
      throw DataException(ErrorCodes.SIGNIN_USER_DISABLED, lce.message);
    } on UserNotFoundException catch (lce) {
      ModLogger.e(tag: TAG, msg: "${lce.toString()}", error: lce);
      throw DataException(ErrorCodes.SIGNIN_USER_NOT_FOUND, lce.message);
    } on WrongPasswordException catch (lce) {
      ModLogger.e(tag: TAG, msg: "${lce.toString()}", error: lce);
      throw DataException(ErrorCodes.SIGNIN_WRONG_PASSWORD, lce.message);
    } on UnverifiedMailException catch (lce) {
      ModLogger.e(tag: TAG, msg: "${lce.toString()}", error: lce);
      throw DataException(ErrorCodes.SIGNIN_UNVERIFIED_EMAIL, lce.message);
    } on PlatformException catch (pe) {
      ModLogger.e(tag: TAG, msg: "${pe.toString()}", error: pe);
      throw pe;
    } on Exception catch (e) {
      ModLogger.e(tag: TAG, msg: "${e.toString()}", error: e);
      throw DataException();
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await this.api.signOut();

      return true;
    } on Exception catch (e) {
      ModLogger.e(tag: TAG, msg: "${e.toString()}", error: e);
      throw DataException();
    }
  }
}
