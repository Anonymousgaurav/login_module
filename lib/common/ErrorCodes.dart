abstract class ErrorCodes {
  static const int OFFSET = 1000;

  static const int CUSTOM_SIGNIN = OFFSET + 10;
  static const int GOOGLE_SIGNIN = OFFSET + 20;
  static const int APPLE_SIGNIN = OFFSET + 30;
  static const int FACEBOOK_SIGNIN = OFFSET + 40;

  static const int SIGNIN = OFFSET + 50;
  static const int SIGNIN_INVALID_EMAIL = OFFSET + 51;
  static const int SIGNIN_USER_DISABLED = OFFSET + 52;
  static const int SIGNIN_USER_NOT_FOUND = OFFSET + 53;
  static const int SIGNIN_WRONG_PASSWORD = OFFSET + 54;
  static const int SIGNIN_UNVERIFIED_EMAIL = OFFSET + 55;

  static const int SIGNIN_NOT_AVAILABLE = OFFSET + 60;
  static const int INVALID_SESSION = OFFSET + 70;

  static const int CHECK_METHODS = OFFSET + 100;
  static const int DATA = OFFSET + 200;
  static const int API = OFFSET + 300;
  static const int SIGNUP = OFFSET + 400;
  static const int GENERAL = OFFSET + 500;

/**
 * + requiresMailValidation()
 * + LoginCancelledException
 * + LoginDataException
 * + PlatformException
 */
}

class ModErrorHelper {
  late final Map<int, String> msgs;

  List<int> keys = [
    ErrorCodes.CUSTOM_SIGNIN,
    ErrorCodes.GOOGLE_SIGNIN,
    ErrorCodes.APPLE_SIGNIN,
    ErrorCodes.FACEBOOK_SIGNIN,
    ErrorCodes.SIGNIN,
    ErrorCodes.SIGNIN_NOT_AVAILABLE,
    ErrorCodes.INVALID_SESSION,
    ErrorCodes.CHECK_METHODS,
    ErrorCodes.DATA,
    ErrorCodes.API,
    ErrorCodes.SIGNUP,
    ErrorCodes.GENERAL,
    ErrorCodes.SIGNIN_INVALID_EMAIL,
    ErrorCodes.SIGNIN_USER_DISABLED,
    ErrorCodes.SIGNIN_USER_NOT_FOUND,
    ErrorCodes.SIGNIN_WRONG_PASSWORD,
    ErrorCodes.SIGNIN_UNVERIFIED_EMAIL,
  ];

  ModErrorHelper._(String def) {
    this.msgs = {};

    this._populateMap();

    this._setDefaultMsg(def);
  }

  void _populateMap() {
    keys.forEach((int key) {
      this.msgs.putIfAbsent(key, () => "");
    });
  }

  void _setDefaultMsg(String def) {
    this.msgs[ErrorCodes.GENERAL] = def;
  }

  int getOffset() => ErrorCodes.OFFSET;

  String? getEntry(int code) {
    try {
      if (this.msgs.containsKey(code)) {
        final msg = this.msgs[code]!;

        if (msg.isEmpty) {
          throw Exception();
        }
        return msg;
      } else {
        throw Exception();
      }
    } on Exception {
      return this.msgs[ErrorCodes.GENERAL];
    }
  }

  void setEntry(int code, String str) {
    assert(_isValidKey(code));

    this.msgs[code] = str;
  }

  bool _isValidKey(int key) => this.keys.contains(key);

  static ModErrorHelper getInstance(String def) {
    if (_instance == null) {
      _instance = ModErrorHelper._(def);
    }

    return _instance!;
  }

  static ModErrorHelper? _instance;
}
