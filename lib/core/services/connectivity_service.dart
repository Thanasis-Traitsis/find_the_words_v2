import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> hasInternet() async {
    final result = await _connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.none)) return false;

    try {
      final lookup = await InternetAddress.lookup(
        'google.com',
      ).timeout(Duration(seconds: 3));
      return lookup.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> canShowAds() async => await hasInternet();
}
