import 'package:flutter/foundation.dart';

printDebug(object, {String? title}) {
  if (kDebugMode) {
    debugPrint(" ---------------------\x1B[35m ${title ?? 'Debug Print Start'} \x1B[0m ------------------------------\x1B[0m\n"
        "${'\x1B[32m $object\x1B[0m'}"
        "\n \x1B[36m ----------------------------------------------------------------------\x1B[0m");
  }
}

printLog(
  object,
) {
  if (kDebugMode) {
    debugPrint("\x1B[35m  $object' ");
  }
}

printResponse(object) {
  if (kDebugMode) {
    debugPrint('\x1B[36m ------>$object\x1B[0m');
  }
}

printApiResponse(object, heading) {
  if (kDebugMode) {
    debugPrint("${'\x1B[33m Api ------> $heading \x1B[0m\n'}"
        "${'\x1B[33m Response------>  $object \x1B[0m'}");
  }
}

printApiError(object) {
  if (kDebugMode) {
    debugPrint('\x1B[31m Error------>  $object \x1B[0m');
  }
}
