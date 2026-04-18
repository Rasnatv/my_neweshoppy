// lib/app/services/network_service.dart
import 'package:get/get.dart';

class NetworkService extends GetxService {
  var reconnectTrigger = 0.obs;

  void onReconnected() {
    reconnectTrigger.value++;
  }
}