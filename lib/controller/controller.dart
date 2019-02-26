
import 'package:authentication_mobile/model/user_info_model.dart';
import 'package:authentication_mobile/view/authentication_app.dart';
import 'package:flutter/material.dart';

class MyController {
  UserInfoModel _model = UserInfoModel();
  AuthenticationApplication _authenticationApp;


  MyController() {
    _authenticationApp = AuthenticationApplication(this);

    runApp(_authenticationApp);

    _model.selectedPhoneNumber.then((phoneNumber) {
      if (phoneNumber == "") {
        _authenticationApp.showPhoneNumberInputDialog();
      }
      else {

      }
    });
  }
}