import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_module/common/ModLogger.dart';
import 'package:login_module/data/api/ISessionApi.dart';
import 'package:login_module/data/exception/ModCancelledException.dart';
import 'package:login_module/network/api/exception/INetworkException.dart';
import 'package:login_module/network/api/exception/InvalidEmailException.dart';
import 'package:login_module/network/api/exception/UnverifiedMailException.dart';
import 'package:login_module/network/api/exception/UserDisabledException.dart';
import 'package:login_module/network/api/exception/UserNotFoundException.dart';
import 'package:login_module/network/api/exception/WrongPasswordException.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

const String OP_CANCELED = "sign_in_canceled";

const String TAG = "SessionApiImpl";

///
/// Implementation for 3rd party session api
///
class SessionApiImpl implements ISessionApi {
  final FirebaseAuth _generalAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleAuth = GoogleSignIn();

  SessionApiImpl();

  @override
  Future<User?> getUser() async {
    User? user = this._generalAuth.currentUser;
    if (!(user?.emailVerified ?? true)) {
      throw UnverifiedMailException();
    }
    return user;
  }

  @override
  Future<bool> isMailVerified() async {
    var user = await this.getUser();

    return user?.emailVerified ?? false;
  }

  @override
  Future<User?> changeName(String value) async {
    var user = await this.getUser();

    await user?.updateDisplayName(value);

    return user;
  }

  @override
  Future<void> sendEmail() async {
    var user = await this.getUser();

    return user?.sendEmailVerification();
  }

  @override
  Future<User?> signIn(String mail, String pass, SessionTypes type) async {
    try {
      var ret;
      switch (type) {
        case SessionTypes.GOOGLE:
          ret = await this._googleLogin();
          break;
        case SessionTypes.APPLE:
          ret = await this._appleLogin();
          break;
        case SessionTypes.CUSTOM:
          ret = await this._customLogin(mail, pass);
          break;
        default:
          throw Exception("$type did not handle in sign in");
      }

      return ret;
    } on PlatformException catch (pe) {
      if (pe.code == OP_CANCELED) {
        throw ModCancelledException();
      } else {
        throw pe;
      }
    } on INetworkException catch (e) {
      ModLogger.e(error: e);
      rethrow;
    } on Exception catch (e) {
      ModLogger.e(error: e);

      throw e;
    }
  }

  @override
  Future<void> signOut() async {
    if (await this._googleAuth.isSignedIn()) {
      this._googleAuth.signOut();
    }

    return await this._generalAuth.signOut();
  }

  @override
  Future<User?> signUp(String mail, String pass) async {
    return await this
        ._generalAuth
        .createUserWithEmailAndPassword(email: mail, password: pass)
        .then((value) => this.getUser());
  }

  Future<User?> _customLogin(String mail, String pass) async {
    try {
      await this
          ._generalAuth
          .signInWithEmailAndPassword(email: mail, password: pass);
      return getUser();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          throw InvalidEmailException(e.message);
        case "user-disabled":
          throw UserDisabledException(e.message);
        case "user-not-found":
          throw UserNotFoundException(e.message);
        case "wrong-password":
          throw WrongPasswordException(e.message);
        default:
          throw Exception(e.message);
      }
    }
  }

  Future<User?> _googleLogin() async {
    if (await this._googleAuth.isSignedIn()) {
      User? user = await this.getUser();
      // Logout googleAuth if firebaseAuth is not signed in
      if (user == null) {
        await this._googleAuth.signOut();
        return _googleLogin();
      }
      return user;
    } else {
      final googleAccount = await this._googleAuth.signIn();

      if (googleAccount != null) {
        final auth = await googleAccount.authentication;

        final credentials = GoogleAuthProvider.credential(
            idToken: auth.idToken, accessToken: auth.accessToken);

        final googleUser =
            (await this._generalAuth.signInWithCredential(credentials)).user;

        return googleUser;
      } else {
        throw PlatformException(code: OP_CANCELED);
      }
    }
  }

  Future<User?> _appleLogin() async {
    final AuthorizationResult res = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (res.status) {
      case AuthorizationStatus.authorized:
        final prov = OAuthProvider(SessionTypes.APPLE.getDomain());

        final AppleIdCredential? cred = res.credential;

        final AuthCredential creden = prov.credential(
            idToken: String.fromCharCodes(cred!.identityToken!),
            accessToken: String.fromCharCodes(cred.authorizationCode!));

        final appleUser =
            (await this._generalAuth.signInWithCredential(creden)).user;

        await appleUser?.updateDisplayName(cred.fullName!.givenName);

        return appleUser;

      case AuthorizationStatus.error:
        return null;

      case AuthorizationStatus.cancelled:
      default:
        throw PlatformException(code: OP_CANCELED);
    }
  }

  @override
  Future<Map<String, bool>> checkAvailableMethods(
      List<SessionTypes> candidates) async {
    var map = Map<String, bool>();

    if (candidates.contains(SessionTypes.APPLE)) {
      var appleAvailable = await TheAppleSignIn.isAvailable();
      map[SessionTypes.APPLE.getAsKey()] = appleAvailable;
    }

    if (candidates.contains(SessionTypes.GOOGLE)) {
      var googleAvailable = true;
      map[SessionTypes.GOOGLE.getAsKey()] = googleAvailable;
    }

    return map;
  }

  @override
  Future<bool> passwordReset() async {
    final user = await this.getUser();

    if (user != null) {
      await this._generalAuth.sendPasswordResetEmail(email: user.email!);

      return true;
    } else {
      ModLogger.e(
          tag: TAG,
          msg: "passwordReset() required but no user found",
          error: null);

      return false;
    }
  }

  @override
  Future<bool> retrievePass(String mail) async {
    await this._generalAuth.sendPasswordResetEmail(email: mail);

    return true;
  }
}
