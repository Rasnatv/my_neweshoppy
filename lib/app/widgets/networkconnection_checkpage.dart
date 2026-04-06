
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkAwareWrapper extends StatefulWidget {
  final Widget child;
  const NetworkAwareWrapper({super.key, required this.child});

  @override
  State<NetworkAwareWrapper> createState() => _NetworkAwareWrapperState();
}

class _NetworkAwareWrapperState extends State<NetworkAwareWrapper>
    with SingleTickerProviderStateMixin {
  bool _isOffline = false;
  late StreamSubscription _subscription;
  late AnimationController _animController;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));

    _checkConnection();

    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final offline = results.every((r) => r == ConnectivityResult.none);
      _updateStatus(offline);
    });
  }

  Future<void> _checkConnection() async {
    final results = await Connectivity().checkConnectivity();
    final offline = results.every((r) => r == ConnectivityResult.none);
    _updateStatus(offline);
  }

  void _updateStatus(bool offline) {
    if (!mounted) return;
    setState(() => _isOffline = offline);
    offline ? _animController.forward() : _animController.reverse();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      textDirection: TextDirection.ltr,
      alignment: Alignment.topCenter,
      children: [
        widget.child,
        SlideTransition(
          position: _slideAnim,
          child: _buildBanner(context),
        ),
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        color: const Color(0xFFD32F2F),
        padding: EdgeInsets.only(
          top: topPadding + 10,
          bottom: 10,
          left: 16,
          right: 12,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'No internet connection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              onTap: _checkConnection,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
