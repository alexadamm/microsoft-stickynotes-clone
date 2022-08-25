class LastUpdate {
  int updatedAt;
  int timeNow = DateTime.now().millisecondsSinceEpoch;
  LastUpdate({required this.updatedAt});

  whenUpdatedAt() {
    int sec = ((timeNow - updatedAt) / 1000).floor();
    if (sec < 60) return second(60);
    if (sec >= 60 && sec < 3600) return minute(sec);
    if (sec >= 3600 && sec < 86400) return hour(sec);
    if (sec >= 86400 && sec < 604800) return day(sec);
    if (sec >= 604800 && sec < 2629800) return week(sec);
    if (sec >= 2629800 && sec < 31557600) return year(sec);
    return year(sec);
  }

  static String second(int sec) {
    return 'Just now';
  }

  static String minute(int sec) {
    int min = (sec / 60).floor();
    return '$min ${min > 1 ? 'minutes' : 'minute'} ago';
  }

  static String hour(int sec) {
    int hour = (sec / 3600).floor();
    return '$hour ${hour > 1 ? 'hours' : 'hour'} ago';
  }

  static String day(int sec) {
    int day = (sec / 86400).floor();
    return '$day ${day > 1 ? 'days' : 'day'} ago';
  }

  static String week(int sec) {
    int week = (sec / 604800).floor();
    return '$week ${week > 1 ? 'weeks' : 'week'} ago';
  }

  static String month(int sec) {
    int month = (sec / 2629800).floor();
    return '$month ${month > 1 ? 'months' : 'month'} ago';
  }

  static String year(int sec) {
    int year = (sec / 31557699).floor();
    return '$year ${year > 1 ? 'years' : 'year'} ago';
  }
}
