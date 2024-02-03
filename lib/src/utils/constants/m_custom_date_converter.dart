
import 'package:intl/intl.dart';

class MyDateConverter {
  static String convertTaskTime(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  static String isoStringToLocalAMPM(DateTime dateTime) {
    return DateFormat('a').format(dateTime);
  }
  static String isoStringToLocalTimeOnly(DateTime dateTime) {
    return DateFormat('hh:mm aa').format(dateTime);
  }

}
