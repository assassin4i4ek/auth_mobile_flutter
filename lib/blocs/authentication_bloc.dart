import 'dart:async';
import 'package:authentication_mobile/model/log_info.dart';
import 'package:authentication_mobile/model/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AlertType {
  SUCCESS, INFO, ERROR
}

enum PhoneNumberState {
  ABSENT_PHONE_NUMBER, CORRECT_PHONE_NUMBER, INCORRECT_PHONE_NUMBER
}

enum UserStateAction {
  UPDATE, SWITCH, VIEW_LOG
}

class AlertMessage {
  final AlertType alertType;
  final String message;

  AlertMessage(this.alertType, this.message);

  @override
  bool operator ==(other) {
    if (other is AlertMessage) {
      return this.alertType == other.alertType && this.message == other.message;
    }
    return false;
  }

  @override
  int get hashCode {
    return alertType.hashCode ^ message.hashCode;
  }

  @override
  String toString() {
    return alertType.toString() + ": " + message;
  }
}

class AuthenticationBloc {
  //Alert message
  var _alertMessageStreamController = StreamController<AlertMessage>.broadcast();
  Stream<AlertMessage> get messages => _alertMessageStreamController.stream;
  //User state action
  var _userStateActionStreamController = StreamController<UserStateAction>();
  StreamSink<UserStateAction> get userStateActionSink =>
      _userStateActionStreamController.sink;
  //User state
  var _userRegisteredStateStreamController = StreamController<bool>();
  Stream<bool> get userStateStream =>
      _userRegisteredStateStreamController.stream;
  //Phone number
  var _phoneNumberStreamController = StreamController<String>.broadcast();
  StreamSink<String> get phoneNumberSink => _phoneNumberStreamController.sink;
  Stream<PhoneNumberState> get phoneNumberStateStream =>
      _phoneNumberStreamController.stream.map(_validatePhoneNumber);
  Stream<String> get phoneNumberStream => _phoneNumberStreamController.stream;
  //User log
  var _userLogStreamController = StreamController<List<LogInfo>>.broadcast();
  Stream<List<LogInfo>> get userLog => _userLogStreamController.stream;

  IRepository _repository;
  String _phoneNumber = "";

  AuthenticationBloc({IRepository repository}) {
    if (repository == null) {
      repository = SharedPreferencesRepository();
    }
    _repository = repository;
    init();
  }

  void init() async {
    var preferences = await SharedPreferences.getInstance();
    _phoneNumber = preferences.getString("phoneNumber") ?? "";
    phoneNumberSink.add(_phoneNumber);
    _userStateActionStreamController.stream.listen((event) {
      if (validatePhoneNumber(_phoneNumber)) {
        if (event == UserStateAction.SWITCH
            || event == UserStateAction.UPDATE) {
          Future<UserState> future;
          AlertType alertType;
          if (event == UserStateAction.UPDATE) {
            future = _repository.getUserState(_phoneNumber);
            alertType = AlertType.INFO;
          }
          else if (event == UserStateAction.SWITCH) {
            future = _repository.changeUserState(_phoneNumber);
            alertType = AlertType.SUCCESS;
          }

          future.then((userState) {
            _alertMessageStreamController.sink
                .add(AlertMessage(alertType, userState.displayMessage));
            _userRegisteredStateStreamController.sink
                .add(userState.isRegistered);
          });
        }
        else if (event == UserStateAction.VIEW_LOG) {
          _repository.getUserLog(_phoneNumber).then((userLog) {
            _userLogStreamController.sink.add(userLog);
          });
        }
      }
      else {
        phoneNumberSink.add(_phoneNumber);
      }
    });
    _userStateActionStreamController.sink.add(UserStateAction.UPDATE);
  }

  final _phoneNumberRegExp = RegExp(r"^\+380\d{9}$");

  bool validatePhoneNumber(String phoneNumber) {
    if (_phoneNumberRegExp.hasMatch(phoneNumber)) {
      return true;
    }
    else {
      return false;
    }
  }

  PhoneNumberState _validatePhoneNumber(String phoneNumber) {
    if (phoneNumber == "") {
      return PhoneNumberState.ABSENT_PHONE_NUMBER;
    }
    else {
      if (_phoneNumberRegExp.hasMatch(phoneNumber)) {
        _phoneNumber = phoneNumber;
        SharedPreferences.getInstance().then((preferences) {
          preferences.setString("phoneNumber", phoneNumber);
        });
        return PhoneNumberState.CORRECT_PHONE_NUMBER;
      }
      else {
        return PhoneNumberState.INCORRECT_PHONE_NUMBER;
      }
    }
  }

  void dispose() {
    _alertMessageStreamController.close();
    _userStateActionStreamController.close();
    _userRegisteredStateStreamController.close();
    _phoneNumberStreamController.close();
    _userLogStreamController.close();
  }
}