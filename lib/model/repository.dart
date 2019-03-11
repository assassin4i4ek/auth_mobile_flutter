import 'package:authentication_mobile/model/log_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserState {
  bool isRegistered;
  String displayMessage;
}

abstract class IRepository {
  Future<UserState> getUserState(String phoneNumber);
  Future<UserState> changeUserState(String phoneNumber);
  Future<List<LogInfo>> getUserLog(String phoneNumber);
}

class SharedPreferencesRepository implements IRepository {
  @override
  Future<UserState> getUserState(String phoneNumber) async {
    var preferences = await SharedPreferences.getInstance();
    var userStateMessage = preferences.getString(phoneNumber)
        ?? "false\\Ви ще не заходили у систему.";
    var userState = UserState();
    userState.isRegistered = userStateMessage.startsWith("true\\");
    userState.displayMessage = "${userStateMessage
        .substring(userStateMessage.indexOf("\\") + 1)}";
    return userState;
  }

  @override
  Future<UserState> changeUserState(String phoneNumber) async {
    var preferences = await SharedPreferences.getInstance();
    var userStateMessage = preferences.getString(phoneNumber)
        ?? "false\\Ви ще не заходили у систему";
    var userState = UserState();
    var currentTime = DateTime.now();
    if (userStateMessage.startsWith("true\\")) {
      userState.isRegistered = false;
      preferences.setString(phoneNumber, "false\\Останній раз ви реєструвалися "
          "о ${_formatDateTime(currentTime)}");
      userState.displayMessage = "Ви вийшли із системи. "
          "Гарного відпочинку!";
    }
    else {
      userState.isRegistered = true;
      preferences.setString(phoneNumber, "true\\Ви знаходитесь у системі з "
          "${_formatDateTime(currentTime)}");
      userState.displayMessage = "Ви увійшли до системи. "
          "Гарного робочого дня!";
    }
    logState(phoneNumber, userState.isRegistered, currentTime);
    return userState;
  }

  @override
  Future<List<LogInfo>> getUserLog(String phoneNumber) async {
    var preferences = await SharedPreferences.getInstance();
    var log = List<String>.from(preferences
        .getStringList(phoneNumber + "_log") ?? List(0));
    bool isRegistered = (preferences.getString(phoneNumber) ?? "false\\")
        .startsWith("true\\");

    if (isRegistered) {
      var lastLog = log.removeLast();
      var logInTime = _dateTimeFromString(lastLog);
      log.add(_formatDate(logInTime) + '\t'
          + _formatDuration(DateTime.now().difference(logInTime)));
    }
    var logInfoList = log.map((logStr) {
      var split = logStr.split("\t");
      return LogInfo(split[0], split[1], true);
    }).toList();

    if (logInfoList.length > 0) {
      logInfoList.last?.isFinished = !isRegistered;
    }

    return logInfoList.reversed.toList();
  }

  void logState(String phoneNumber, bool isRegistered,
      DateTime currentDateTime) async {
    var preferences = await SharedPreferences.getInstance();
    var log = List<String>.from(preferences
        .getStringList(phoneNumber + "_log") ?? List(0));
    if (isRegistered) {
      log.add(_formatDateTime(currentDateTime));
    }
    else {
      var lastLog = log.removeLast();
      var logInTime = _dateTimeFromString(lastLog);
      var newLog = _formatDate(logInTime) + "\t" +
          _formatDuration(currentDateTime.difference(logInTime));
      log.add(newLog);
    }
    preferences.setStringList(phoneNumber + "_log", log);
  }

  RegExp _dateTimeRegExp = RegExp(
      r"^(\d{1,2})-(\d{1,2})-(\d{1,4})\s(\d{1,2}):(\d{1,2}):(\d{1,2})$");
  DateTime _dateTimeFromString(String string) {
    var match = _dateTimeRegExp.firstMatch(string);
    return DateTime(
        int.parse(match.group(3)),
        int.parse(match.group(2)),
        int.parse(match.group(1)),
        int.parse(match.group(4)),
        int.parse(match.group(5)),
        int.parse(match.group(6))
    );
  }

  static String _formatDateTime(DateTime datetime) {
    return _formatDate(
        datetime) + " " + _formatTime(datetime);
  }

  static String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  static String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute}:${time.second}";
  }

  static String _formatDuration(Duration duration) {
    String durationString = "";
    int hours = duration.inHours;
    if (hours != 0) {
      durationString = "$hours год";
    }

    int minutes = duration.inMinutes.remainder(60);
    if (durationString == "") {
      if (minutes != 0) {
        durationString = "$minutes хв";
      }
    }
    else {
      durationString += " $minutes хв";
    }

    int seconds = duration.inSeconds.remainder(60);
    if (durationString == "") {
      if (seconds != 0) {
        durationString = "$seconds с";
      }
    }
    else {
      durationString += " $seconds с";
    }

    if (durationString == "") {
      durationString = "${duration.inMilliseconds} мс";
    }

    return durationString;
  }
}