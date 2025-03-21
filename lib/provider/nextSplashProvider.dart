
import 'package:flutter/widgets.dart';

class nextSplashProvider extends ChangeNotifier{
  bool _isLoading = false;
  bool get isloading => _isLoading;

  void setLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }
}