import 'package:flutter/widgets.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic> _resJson = {};

  Map<String, dynamic> get resJson => _resJson;

  void updateResJson(Map<String, dynamic> value) {
    _resJson = value;
    Future.delayed(Duration(seconds: 0))
        .then((value) => super.notifyListeners());
  }
}
