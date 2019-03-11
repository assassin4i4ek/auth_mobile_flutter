// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:authentication_mobile/blocs/authentication_bloc.dart';
import 'package:authentication_mobile/model/log_info.dart';
import 'package:authentication_mobile/model/repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

  const MethodChannel('plugins.flutter.io/shared_preferences')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{}; // set initial values here if desired
    }
    return null;
  });

  test("Phone number validation test", () {
    AuthenticationBloc bloc = AuthenticationBloc();
    expect(bloc.validatePhoneNumber(""), false);
    expect(bloc.validatePhoneNumber("+380XXXXXXXXX"), false);
    expect(bloc.validatePhoneNumber("+380999999999"), true);
  });

  test("Authentication Bloc phone number streams test", () async {
    AuthenticationBloc bloc = AuthenticationBloc();

    //emits empty phone number
    var f1 = expectLater(
        bloc.phoneNumberStream,
        emits(""));

    //emits absent phone number state
    var f2 = expectLater(
      bloc.phoneNumberStateStream,
      emits(PhoneNumberState.ABSENT_PHONE_NUMBER));

    await f1;
    await f2;

    f1 = expectLater(
        bloc.phoneNumberStream, emitsInOrder([
          "+380XXX", "+380999999999"
    ]));

    f2 = expectLater(
        bloc.phoneNumberStateStream, emitsInOrder([
          PhoneNumberState.INCORRECT_PHONE_NUMBER,
          PhoneNumberState.CORRECT_PHONE_NUMBER
    ]));

    bloc.phoneNumberSink.add("+380XXX");
    bloc.phoneNumberSink.add("+380999999999");

    await f1;
    await f2;

    await SharedPreferences.getInstance().then((preferences) {
      preferences.setString("phoneNumber", null);
    });
  });

  test("Authentication bloc message", () async {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString("phoneNumber", "+380999999999");

    AuthenticationBloc bloc = AuthenticationBloc(repository: MockRepository());

    await expectLater(
      bloc.phoneNumberStream,
      emits("+380999999999"));

    var f1 = expectLater(
        bloc.messages,
        emitsInOrder([
          AlertMessage(AlertType.INFO, "false"),
          AlertMessage(AlertType.INFO, "false"),
          AlertMessage(AlertType.SUCCESS, "true"),
          AlertMessage(AlertType.INFO, "true"),
          AlertMessage(AlertType.SUCCESS, "false"),
          AlertMessage(AlertType.INFO, "false"),
        ]));

    var f2 = expectLater(
      bloc.userStateStream,
      emitsInOrder([
        false,
        false,
        true,
        true,
        false,
        false,
      ]));

    bloc.userStateActionSink.add(UserStateAction.UPDATE);
    bloc.userStateActionSink.add(UserStateAction.SWITCH);
    bloc.userStateActionSink.add(UserStateAction.UPDATE);
    bloc.userStateActionSink.add(UserStateAction.SWITCH);
    bloc.userStateActionSink.add(UserStateAction.UPDATE);

    await f1;
    await f2;
  });

  test("Authentication bloc view log test", () async {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString("phoneNumber", "+380999999999");

    var bloc = AuthenticationBloc(repository: MockRepository());

    var f1 = expectLater(bloc.userLog, emitsInOrder([
      List<LogInfo>(0),
      List.of([LogInfo("","",false)]),
      List.of([LogInfo("","",false), LogInfo("","",true)]),
    ]));

    bloc.userStateActionSink.add(UserStateAction.VIEW_LOG);
    bloc.userStateActionSink.add(UserStateAction.SWITCH);
    bloc.userStateActionSink.add(UserStateAction.VIEW_LOG);
    bloc.userStateActionSink.add(UserStateAction.SWITCH);
    bloc.userStateActionSink.add(UserStateAction.VIEW_LOG);

    await f1;
  });

  test("Repository log test", () async {
    IRepository repository = SharedPreferencesRepository();
    String phoneNumber = "+380999999999";

    expect(await repository.getUserLog(phoneNumber), List(0));

    await repository.changeUserState(phoneNumber);

    expect((await repository.getUserLog(phoneNumber)).length, 1);

    await repository.changeUserState(phoneNumber);

    expect((await repository.getUserLog(phoneNumber)).length, 1);

    await repository.changeUserState(phoneNumber);

    expect((await repository.getUserLog(phoneNumber)).length, 2);
  });
}

class MockRepository extends IRepository {
  UserState _userState = UserState();
  List<LogInfo> _userLog = List<LogInfo>();

  MockRepository() {
    _userState.isRegistered = false;
    _userState.displayMessage = _userState.isRegistered.toString();
  }

  @override
  Future<UserState> changeUserState(String phoneNumber) {
    return Future(() {
      _userState.isRegistered = !_userState.isRegistered;
      _userState.displayMessage = _userState.isRegistered.toString();
      _userLog.add(LogInfo("", "", !_userState.isRegistered));
      return _userState;
    });
  }

  @override
  Future<UserState> getUserState(String phoneNumber) {
    return Future(() {
      return _userState;
    });
  }

  @override
  Future<List<LogInfo>> getUserLog(String phoneNumber) {
    return Future(() {
      return _userLog;
    });
  }

}