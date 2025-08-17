import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class NetworkService with ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  NetworkService() {
    _checkInitialStatus();
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final online = results.isNotEmpty && results.first != ConnectivityResult.none;
      if (online != _isOnline) {
        _isOnline = online;
        notifyListeners();
      }
    });
  }

  Future<void> _checkInitialStatus() async {
    final results = await Connectivity().checkConnectivity();
    _isOnline = results.isNotEmpty && results.first != ConnectivityResult.none;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
