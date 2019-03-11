class LogInfo {
  final String registrationDate;
  final String totalTime;
  bool isFinished;

  LogInfo(this.registrationDate, this.totalTime, this.isFinished);

  @override
  String toString() {
    return registrationDate + "\t" + " (${isFinished ? "finished" : "continue"})";
  }

  @override
  bool operator ==(other) {
    if (other is LogInfo) {
      return this.registrationDate == other.registrationDate
          && this.totalTime == other.totalTime
          && this.isFinished == other.isFinished;
    }
    return false;
  }

  @override
  int get hashCode {
    return registrationDate.hashCode ^ totalTime.hashCode ^ isFinished.hashCode;
  }
}