import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../widgets/no_internet_sheet.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _subscription;
  bool _isDialogShowing = false;

  void init(BuildContext context) {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final hasInternet = results.any((r) => r != ConnectivityResult.none);
      if (!hasInternet) {
        _showNoInternetSheet(context);
      } else {
        if (_isDialogShowing) {
          Navigator.of(context, rootNavigator: true).pop();
          _isDialogShowing = false;
        }
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }

  void _showNoInternetSheet(BuildContext context) {
    if (_isDialogShowing) return;
    _isDialogShowing = true;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => const NoInternetSheet(),
    ).then((_) => _isDialogShowing = false);
  }
}