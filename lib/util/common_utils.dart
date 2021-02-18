class CommonUtils {
  static bool isEmpty(var val) {

    if ( val == null)
        return true;

    if ( val is List) {
      if ( val.length == 0)
        return true;
    } else if ( val is String) {
      if ( val.isEmpty)
        return true;
    }
    
    return false;
  }


  static bool isNotEmpty(var val) {

    return !isEmpty(val);
  }
}