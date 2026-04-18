
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import 'network_trihgiger.dart';
import 'noconnectionpageview.dart';

class NetworkAwareWrapper extends StatefulWidget {
  final Widget child;
  const NetworkAwareWrapper({super.key, required this.child});

  @override
  State<NetworkAwareWrapper> createState() =>
      _NetworkAwareWrapperState();
}

class _NetworkAwareWrapperState extends State<NetworkAwareWrapper> {
  bool _isOffline = false;
  int _reconnectCount = 0;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _checkConnection();

    _subscription =
        Connectivity().onConnectivityChanged.listen((results) {
          final offline =
          results.every((r) => r == ConnectivityResult.none);
          _updateStatus(offline);
        });
  }

  Future<void> _checkConnection() async {
    final results = await Connectivity().checkConnectivity();
    final offline =
    results.every((r) => r == ConnectivityResult.none);
    _updateStatus(offline);
  }

  void _updateStatus(bool offline) {
    if (!mounted) return;

    final wasOffline = _isOffline;

    setState(() {
      _isOffline = offline;

      // ✅ Only trigger when coming back online
      if (wasOffline && !offline) {
        _reconnectCount++;

        // ✅ Delay to stabilize internet (IMPORTANT)
        Future.delayed(const Duration(seconds: 2), () {
          if (Get.isRegistered<NetworkService>()) {
            Get.find<NetworkService>().onReconnected();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Show full screen when offline
    if (_isOffline) {
      return NoInternetPage(onRetry: _checkConnection);
    }

    // ✅ Normal app (NO red snackbar / NO banner)
    return KeyedSubtree(
      key: ValueKey(_reconnectCount), // refresh after reconnect
      child: widget.child,
    );
  }
}