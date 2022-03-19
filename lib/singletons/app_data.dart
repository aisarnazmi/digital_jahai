class AppData {
  static final AppData _appData = AppData._internal();

  // String userID, userPassword;

  // String deviceToken;

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}

final appData = AppData();
