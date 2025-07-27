import 'package:flutter/foundation.dart';

class TabProvider with ChangeNotifier {
  int _currentTabIndex = 0;

  int get currentTabIndex => _currentTabIndex;

  void setTabIndex(int index) {
    if (_currentTabIndex != index && index >= 0 && index < 4) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }
}
