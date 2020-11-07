import 'package:intl/intl.dart';

class RelativeDateFormat {
  // ignore: non_constant_identifier_names
  static final num ONE_MINUTE = 60000;
  // ignore: non_constant_identifier_names
  static final num ONE_HOUR = 3600000;
  // ignore: non_constant_identifier_names
  static final num ONE_DAY = 86400000;
  // ignore: non_constant_identifier_names
  static final num ONE_WEEK = 604800000;
// ignore: non_constant_identifier_names
  static final String ONE_SECOND_AGO = "秒前";
  // ignore: non_constant_identifier_names
  static final String ONE_MINUTE_AGO = "分钟前";
  // ignore: non_constant_identifier_names
  static final String ONE_HOUR_AGO = "小时前";
  // ignore: non_constant_identifier_names
  static final String ONE_DAY_AGO = "天前";
  // ignore: non_constant_identifier_names
  static final String ONE_MONTH_AGO = "月前";
  // ignore: non_constant_identifier_names
  static final String ONE_YEAR_AGO = "年前";

  static String formatYYYYMMDDhhmmss(DateTime date) {
    var format = DateFormat("yyyy年MM月DD日 hh:mm:ss");

    return format.format(date);
  }

//时间转换
  static String format(DateTime date) {
    num delta =
        DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;
    if (delta < 1 * ONE_MINUTE) {
      num seconds = toSeconds(delta);
      return (seconds <= 0 ? 1 : seconds).toInt().toString() + ONE_SECOND_AGO;
    }
    if (delta < 60 * ONE_MINUTE) {
      num minutes = toMinutes(delta);
      return (minutes <= 0 ? 1 : minutes).toInt().toString() + ONE_MINUTE_AGO;
    }
    if (delta < 24 * ONE_HOUR) {
      num hours = toHours(delta);
      return (hours <= 0 ? 1 : hours).toInt().toString() + ONE_HOUR_AGO;
    }
    if (delta < 48 * ONE_HOUR) {
      return "昨天";
    }
    if (delta < 30 * ONE_DAY) {
      num days = toDays(delta);
      return (days <= 0 ? 1 : days).toInt().toString() + ONE_DAY_AGO;
    }
    // if (delta < 12 * 4 * ONE_WEEK) {
    //   num months = toMonths(delta);
    //   return (months <= 0 ? 1 : months).toInt().toString() + ONE_MONTH_AGO;
    // }
    return formatYYYYMMDDhhmmss(date);
  }

  static num toSeconds(num date) {
    return date / 1000;
  }

  static num toMinutes(num date) {
    return toSeconds(date) / 60;
  }

  static num toHours(num date) {
    return toMinutes(date) / 60;
  }

  static num toDays(num date) {
    return toHours(date) / 24;
  }

  static num toMonths(num date) {
    return toDays(date) / 30;
  }

  static num toYears(num date) {
    return toMonths(date) / 365;
  }
}

// 作者：爱拼才会赢007
// 链接：https://juejin.im/post/6844903848272740359
// 来源：掘金
// 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
