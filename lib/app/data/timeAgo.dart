String dateTimeAgo(String timestamp) {
  var time = DateTime.parse(timestamp);
  var now = DateTime.now();
  var difference = now.difference(time);
  var seconds = difference.inSeconds;
  var minutes = difference.inMinutes;
  var hours = difference.inHours;
  var days = difference.inDays;
  var weeks = (days / 7).floor();
  var months = (days / 30).floor();
  var years = (days / 365).floor();
  if (seconds < 60) {
    return '$seconds secs ago';
  } else if (minutes < 60) {
    return '$minutes mins ago';
  } else if (hours < 24) {
    return '$hours hrs ago';
  } else if (days < 7) {
    return '$days days ago';
  } else if (weeks < 4) {
    return '$weeks weeks ago';
  } else if (months < 12) {
    return '$months months ago';
  } else {
    return '$years years ago';
  }
}
