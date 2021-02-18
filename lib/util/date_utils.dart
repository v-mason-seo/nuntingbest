import 'package:intl/intl.dart';

class DateUtils {
  static final DateFormat _dayFormat = new DateFormat("yyyyMMdd");

  static String dayFormat(DateTime d) => _dayFormat.format(d);

  static DateTime nextDay(DateTime d) => d.add(Duration(days: 1));

  static String nextDayFormat(DateTime d) => dayFormat(d.add(Duration(days: 1)));

  static DateTime convertDateFromString(String d) => DateTime.parse(d);

  static DateTime convertDateFromyyyymmddhh(String d) {
    DateTime convertDateTime;

    if ( d.length != 10 ) {
      return DateTime.now();
    }

    try {
      String ago = '${d.substring(0, 8)} ${d.substring(8, 10)}';
      convertDateTime = convertDateFromString(ago);
    } catch(e) {
      convertDateTime = DateTime.now();
    }
    
    return convertDateTime;
  }
}