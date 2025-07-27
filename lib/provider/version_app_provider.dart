import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionAppProvider with ChangeNotifier {
  String _version = '';

  String get version => _version;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  Future<void> getVersionApp() async {
    _packageInfo = await PackageInfo.fromPlatform();
    _version = _packageInfo.version;
    notifyListeners();
  }
}
