import 'package:shared_preferences/shared_preferences.dart';

class UserInfoModel {
  String selectedPhoneNumber;

  UserInfoModel() {
    init();
  }

  init() async {
    await selectedPhoneNumber = SharedPreferences
        .getInstance()
        .then((preferences) {
      return preferences.getString("phoneNumber") ?? "";
    }).then((phoneNumber) => selectedPhoneNumber = phoneNumber);
  }

  bool validatePhoneNumber(String phoneNumber) {
    return RegExp(r"\+380\d{9}").hasMatch(phoneNumber);
  }

  setPhoneNumber(String phoneNumber) {
    if (validatePhoneNumber(phoneNumber)) {
      selectedPhoneNumber.whenComplete(() => Future<String>.value(phoneNumber));
      SharedPreferences.getInstance().then((preferences) {
        preferences.setString("phoneNumber", phoneNumber);
      });
    }
  }
}